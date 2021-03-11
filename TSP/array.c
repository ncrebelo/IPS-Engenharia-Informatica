#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>
#include "array.h"
#include "utils.h"


PtArray createArray(int size){
    if(size < 1) return NULL;

    PtArray arr = (PtArray)malloc(sizeof(Array));
    arr->numbers = (int*)malloc(size * size * sizeof(int));
    arr->size = size;

    return arr;
}

void destroyArray(PtArray *ptArr){
    PtArray arr = *ptArr;

    if(arr == NULL) return;

    free(arr->numbers);
    free(arr);

    *ptArr = NULL;
}

/**
 * @brief 
 * 
 * @param arr 
 */
void printArray(PtArray arr){
    if(arr == NULL){
        printf("NULL!");
        return;
    }
    printf("{ \n");
    for(int i = 0; i < arr->size -1; i++){
        printf("%d, ", arr->numbers[i]);
    }
    printf("%d\n}\n", arr->numbers[arr->size -1]);

}