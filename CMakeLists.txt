cmake_minimum_required(VERSION 3.8 FATAL_ERROR)
project(LZ77GPU LANGUAGES CXX CUDA)

find_package(CUDA REQUIRED)
include_directories(${CUDA_INCLUDE_DIRS})

add_executable(lz77_gpu main.cu libcubwt.cu)
target_link_libraries(lz77_gpu ${CUDA_LIBRARIES})

set_target_properties(lz77_gpu PROPERTIES CUDA_SEPARABLE_COMPILATION ON)

target_compile_options(lz77_gpu PRIVATE $<$<COMPILE_LANGUAGE:CUDA>:-Xcompiler -Wall>)

target_compile_definitions(lz77_gpu PRIVATE USE_CUDA)
