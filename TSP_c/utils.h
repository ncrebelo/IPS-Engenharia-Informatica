#pragma once
#include "array.h"


/**
 * @brief reads the file, except for the 1st line, of each file and stores the items into an array
 * 
 * @param filename 
 * @param ptArr 
 */
void readFromFile(char *filename, PtArray *ptArr);

/**
 * @brief returns 1st line of the file
 * 
 * @param filename 
 * @param n 
 * @return int 
 */
int getSize(char *filename, int *n);


int squareRoot(int *n);

void swap(int s, int *path);

int minimumValue(int size, int arr[size]);

int compareValues(int num, int memNum);