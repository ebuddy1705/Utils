Template for build app from list of library


make.sh build
make.sh clean component_name
make.sh cleanall


extpkgs       -> lib that no need to download
info          -> flag to mask the lib that was downloaded/uncompressed/builded
install       -> app install dir
patches       -> patch file for lib
script        -> compile script of lib
srcdir        -> download && extract to this folder
tools         -> utility script
make.sh       -> main build script
Makefile      -> no using
Readme.txt

Info Flag:
- .buildflag  -> lib was builded
- .unflag     -> lib package was uncompress
- .dlflag     -> lib package was downloaded

Before build you need to check some parameter in toos/Config file:
- ROOTFS_DIR
- TOOLCHAIN_DIR
- CROSS
- TOOLCHAIN_FILE
- PREFIX (default is install folder)
- URL_SOURCE_DL


Add library build script in make.sh
- BASE_APPLIST

Current example that build for 2 lib that is: opencv and zlib
