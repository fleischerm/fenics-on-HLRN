#!/bin/bash

DOLFIN_VERSION=2018.1.0

##git clone -b maint https://bitbucket.org/petsc/petsc petsc
cd petsc
##git checkout tags/v3.8.4 -b v3.8.4
python2 ./configure --with-cc=cc --with-cxx=CC --with-fc=ftn --download-superlu_dist --download-mumps --download-hypre --download-parmetis --download-metis --with-debugging=no --download-petsc4py --download-petsc4py-python=python3 --download-ptscotch --download-fblaslapack --download-scalapack --download-hdf5=$HOME/src/hdf5-1.8.18.tar.gz COPTFLAGS='-O3 -march=native -mtune=native' CXXOPTFLAGS='-O3 -march=native -mtune=native' FOPTFLAGS='-O3 -march=native -mtune=native'
make PETSC_DIR=/home/b/beidbtab/src/petsc PETSC_ARCH=arch-linux2-c-debug all


#PACKAGES_DOLFIN=(fiat instant dijitso ufl ffc)
#for PACKAGE in "${PACKAGES_DOLFIN[@]}" 
#do
#	#git clone git@bitbucket.org:fenics-project/$PACKAGE
#	cd $PACKAGE
#	git fetch --all
#	git checkout tags/$DOLFIN_VERSION -b $DOLFIN_VERSION
#	pip install . --user --upgrade --no-index
#	cd ..
#done

#git clone --recursive git@github.com:boostorg/boost.git -j10
#cd boost_1_62_0
###git fetch --all
###git checkout tags/boost-1.63.0 -b boost-1.63.0
#./bootstrap.sh --prefix=$WORK/local --with-libraries="regex,filesystem,program_options,timer,iostreams" cxxflags=-fPIC cflags=-fPIC
#./b2 headers
#./b2 install -j 10
#cd ..

#wget https://bitbucket.org/eigen/eigen/get/3.3.3.tar.bz2
#tar xfvj 3.3.3.tar.bz2
#cd eigen-eigen-67e894c6cd8f
#mkdir -p  $WORK/local/include/eigen3/
#cp -r Eigen/ unsupported $WORK/local/include/eigen3/.
#cd ..

#wget http://ftp.csx.cam.ac.uk/pub/software/programming/pcre/pcre-8.39.tar.gz
#tar xzf pcre-8.39.tar.gz
#cd pcre-8.39
#./configure --prefix=$WORK/local LDFLAGS=-dynamic
#make -j8
#make install
#cd ..

#git clone https://github.com/swig/swig
#cd swig
#git checkout tags/rel-3.0.12 -b tags/swig-3.0.12
#./autogen.sh
#./configure --prefix=$WORK/local --with-pcre-prefix=$WORK/local --with-boost=$WORK/local
#make -j8
#make install
#cd ..

##git clone git@bitbucket.org:fenics-project/dolfin
cd dolfin
####git checkout tags/$DOLFIN_VERSION -b $DOLFIN_VERSION
mkdir build
cd build
cmake -DCMAKE_SYSTEM_NAME=CrayLinuxEnvironment \
-DCMAKE_INSTALL_PREFIX=$WORK/local \
-DBOOST_ROOT=$WORK/local \
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
..
find . -type f -iname module.i -exec sed -i '/docstrings.i/d' {} \;
make -j8
make install
find . -iname link.txt -print0 | xargs -0 sed -i 's/\.\.\/\.\.\/\.\.\/libdolfin\.so/\/gfs1\/work\/beidbtab\/local\/lib\/libdolfin\.so/g'
make -j8
make install

##git clone git@bitbucket.org:fenics-project/mshr
##cd mshr
##git checkout tags/mshr-$DOLFIN_VERSION -b mshr-$DOLFIN_VERSION
##mkdir build
##cd build
#cmake -DCMAKE_SYSTEM_NAME=CrayLinuxEnvironment -DCMAKE_INSTALL_PREFIX=$WORK/local -DBOOST_ROOT=$WORK/local -DMSHR_ENABLE_VTK=FALSE ..
#make -j8
#make install
#find . -iname link.txt -print0 | xargs -0 sed -i 's/\.\.\/\.\.\/\.\.\/libmshr\.so/\/gfs1\/work\/beidbtab\/local\/lib\/libmshr\.so/g'
#make -j8
#make install

#pip install --user gitpython

#not needed
###git clone https://bitbucket.org/petsc/petsc4py.git
##cd petsc4py
##git fetch --all
###git checkout tags/3.8.1 -b petsc4py-3.8.1
##git checkout petsc4py-3.8.1
##pip install . --user --upgrade --no-index
##cd ..

#git clone https://github.com/google/python-subprocess32
#cd python-subprocess32
#git checkout tags/3.2.7 -b subprocess32-3.2.7
#pip install . --user --upgrade --no-index
#cd ..
#

#pip install --user flufl.lock
#pip install --user fenicstools
