#!/bin/bash

#module swap PrgEnv-cray PrgEnv-gnu
#module load anaconda3
#module load git/2.16.2
#module load cmake/3.9.6
#module load cray-petsc/3.7.6.2
#module load cray-tpsl/17.11.1

export CC=cc
export CXX=CC

DOLFIN_VERSION=2018.1.0

#PACKAGES_DOLFIN=(fiat dijitso ufl ffc)
#for PACKAGE in "${PACKAGES_DOLFIN[@]}" 
#do
#	git clone git@bitbucket.org:fenics-project/$PACKAGE
#	cd $PACKAGE
#	git fetch --all
#	git checkout tags/$DOLFIN_VERSION -b $DOLFIN_VERSION
#	pip install . --user --upgrade --no-index
#	cd ..
#done

#PYBIND11_VERSION=2.2.3
##wget -nc --quiet https://github.com/pybind/pybind11/archive/v${PYBIND11_VERSION}.tar.gz
#tar -xf pybind11-${PYBIND11_VERSION}.tar.gz
#cd pybind11-${PYBIND11_VERSION}
#mkdir build
#cd build
#cmake -DPYBIND11_TEST=off -DCMAKE_INSTALL_PREFIX=$WORK/local .. 
#make install

######git clone --recursive git@github.com:boostorg/boost.git -j10
#cd boost_1_62_0
#####git fetch --all
#####git checkout tags/boost-1.63.0 -b boost-1.63.0
#./bootstrap.sh --prefix=$WORK/local --with-libraries="regex,filesystem,program_options,timer,iostreams" cxxflags=-fPIC cflags=-fPIC
#./b2 headers
#./b2 install -j 10
#cd ..
#
##wget https://bitbucket.org/eigen/eigen/get/3.3.3.tar.bz2
##tar xfvj 3.3.3.tar.bz2
#cd eigen-eigen-67e894c6cd8f
#mkdir -p  $WORK/local/include/eigen3/
#cp -r Eigen/ unsupported $WORK/local/include/eigen3/.
#cd ..

#git clone https://bitbucket.org/petsc/petsc4py.git
#cd petsc4py
#git fetch --all
#git checkout tags/3.7.0 -b petsc4py-3.7.0
#git checkout petsc4py-3.7.0
#pip install . --user --upgrade --no-index
#cd ..
#
##git clone git@bitbucket.org:fenics-project/dolfin
cd dolfin
#git checkout tags/$DOLFIN_VERSION -b $DOLFIN_VERSION
mkdir build
cd build
cmake -DCMAKE_SYSTEM_NAME=CrayLinuxEnvironment \
-DCMAKE_INSTALL_PREFIX=$WORK/local \
-DBOOST_ROOT=$WORK/local \
-DPETSC_DIR=$PETSC_DIR \
-DHDF5_ROOT=$PETSC_DIR/$PETSC_ARCH \
-DEIGEN3_INCLUDE_DIR=$WORK/local/include/eigen3 \
-DPYTHON_EXECUTABLE:FILEPATH=/sw/tools/anaconda3/4.1.1/generic/bin/python3 \
-DPYTHON_LIBRARY=/sw/tools/anaconda3/4.1.1/generic/lib \
-DDOLFIN_SKIP_BUILD_TESTS=ON \
-DDOLFIN_AUTO_DETECT_MPI=OFF \
-DDOLFIN_ENABLE_GTEST=OFF \
-DDOLFIN_ENABLE_DOCS=OFF \
-DDOLFIN_ENABLE_SLEPC=OFF \
-DDOLFIN_ENABLE_SLEPC4PY=OFF \
-DDOLFIN_ENABLE_TRILINOS=OFF \
-DDOLFIN_ENABLE_UMFPACK=OFF \
-DDOLFIN_ENABLE_CHOLMOD=OFF \
-DDOLFIN_ENABLE_SPHINX=OFF \
-DDOLFIN_ENABLE_VTK=OFF \
-DDOLFIN_ENABLE_HDF5=ON \
-DDOLFIN_ENABLE_PETSC=ON \
-DDOLFIN_ENABLE_BENCHMARKS=OFF \
-DDOLFIN_ENABLE_OPENMP=OFF \
-DDOLFIN_ENABLE_SCOTCH=ON \
-DCMAKE_BUILD_TYPE=Release \
-Wno-dev \
-DBUILD_SHARED_LIBS=ON \
-DDOLFIN_IGNORE_PETSC4PY_VERSION=ON \
-DDOLFIN_USE_PYTHON3=ON \
-DENABLE_PRECOMPILED_HEADERS=OFF \
..
#find . -type f -iname module.i -exec sed -i '/docstrings.i/d' {} \;
#make -j8
#make install
#find . -iname link.txt -print0 | xargs -0 sed -i 's/\.\.\/\.\.\/\.\.\/libdolfin\.so/\/gfs1\/work\/beidbtab\/local\/lib\/libdolfin\.so/g'
#make -j8
#make install


