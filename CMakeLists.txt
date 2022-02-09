cmake_minimum_required(VERSION 3.15)
PROJECT(HipMCL LANGUAGES C CXX CUDA)
set(CMAKE_CXX_STANDARD 14)

INCLUDE(CheckIncludeFileCXX)

find_package(MPI REQUIRED)
find_package(OpenMP REQUIRED)
find_package(CUDA REQUIRED)
if (CUDA_FOUND)
    message(STATUS "Cuda found...")
	INCLUDE_DIRECTORIES(${CUDA_INCLUDE_DIRS})
endif()
SET(CMAKE_CUDA_FLAGS "-std=c++14 -ccbin ${CMAKE_CXX_COMPILER} -O2 \
-Wno-deprecated-declarations -w -DNVCC -DSHOW_MEMORY_USAGE -DTIMING \
-Xcompiler -std=c++11 -Xcompiler -std=c++14 -Xcompiler -fopenmp \
-Xcompiler -DNDEBUG -Xcompiler -w -Xcompiler -DGRAPH_GENERATOR_SEQ \
-Xcompiler -O2 -Xcompiler -DMPICH_IGNORE_CXX_SEEK -Xcompiler -DTHREADED \
-Xcompiler -DSHOW_MEMORY_USAGE -Xcompiler -DTIMING")

if (MPI_FOUND)
	message(STATUS "MPI found...")
    include_directories(${MPI_INCLUDE_PATH})
endif()

if (OPENMP_FOUND)
    set (CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${OpenMP_C_FLAGS}")
	set (CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${OpenMP_CXX_FLAGS}")
	set (CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} ${OpenMP_EXE_LINKER_FLAGS}")
endif()

add_definitions(-DTIMING -DTHREADED)

INCLUDE(TestCXXAcceptsFlag.cmake)
CHECK_CXX_ACCEPTS_FLAG("-std=c++11 -std=c++14" C14)

add_subdirectory(src/CombBLAS) 
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)

add_executable(hipmcl-gpu src/MCL.cu)
TARGET_INCLUDE_DIRECTORIES (hipmcl-gpu PRIVATE
	${PROJECT_SOURCE_DIR}/src/gspgemm
	${PROJECT_SOURCE_DIR}/src/gspgemm/nsparse
	)
# target_link_libraries(hipmcl-gpu CombBLASlib)

if(DEFINED ENV{MPICH_DIR})
	# message(STATUS $ENV{MPICH_DIR})
	set(MPI_INCLUDE_PATH $ENV{MPICH_DIR}/include)
	# message(STATUS ${MPI_INCLUDE_PATH})
endif()

find_library(CUDART_LIBRARY cudart ${CMAKE_CUDA_IMPLICIT_LINK_DIRECTORIES})
# message(STATUS "${CMAKE_CUDA_TOOLKIT_INCLUDE_DIRECTORIES}")
# message(STATUS "${CUDART_LIBRARY}")
# message(STATUS "${MPI_LIBRARIES}")
target_include_directories(hipmcl-gpu PRIVATE
	${CMAKE_CUDA_TOOLKIT_INCLUDE_DIRECTORIES}
	${MPI_INCLUDE_PATH}
	)
target_link_libraries(hipmcl-gpu PUBLIC ${CUDART_LIBRARY} ${MPI_LIBRARIES} CombBLASlib "${OpenMP_CXX_FLAGS}")
target_compile_options(hipmcl-gpu PRIVATE "${OpenMP_CXX_FLAGS}")


# ENABLE_TESTING()
# INCLUDE(CTest)
# ADD_TEST( hepth_mtx_test mpirun -np 4 bin/hipmcl -M data/hep-th.mtx --matrix-market -base 1 -I 2 )
