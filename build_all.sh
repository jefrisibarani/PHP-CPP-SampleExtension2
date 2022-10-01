#!/bin/bash

# 
# Build extension with PHP-CPP static/shared, Release/Debug build 
#
# Run this script from project root dir
# We can add cmake option -DPHP_CONFIG_FILENAME="php-config-other-version"
# to use different php-config
#
# Author: jefrisibarani@gmail.com
# 

echo --------------------------------------------------------
echo -- Building Shared Library - Debug 
echo --------------------------------------------------------
cmake -S . -B build_shared_d -G "Unix Makefiles" \
-DPHPCPP_BUILD_SHARED=TRUE \
-DCMAKE_BUILD_TYPE="Debug"

sleep 3
cmake --build build_shared_d



sleep 3
echo --------------------------------------------------------
echo -- Building Shared Library - Release 
echo --------------------------------------------------------
cmake -S . -B build_shared_r -G "Unix Makefiles" \
-DPHPCPP_BUILD_SHARED=TRUE \
-DCMAKE_BUILD_TYPE="Release"

sleep 3
cmake --build build_shared_r



sleep 3
echo --------------------------------------------------------
echo -- Building Static Library - Debug 
echo --------------------------------------------------------
cmake -S . -B build_static_d -G "Unix Makefiles" \
-DPHPCPP_BUILD_SHARED=FALSE \
-DCMAKE_BUILD_TYPE="Debug"

sleep 3
cmake --build build_static_d



sleep 3
echo --------------------------------------------------------
echo -- Building Static Library - Release 
echo --------------------------------------------------------
cmake -S . -B build_static_r -G "Unix Makefiles" \
-DPHPCPP_BUILD_SHARED=FALSE \
-DCMAKE_BUILD_TYPE="Release"

sleep 3
cmake --build build_static_r