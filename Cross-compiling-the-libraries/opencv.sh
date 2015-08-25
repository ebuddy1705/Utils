
#======= Installation in Linux  ================
#http://docs.opencv.org/doc/tutorials/introduction/linux_install/linux_install.html
yum install pkgconfig
yum install gtk2-devel



cd /path/to/OpenCV-2.3.1
mkdir release
cd release
cmake -D CMAKE_BUILD_TYPE=RELEASE -D CMAKE_INSTALL_PREFIX=/usr/local ..   #chu y hai dau cham

make
make install

#======= build opencv program ==================
export OPENCV_DIR=/home/ninhld/Documents/OpenCV-2.3.1/install

export PATH=$PATH:${OPENCV_DIR}/bin
export PKG_CONFIG_PATH=$PKG_CONFIG_PATH:${OPENCV_DIR}/lib/pkgconfig #open opencv.pc and check install folder link
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:${OPENCV_DIR}/lib

g++ `pkg-config --cflags opencv` `pkg-config --libs opencv` DisplayImage.cpp -o DisplayImage

./DisplayImage FromId3.jpg





