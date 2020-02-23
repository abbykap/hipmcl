cmake_minimum_required(VERSION 3.15)

SET(CMAKE_CXX_COMPILER mpicxx) 
SET(CMAKE_C_COMPILER mpicc) 
INCLUDE(CheckIncludeFileCXX)

SET(CMAKE_CUDA_FLAGS "-std=c++14 -ccbin ${CMAKE_CXX_COMPILER} -O2 \
-Wno-deprecated-declarations -w -DNVCC -DSHOW_MEMORY_USAGE -DTIMING")
PROJECT( HipMCL LANGUAGES C CXX CUDA )
# SET(CMAKE_INCLUDE_CURRENT_DIR ON)
# SET(CMAKE_VERBOSE_MAKEFILE ON)
add_definitions(-DTIMING -DTHREADED)

INCLUDE(TestCXXAcceptsFlag.cmake)
CHECK_CXX_ACCEPTS_FLAG("-std=c++11 -std=c++14" C14)

if (NOT C14)
       MESSAGE(FATAL_ERROR "Your compiler does not support C++14")
else (NOT C14)
	if (CMAKE_COMPILER_IS_GNUCXX)
		SET(CMAKE_CXX_FLAGS "-std=c++11 -std=c++14 -fopenmp -DNDEBUG -w -DGRAPH_GENERATOR_SEQ -O2 -DMPICH_IGNORE_CXX_SEEK")
		SET(CMAKE_C_FLAGS "-DNDEBUG -Drestrict=__restrict__ -w -DGRAPH_GENERATOR_SEQ -O2 -DMPICH_IGNORE_CXX_SEEK")
	else (CMAKE_COMPILER_IS_GNUCXX)
		CHECK_CXX_ACCEPTS_FLAG(-std=c++0x C0X)
		if (C0X) 
			SET(CMAKE_CXX_FLAGS "-std=c++0x -std=c++11 -std=c++14 -fopenmp -DNOTGNU -DNDEBUG -w -DGRAPH_GENERATOR_SEQ -O2 -DMPICH_IGNORE_CXX_SEEK")
			SET(CMAKE_C_FLAGS "-DNOTGNU -DNDEBUG -Drestrict=__restrict__ -w -DGRAPH_GENERATOR_SEQ -O2 -DMPICH_IGNORE_CXX_SEEK")
		else (C0X)
			SET(CMAKE_CXX_FLAGS "-std=c++11 -std=c++14 -DNOTGNU -fopenmp -DNDEBUG -w -DGRAPH_GENERATOR_SEQ -O2 -DMPICH_IGNORE_CXX_SEEK")
			SET(CMAKE_C_FLAGS "-DNOTGNU -DNDEBUG -Drestrict=__restrict__ -w -DGRAPH_GENERATOR_SEQ -O2 -DMPICH_IGNORE_CXX_SEEK")
		endif (C0X)
	endif (CMAKE_COMPILER_IS_GNUCXX)
endif (NOT C14)

find_package(CUDA 10 REQUIRED)
if (CUDA_FOUND)
	INCLUDE_DIRECTORIES(${CUDA_INCLUDE_DIRS})
else()
	message("CUDA not found")
endif()

SET(CMAKE_CUDA_FLAGS "-std=c++14 -ccbin ${CMAKE_CXX_COMPILER} -O2 \
-Wno-deprecated-declarations -w -DNVCC -DSHOW_MEMORY_USAGE -DTIMING \
-Xcompiler -std=c++11 -Xcompiler -std=c++14 -Xcompiler -fopenmp \
-Xcompiler -DNDEBUG -Xcompiler -w -Xcompiler -DGRAPH_GENERATOR_SEQ \
-Xcompiler -O2 -Xcompiler -DMPICH_IGNORE_CXX_SEEK -Xcompiler -DTHREADED \
-Xcompiler -DSHOW_MEMORY_USAGE -Xcompiler -DTIMING")

ADD_SUBDIRECTORY( src/CombBLAS ) 
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)
add_executable(hipmcl-gpu src/MCL.cu)
TARGET_INCLUDE_DIRECTORIES (hipmcl-gpu PRIVATE src/gspgemm src/gspgemm/nsparse src/gspgemm/rmerge src/gspgemm/rmerge/SPMMProject src/gspgemm/cusplibrary )
target_link_libraries(hipmcl-gpu CombBLASlib ${CUDA_cusparse_LIBRARY})



# ENABLE_TESTING()
# INCLUDE(CTest)
# ADD_TEST( hepth_mtx_test mpirun -np 4 bin/hipmcl -M data/hep-th.mtx --matrix-market -base 1 -I 2 )




