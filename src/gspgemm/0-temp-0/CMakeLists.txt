SET(gspgemm_src gSpGEMM.cpp)

SET(GSPGEMM_CXX_FLAGS "-O3 -fopenmp -std=c++14 -I${CUDA_INCLUDE_DIRS}")
SET(CMAKE_CXX_FLAGS "${GSPGEMM_CXX_FLAGS}")

MESSAGE(${CUDA_INCLUDE_DIRS})

ADD_LIBRARY(gspgemm ${gspgemm_src})
TARGET_INCLUDE_DIRECTORIES(gspgemm PRIVATE ../include ../psort-1.0/include ../usort/include ../graph500-1.2/generator/include rmerge rmerge/SPMMProject nsparse ${CUDA_INCLUDE_DIRS} )
