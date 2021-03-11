#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>
#include "utils.h"
#include <math.h>


void readFromFile(char *filename, PtArray *ptArr){

    FILE *f = NULL;
    PtArray arr = *ptArr;
    
    f = fopen(filename, "r");

    if (f == NULL) {
		printf("An error ocurred... It was not possible to open the file %s ...\n", filename);
	}

    int arraySize = 0;
    char str[16];

    //Reads the first line of the file and applies (size^size) to determine arr's size. Ex: if 4, arrsize = 16
    if(fgets(str, 16, f)!=NULL ) {
        int tempSize = atoi(str);
        arraySize = tempSize * tempSize; 
    }

    for(int i = 0; i < arraySize - 1; i++){
        if(fscanf(f,"%d", &arr->numbers[i]) != 1){
        }
    }
    fclose(f);
}

int getSize(char *filename, int *n){

    FILE *f = NULL;
    f = fopen(filename, "r");
    
    if (f == NULL) {
		printf("An error ocurred... It was not possible to open the file %s ...\n", filename);
	}
    int size;
    char str[16];

    //Reads the first line of the file and applies (size^size) to determine arr's size. Ex: if 4, arrsize = 16
    if(fgets(str, 16, f) != NULL ) {
         int tempSize = atoi(str);
        size = tempSize * tempSize; 
    }

    return size;
    fclose(f);
}

int squareRoot(int *n){
    return sqrt(*n);
}

void swap(int s, int *path){
    int a = rand() % s;
    int b = rand() % s;
    int temp = path[a];
    path[a] = path[b];
    path[b] = temp;
}


int minimumValue(int size, int arr[size]){  
    
    int shortest = arr[0];

    for(int i = 0; i < size - 1; i++){
        if (arr[i] < shortest)
            shortest = arr[i];
    }
    return shortest;
}  

int compareValues(int num, int memNum){
    int final = 0;

    if(num < memNum){
        final = num;
    }
    else{
        final = memNum;
    }

    return final;
}



  
