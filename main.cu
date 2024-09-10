//
// Created by yu hong on 9/9/24.
//
#include <stdio.h>
#include <cstring>
#include "libcubwt.cuh"

int main() {
    const char* input = "uncharacteristically";
    int length = strlen(input); // 不包括终止符，如果库不需要终止符
    uint8_t* T = new uint8_t[length];
    memcpy(T, input, length);
    uint32_t* SA = new uint32_t[length];

    // 分配设备存储
    void* device_storage = nullptr;
    int64_t result = libcubwt_allocate_device_storage(&device_storage, length);
    if (result != LIBCUBWT_NO_ERROR) {
        printf("Allocation error: %ld\n", result);
        return 1;
    }


    // 生成后缀数组
    result = libcubwt_sa(device_storage, T, SA, length);
    if (result != LIBCUBWT_NO_ERROR) {
        printf("Suffix array error: %ld\n", result);
    } else {
        // 打印后缀数组
        printf("Suffix Array: ");
        for (int i = 0; i < length; i++) {
            printf("%d ", SA[i]);
        }
        printf("\n");
    }

    // 清理资源
    libcubwt_free_device_storage(device_storage);
    delete[] T;
    delete[] SA;

    return 0;
}
