# PHP-CPP-SampleExtension2
This is sample project for creating php extension with PHP-CPP and cmake

We add PHP-CPP-cmake project source dir as sub directory



## Building with command line
Download sample project source, 
download [PHP-CPP-cmake](https://github.com/jefrisibarani/PHP-CPP-cmake) project, put it inside sample project root 
then from sample project source root dir, run cmake 

## Build on windows
Dowload php-dev from https://windows.php.net/download/, then extract to a folder for example: d:/dev/cpp_php/ts/php-7.4.30-devel-vc15-x64
```
cmake -S . -B build_shared ^
   -G "Visual Studio 15 2017" -T host=x64 -A x64 ^
   -DPHPCPP_BUILD_SHARED=TRUE ^
   -DPHP_DEV_DIR="d:/dev/cpp_php/ts/php-7.4.30-devel-vc15-x64" ^
   -DPHPCPP_COMPILE_TS=TRUE ^
   -DPHPCPP_ARCH="x86_64"
```  
```
cmake --build build_shared --config=Debug
```
```
cmake --build build_shared --config=Release
```


## Build on linux
We need php-dev package installed.

Shared library - debug 
```
cmake -S . -B build_shared_d -G "Unix Makefiles" \
   -DPHPCPP_BUILD_SHARED=TRUE \
   -DCMAKE_BUILD_TYPE="Debug"
```
```
cmake --build build_shared_d
```

Static library - release 
```
cmake -S . -B build_static_r -G "Unix Makefiles" \
   -DPHPCPP_BUILD_SHARED=FALSE \
   -DCMAKE_BUILD_TYPE="Release"
```
```
cmake --build build_static_r
```