#!/bin/bash
# subsequent steps for installing
# fenics, dolfin etc. on HLRN-III (cray)
# guarantee a fresh environment
# 
# 
# needed packages:
# pybind11_v2.2.3.tar.gz
# boost_1_62_0.tar.gz
# eigen3_3.3.3.tar.bz2
# petsc-3.8.4.tar.gz
# 	petsc4py-3.9.0.tar.gz
# 	hdf5-1.8.18.tar.gz
# 	fblaslapack-3.4.2.tar.gz



# =============================
# modules & environments needed 
# (to be placed in fenics_module_load.sh)
source fenics_module_load.sh
echo 'loading modules successfully finished'
# =============================

# =============================
# initialization
cd && rm -rf $WORK/local && mkdir -p $WORK/local
echo 'initialization successful'
# =============================

# =============================
# install pybind11
cd && rm -rf pybind11-2.2.3 && tar -xvf pybind11_v2.2.3.tar.gz
mkdir -p pybind11-2.2.3/build && cd pybind11-2.2.3/build && cmake -DPYBIND11_TEST=off -DCMAKE_INSTALL_PREFIX=$WORK/local .. && make install
echo 'pybind11 has been successfully installed'
# =============================

# =============================
# install fenics-ffc
cd && pip install fenics-ffc --prefix=$WORK/local
echo 'fenics-ffc has been successfully installed'
# =============================

# =============================
# install boost
cd && rm -rf boost_1_62_0 && tar -xvf boost_1_62_0.tar.gz && cd boost_1_62_0/ && ./bootstrap.sh --prefix=$WORK/local --with-libraries="regex,filesystem,program_options,timer,iostreams" cxxflags=-fPIC cflags=-fPIC && ./b2 headers && ./b2 install -j 10
echo 'boost has been successfully installed'
# =============================

# =============================
# install eigen3
cd && rm -rf eigen-eigen-67e894c6cd8f && tar -xvf eigen3_3.3.3.tar.bz2 && cd eigen-eigen-67e894c6cd8f/ && mkdir -p $WORK/local/include/eigen3/ && cp -r Eigen/ unsupported/ $WORK/local/include/eigen3/.
echo 'eigen3 has been successfully installed'
# =============================

# =============================
# install petsc
export CRAYPE_LINK_TYPE=dynamic
cd && rm -rf petsc-3.8.4/ && tar -xvf petsc-3.8.4.tar.gz && cd petsc-3.8.4/ && python2 ./configure --with-cc=cc --with-cxx=CC --with-fc=ftn \
--download-superlu_dist \
--download-mumps \
--download-hypre \
--download-parmetis \
--download-metis \
--download-petsc4py-python=python3 \
--download-ptscotch \
--download-fblaslapack=$HOME/fblaslapack-3.4.2.tar.gz \
--download-hdf5=$HOME/hdf5-1.8.18.tar.gz \
--download-scalapack \
--download-petsc4py=$HOME/petsc4py-3.9.0.tar.gz \
--with-debugging=no \
--with-shared-libraries \
COPTFLAGS='-O3 -march=native -mtune=native'CXXOPTFLAGS='-O3 -march=native -mtune=native' FOPTFLAGS='-O3-march=native -mtune=native' && make PETSC_DIR=$HOME/petsc-3.8.4 PETSC_ARCH=arch-linux2-c-opt all && make PETSC_DIR=$HOME/petsc-3.8.4 PETSC_ARCH=arch-linux2-c-opt test && make PETSC_DIR=$HOME/petsc-3.8.4 PETSC_ARCH=arch-linux2-c-opt streams
echo 'petsc has been successfully installed'
# =============================

# =============================
# install dolfin
export BOOST_ROOT=$WORK/local
export PETSC_DIR=$HOME/petsc-3.8.4
export PETSC_ARCH=arch-linux2-c-opt
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$PETSC_DIR/$PETSC_ARCH/lib
export PYTHONPATH=$PYTHONPATH:$PETSC_DIR/$PETSC_ARCH/lib
export PYTHONPATH=$PYTHONPATH:$WORK/local/lib/python3.5/site-packages/
FENICS_VERSION=$(python3 -c"import ffc; print(ffc.__version__)")
cd && rm -rf dolfin/ && git clone --branch=$FENICS_VERSION https://bitbucket.org/fenics-project/dolfin && mkdir -p dolfin/build && cd $HOME/dolfin/build && cmake -DCMAKE_SYSTEM_NAME=CrayLinuxEnvironment \
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
.. && make install && source $WORK/local/share/dolfin/dolfin.conf && cd && cd dolfin/python && pip install --prefix=$WORK/local .
echo 'dolfin has been successfully installed'
# =============================

# =============================
# install mshr
cd && rm -rf mshr/ && git clone --branch=$FENICS_VERSION https://bitbucket.org/fenics-project/mshr && mkdir -p mshr/build && cd $HOME/mshr/build && cmake -DCMAKE_INSTALL_PREFIX=$WORK/local \
-DEIGEN3_INCLUDE_DIR=$WORK/local/include/eigen3 \
.. && make install && cd && cd mshr/python && pip install --prefix=$WORK/local . && cd
