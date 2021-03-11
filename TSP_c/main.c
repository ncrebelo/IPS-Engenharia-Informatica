#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include "array.h"
#include "utils.h"
#include <string.h>
#include <fcntl.h>
#include <sys/wait.h>
#include <sys/mman.h>
#include <sys/time.h>
#include <signal.h>
#include <semaphore.h>
#include <time.h>

// SHARED MMap
#define smmap(b) mmap(NULL, b, PROT_READ | PROT_WRITE | MAP_ANONYMOUS | MAP_SHARED, -1, 0)

/**
 * @brief struct for the arguments passed when ./main runs
 */
typedef struct Args Args;
struct Args{
    char file[256];
    int processesCount;
    int time;
};

//Semaphores
sem_t *hold; 
sem_t *start;
sem_t *finished;
sem_t *compared;

//worker information
pid_t *children;
int childrenCount;


void handleUpdateSignal(int signal);
Args validateArgs(int argc, char** argv);
int algortihmAJPE(int size, int path[size], int matrix[size][size]);
void printCommandsMenu();


int main(int argc, char** argv){

    srand(time(NULL));

    Args arguments = validateArgs(argc, argv); //arguments passed 

    int n = 0, sizeFromFile;
    n = getSize(arguments.file, &sizeFromFile);  // n = 1st number of file
    int matrixSize = squareRoot(&n); 

    PtArray arr = createArray(n); //create array to read the data in the file
    int matrix[matrixSize][matrixSize]; //create a base 2d array of matrixSize * matrixSize

    readFromFile(arguments.file, &arr); //reads file and imports to array
    memcpy(matrix,&arr->numbers[0], sizeof(matrix)); //copies the data from the array into a 2d matrix

    
    // Create shared memory map
    int protection = PROT_READ | PROT_WRITE;
    int visibility = MAP_ANONYMOUS | MAP_SHARED;

    void *shmem;
    shmem = mmap(NULL, 64, protection, visibility, 0, 0);
    
    //validating semaphores and opening them
    sem_unlink("hold"); 
    sem_unlink("start");
    sem_unlink("finished");
    sem_unlink("compared");

    sem_t *hold = sem_open("hold", O_CREAT, 0644, 0); 
    sem_t *start = sem_open("start", O_CREAT, 0644, 0);
    sem_t *finished = sem_open("finished", O_CREAT, 0644, 0);
    sem_t *compared = sem_open("compared", O_CREAT, 0644, 1);
 

    //register signal handler
    signal(SIGUSR1, handleUpdateSignal);
    signal(SIGUSR2, handleUpdateSignal);
    
    //array of workers
    childrenCount = arguments.processesCount; //sets the arg[ProcessCount] to number of Workers(i.e processes)
    int children[childrenCount];

    //handling time in seconds for While loop condition
    time_t startTime = time(NULL);
    time_t maxExecTime = arguments.time;
    time_t endTime = startTime + maxExecTime;
    
    //generates path from 1 to matrixSize
    int path[matrixSize];
    for(int i = 0; i < matrixSize; i++){
        path[i] = i + 1;
    }

    //Struct to handle time and return value,in miliseconds 
    struct timeval  tv1, tv2;
    
    int calculatedDistance,signal, count = 0;
    char *memString = malloc(sizeof (int*));
    int quit = 0;
    int option;
    printCommandsMenu();
    scanf("%d", &option);
    if(option == 1){
        printf("\n=========== Brute Force Calculation ===========");
        int resultArr[childrenCount]; //array used to store the calculated items in the Brute Force Algorithm.
        gettimeofday(&tv1, NULL); //start time
        while(count < childrenCount && startTime < endTime){   
            for(int i = 0; i < childrenCount; i++){
                calculatedDistance = algortihmAJPE(matrixSize, path, matrix);
                swap(matrixSize, path);
                resultArr[i] = calculatedDistance;
            }
            count++;
            startTime = time(NULL);//increments startTime variable
        }
        //Testing purposes only to show the set of values calculated in the array
        /**
        for(int i = 0; i < childrenCount; i++){
            printf("\n-> %d", resultArr[i]);
        }*/
        int best = minimumValue(childrenCount, resultArr);
        printf("\nBEST Possible Result = %d", best);
        gettimeofday(&tv2, NULL); //end time
        printf("\nCalculated in %f Seconds\n",(double)(tv2.tv_usec - tv1.tv_usec) / 1000000 + (double) (tv2.tv_sec - tv1.tv_sec));
        printf("======================| |======================\n");
    }
    else if(option == 2){
        printf("\n=========== Base AJPE Calculation ===========\n");
        gettimeofday(&tv1, NULL); //start time
        while(count < childrenCount && startTime < endTime){ 
            for(int i = 0; i < childrenCount; i++){
                children[i] = fork();
                swap(matrixSize, path);
                if(children[i] == 0){
                    while(1){
                        sem_wait(start);
                        int memValue = atoi(shmem);//string to int value of shmem
                        calculatedDistance = algortihmAJPE(matrixSize, path, matrix);
                        printf("Child #%d returned:  %d\n", getpid(), calculatedDistance);
                        //sets the first calculatedDistance to shared mem
                        if (memValue < 1) { 
                            sprintf(memString, "%i", calculatedDistance); //int to string
                            memcpy(shmem, memString, sizeof(memString));//copies new value in string format into shared mem
                        }
                        //compares result and value in shared mem
                        else if(memValue > calculatedDistance){ 
                            int newValue = compareValues(calculatedDistance, memValue);
                            sprintf(memString, "%i", newValue); //int to string
                            memcpy(shmem, memString, sizeof(memString));//copies new value in string format into shared mem
                            printf("Updated value in shmem: %s\n", (char*) shmem); 
                        }
                        //if shared mem is lower than calculated
                        else{
                            printf("NO UPDATE NEEDED!\n"); 
                        }               
                        sem_post(hold);  
                        sem_post(finished);
                        exit(0);
                    }    
                }
            }
            //parent process 
            sem_post(start);
            sem_wait(hold);
            printf("Value in shmem has been checked or updated. Current value = %s\n",(char*) shmem);
            sem_wait(finished);


            //while loop incrementors 
            count++;
            startTime = time(NULL);
        }
        printf("\nBEST Possible Result = %s",(char*) shmem);
        gettimeofday(&tv2, NULL); //end time     
        printf("\nCalculated in %f Seconds\n",(double)(tv2.tv_usec - tv1.tv_usec) / 1000000 + (double) (tv2.tv_sec - tv1.tv_sec));       
        printf("=====================| |=====================\n");
    }
    else if(option == 3){
        printf("\n=========== Advanced AJPE Calculation ===========\n");
        gettimeofday(&tv1, NULL); //start time
        while(count < childrenCount && startTime < endTime){ 
            for(int i = 0; i < childrenCount; i++){
                children[i] = fork();
                swap(matrixSize, path);
                if(children[i] == 0){
                    while(1){
                        sem_wait(start);
                        int memValue = atoi(shmem);//string to int value of shmem
                        calculatedDistance = algortihmAJPE(matrixSize, path, matrix);
                        printf("Child #%d returned:  %d\n", getpid(), calculatedDistance);
                         //sets the first calculatedDistance to shared mem
                        if (memValue < 1) {
                            sprintf(memString, "%i", calculatedDistance); //int to string
                            memcpy(shmem, memString, sizeof(memString));//copies new value in string format into shared mem
                        }
                        //compares result and value in shared mem
                        else if(memValue > calculatedDistance){ 
                            int newValue = compareValues(calculatedDistance, memValue);
                            sprintf(memString, "%i", newValue); //int to string
                            memcpy(shmem, memString, sizeof(memString));//copies new value in string format into shared mem
                            printf("Updated value in shmem: %s\n", (char*) shmem); 
                            int newPath[matrixSize];
                            memcpy(newPath,path, sizeof(path));//path for all is now equal to path with the best result
                            sem_post(compared);
                            handleUpdateSignal(SIGUSR1);
                        }
                        //if shared mem is lower than calculated
                        else{
                            handleUpdateSignal(SIGUSR2);
                            sem_post(compared);
                        }               
                        sem_post(hold);
                        sem_post(finished);
                        exit(0);
                    }    
                }
            }
            sem_post(start);
            sem_wait(compared);
            sem_wait(hold);
            printf("Value in shmem = %s\n",(char*) shmem);
            sem_wait(finished);
            

            //while loop incrementors 
            count++;
            startTime = time(NULL);
        }
        printf("\nBEST Possible Result = %s",(char*) shmem);
        gettimeofday(&tv2, NULL); //end time     
        printf("\nCalculated in %f Seconds\n",(double)(tv2.tv_usec - tv1.tv_usec) / 1000000 + (double) (tv2.tv_sec - tv1.tv_sec));       
        printf("=====================| |=====================\n");
    }
    else if(option == 4){
        quit = 1;
    }
    else{
        printf("%d : Comando não encontrado.\n", option);
    }

    printf("\n");

    //freeing memory
    destroyArray(&arr);
    munmap(shmem, 64);
    sem_close(hold);
    sem_destroy(hold);
    sem_close(start);
    sem_destroy(start);
    sem_close(finished);
    sem_destroy(finished);
    sem_close(compared);
    sem_destroy(compared);
    free(memString);

    return EXIT_SUCCESS; 
}

void handleUpdateSignal(int signal){
    if(signal == SIGUSR1){
        printf("Shared Memory Updated with new result\n");
        printf("Updating: \n");
        printf(" - path.....\n");
    }
    else{
        printf("NO UPDATE NEEDED!\n"); 
    }
}

/**
 * @brief validates if the arguments passed is equal to 3
 * 
 * @param argc quantity of arguments passed when running ./main 
 * @param argv array of char for the parameters
 * @return Args 
 */
Args validateArgs(int argc, char** argv){

    if(argc < 3){
        printf("ERROR! \nInvalid number of parameters given.\n");
        printf("Provide: File name, Number of processes, time(secs)\n");
        printf("EXAMPLE: tspTestes/ex5.txt , 1, 1\n\n");
        exit(1);
    }

    Args args;
    strcpy(args.file, argv[1]);
    args.processesCount = atoi(argv[3]);
    args.time = atoi(argv[4]);

    return args;
}


/**
 * @brief calculation of distance
 * 
 * @param size value that is found in the 1st line for every txt
 * @param path array of paths
 * @param matrix matrix of data
 * @return int the calculated distance 
 */
int algortihmAJPE(int size, int path[size], int matrix[size][size]){
    int dist = 0;
    for(int i = 0; i < size -1; i++){
        int curr = path[i] - 1;
        int next = path[i+1] - 1;
        dist += matrix[curr][next];
    }
    int last = path[size - 1] -1;
    int first = path[0] - 1;
    dist += matrix[last][first];
    
    return dist;
}


void printCommandsMenu() {
	printf("\n===================================================================================");
	printf("\n                          PROJECT: TSP                                             ");
	printf("\n===================================================================================");
	printf("\n1. bruteForce_AJPE.");
	printf("\n2. base_AJPE.");
	printf("\n3. advanced_AJPE");
	printf("\n4. Exit\n\n");
	printf("\nCOMMAND> ");
}