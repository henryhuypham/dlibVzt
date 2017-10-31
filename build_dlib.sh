#!/bin/bash
mkdir build
cd build
cmake -Wno-dev -GXcode -DCMAKE_BUILD_TYPE=Release -DCMAKE_CXX_FLAGS="-DPNG_ARM_NEON_OPT=0 -std=c++11" -DCMAKE_C_FLAGS="-DPNG_ARM_NEON_OPT=0" -DCMAKE_CXX_COMPILER_WORKS=1 -DCMAKE_C_COMPILER_WORKS=1 -DCMAKE_THREAD_LIBS_INIT="-lpthread" -DCMAKE_USE_PTHREADS_INIT=1 -DCMAKE_OSX_ARCHITECTURES="arm64" -DCMAKE_OSX_SYSROOT=$(xcode-select -p)/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS.sdk -DCMAKE_MACOSX_BUNDLE=ON -DCMAKE_XCODE_ATTRIBUTE_CODE_SIGNING_REQUIRED=NO -DLIBPNG_IS_GOOD=0 -DLIBJPEG_IS_GOOD=0 -DAPPLE=1 -DDLIB_NO_GUI_SUPPORT=1 -DDLIB_USE_CUDA=0 -DDLIB_USE_BLAS=1 -DDLIB_USE_LAPACK=1 -DUNIX=1 ../
CMAKE_VERSION=`cmake --version | tr -dc '0-9'`
if [ $CMAKE_VERSION -lt 300 ]; then sed -i '' 's~/build/dlib/Release~/build/dlib/Release-iphoneos~g' dlib/CMakeScripts/dlib_shared_postBuildPhase.makeRelease; fi
xcodebuild -arch arm64 -sdk iphoneos -configuration Release ONLY_ACTIVE_ARCH=NO -target ALL_BUILD build
xcodebuild -arch x86_64 -sdk iphonesimulator -configuration Release ONLY_ACTIVE_ARCH=NO -target ALL_BUILD build
sed -i '' 's~/build/dlib/Release~/build/dlib/Release-iphoneos~g' dlib/cmake_install.cmake
cmake -DCMAKE_INSTALL_PREFIX=install -P cmake_install.cmake
lipo -create install/lib/libdlib.19.6.99.dylib dlib/Release-iphonesimulator/libdlib.19.6.99.dylib -output libdlib.dylib
install_name_tool -id @rpath/libdlib.dylib libdlib.dylib
