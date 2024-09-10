//
// Created by yu hong on 9/9/24.
//
#include <iostream>
#include <stdio.h>
#include <fstream>
#include <vector>
#include <string>
#include "libcubwt.cuh"

int main(int argc, char **argv ){

    if (argc < 2) {
        std::cerr << "Usage: " << argv[0] << " <input_file>" << std::endl;
        return 1;
    }

    std::string input_file = argv[1];
    std::string sa_output = input_file + ".sa.txt";
    std::ifstream file(input_file, std::ios::binary);

    if (!file) {
        std::cerr << "Cannot open file: " << input_file << std::endl;
        return 1;
    }

    // Read the file into a vector of uint8_t
    std::vector<uint8_t> data((std::istreambuf_iterator<char>(file)),
                         std::istreambuf_iterator<char>());
    file.close();

    if (data.empty()) {
        std::cerr << "File is empty or could not be read correctly." << std::endl;
        return 1;
    }

    // Ensure the data is null-terminated
    if (data.back() != 0) {
        data.push_back(0);
    }

    size_t length = data.size(); // not including the null terminator
    uint32_t* SA = new uint32_t[length];

    // allocate device storage
    void* device_storage = nullptr;
    int64_t result = libcubwt_allocate_device_storage(&device_storage, length);
    if (result != LIBCUBWT_NO_ERROR) {
        printf("Allocation error: %ld\n", result);
        return 1;
    }


    // generate suffix array
    result = libcubwt_sa(device_storage, data.data(), SA, length);
    if (result != LIBCUBWT_NO_ERROR) {
        printf("Suffix array error: %ld\n", result);
    } else {
        //store the suffix array in a file
        std::ofstream sa_file(sa_output);
        for (int i = 0; i < length; i++) {
            sa_file << SA[i] << " ";
        }
        sa_file.close();

    }

    // free device storage
    libcubwt_free_device_storage(device_storage);
    delete[] SA;

    return 0;
}
