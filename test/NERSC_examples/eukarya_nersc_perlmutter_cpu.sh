#!/bin/bash -l

#SBATCH -q debug
#SBATCH -N 8
#SBATCH -C cpu
#SBATCH -t 00:30:00
#SBATCH -J euk_perlmutter_cpu_8node
#SBATCH -o euk_perlmutter_cpu_8node.o%j

N=8
n=64
t=8
HIPMCL_EXE=../../bin/hipmcl
export OMP_NUM_THREADS=$t
export OMP_PROC_BIND=true
export OMP_PLACES=cores
export MPICH_GNI_COLL_OPT_OFF=MPI_Alltoallv

# input in the matrix market format
IN_FILE=../../data/Renamed_euk_vs_euk_30_50length.indexed.mtx
OUT_FILE=../../data/Renamed_euk_vs_euk_30_50length.indexed.mtx.hipmcl

# HipMCL with 2D matrix multiplication
#srun -N $N -n $n -c $t  --ntasks-per-node=8 --cpu_bind=cores $HIPMCL_EXE -M $IN_FILE --matrix-market -base 0 -I 2 -per-process-mem 32 -o $OUT_FILE

# HipMCL with 3D matrix multiplication
srun -N $N -n $n -c $t  --ntasks-per-node=8 --cpu_bind=cores $HIPMCL_EXE -M $IN_FILE --matrix-market -base 0 -I 2 -per-process-mem 32 -layers 4 -o $OUT_FILE
