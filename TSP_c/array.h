#pragma once

/**
 * @brief 
 * 
 */
typedef struct array{
    int *numbers;
    int size;
} Array;
typedef struct array* PtArray;

/**
 * @brief creates an empty array
 * 
 * @param size 
 * @return PtArray 
 */
PtArray createArray(int size);

/**
 * @brief frees the memory allocated to an array
 * 
 * @param ptArr 
 */
void destroyArray(PtArray *ptArr);


void printArray(PtArray arr);
