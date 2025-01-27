#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

int main() {
    int N = 1000; // Number of page faults
    int pageSize = getpagesize();
    int intSize = sizeof(int);
    int intsPerPage = pageSize / intSize;

    // Allocate memory for the array
    int **arr = (int **)malloc(N * sizeof(int *));
    for (int i = 0; i < N; i++) {
        arr[i] = (int *)malloc(intsPerPage * sizeof(int));
    }

    // Initialize the array
    for (int i = 0; i < N; i++) {
        for (int j = 0; j < intsPerPage; j++) {
            arr[i][j] = 0;
        }
    }

    // Access memory in column-major order to generate page faults
    for (int j = 0; j < intsPerPage; j++) {
        for (int i = 0; i < N; i++) {
            int value = arr[i][j];
            // Do something with value to ensure it's accessed
        }
    }

    // Free allocated memory
    for (int i = 0; i < N; i++) {
        free(arr[i]);
    }
    free(arr);

    return 0;
}