#!/bin/bash
 
#glib-2.20.4
export PREFIX=${PROJ_DIR}/libUtility/target
export HOST=arm
export BUILD=i386-linux
./configure --prefix=$PREFIX --host=$HOST --build=$BUILD
 
 
 
#taglib-1.6.3
export PREFIX=${PROJ_DIR}/libUtility/target
export HOST=arm
export BUILD=i386-linux
./configure --prefix=$PREFIX --host=$HOST --build=$BUILD
 
 
#pkg-config-0.28 (not ok)
#NOTE: ${PROJ_DIR} from setenv.sh
export CFLAGS=-I${PROJ_DIR}/libUtility/target/include/glib-2.0 -I${PROJ_DIR}/libUtility/target/include/gio-unix-2.0/gio
               
               
               
               
export LDFLAGS=-L${PROJ_DIR}/libUtility/target/lib
export PREFIX=${PROJ_DIR}/libUtility/target
export HOST=arm
export BUILD=i386-linux
export PKG_CONFIG_PATH=/home/ninhld/Documents/OpenGL/Research/CarmeterProj/src/libUtility/target/lib/pkgconfig
./configure --prefix=$PREFIX --host=$HOST --build=$BUILD \
            CFLAGS="-I${PROJ_DIR}/libUtility/target/include/glib-2.0 -I${PROJ_DIR}/libUtility/target/include/gio-unix-2.0/gio" \
            LDFLAGS="-L${PROJ_DIR}/libUtility/target/lib"
