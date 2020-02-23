SET(rmerge_src cuSpmmTest.cu cuSpmmOther.cu bhsparse.cu MulCusparse.cpp)

# MESSAGE(${CMAKE_CXX_FLAGS})
SET(RMERGE_CXX_FLAGS "-O3 -fopenmp -m64 -std=c++14")
# SET(RMERGE_CUDA_FLAGS "-Wno-deprecated-declarations")
SET(CMAKE_CXX_FLAGS "${RMERGE_CXX_FLAGS}")
# SET(CMAKE_CUDA_FLAGS "${RMERGE_CUDA_FLAGS}")
ADD_LIBRARY(rmerge ${rmerge_src})
# MESSAGE("compiling rmerge...")
# MESSAGE(${CMAKE_CXX_FLAGS})

TARGET_INCLUDE_DIRECTORIES(rmerge PRIVATE ..)
