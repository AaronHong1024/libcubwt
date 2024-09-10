//
// Created by yu hong on 9/9/24.
//
#include <stdio.h>
#include <cstring>
#include "libcubwt.cuh"

int main() {
    const char* input = "uncharacteristically";
    int length = strlen(input); // not including the null terminator
    uint8_t* T = new uint8_t[length];
    memcpy(T, input, length);
    uint32_t* SA = new uint32_t[length];

    // allocate device storage
    void* device_storage = nullptr;
    int64_t result = libcubwt_allocate_device_storage(&device_storage, length);
    if (result != LIBCUBWT_NO_ERROR) {
        printf("Allocation error: %ld\n", result);
        return 1;
    }


    // generate suffix array
    result = libcubwt_sa(device_storage, T, SA, length);
    if (result != LIBCUBWT_NO_ERROR) {
        printf("Suffix array error: %ld\n", result);
    } else {
        // print suffix array
        printf("Suffix Array: ");
        for (int i = 0; i < length; i++) {
            printf("%d ", SA[i]);
        }
        printf("\n");
    }

    // free device storage
    libcubwt_free_device_storage(device_storage);
    delete[] T;
    delete[] SA;

    return 0;
}
