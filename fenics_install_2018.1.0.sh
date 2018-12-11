#!/bin/bash

module sw PrgEnv-cray PrgEnv-gnu
module load cmake/3.9.6
module load anaconda3/4.1.1
module unload gcc/6.2.0
module load gcc/5.3.0
module unload cray-libsci/16.11.1

cd && rm -rf .local && mkdir .local
cd && cd pybind11-2.2.3/build && rm -rf * && cmake -DPYBIND11_TEST=off -DCMAKE_INSTALL_PREFIX=/home/beimflei/.local .. && make install

cd && pip install fenics-ffc --prefix=/home/beimflei/.local

cd && cd boost_1_62_0/ && ./bootstrap.sh --prefix=/home/beimflei/.local --with-libraries="regex,filesystem,program_options,timer,iostreams" cxxflags=-fPIC cflags=-fPIC && ./b2 headers && ./b2 install -j 10

cd && cd eigen-eigen-67e894c6cd8f/ && mkdir -p ../.local/include/eigen3/ && cp -r Eigen/ unsupported/ ../.local/include/eigen3/.

cd && cd petsc-3.8.4/ && python2 ./configure --with-cc=cc --with-cxx=CC --with-fc=ftn --download-superlu_dist --download-mumps --download-hypre --download-parmetis --download-metis --with-debugging=no --download-petsc4py --download-petsc4py-python=python3 --download-ptscotch --download-fblaslapack --download-scalapack --download-hdf5=$HOME/src/hdf5-1.8.18.tar.gz COPTFLAGS='-O3 -march=native -mtune=native' CXXOPTFLAGS='-O3 -march=native -mtune=native' FOPTFLAGS='-O3 -march=native -mtune=native'

