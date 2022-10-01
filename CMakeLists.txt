cmake_minimum_required(VERSION 3.11-3.18)

# Uncomment and set the value, or set directly with cmake

# On Linux, uncomment to set different php-config filename 
#set(PHP_CONFIG_FILENAME "php-config")

# Common PHP-CPP build options
#set(PHPCPP_BUILD_SHARED   TRUE)  # Build PHP-CPP static or shared library
#set(PHPCPP_BUILD_EXAMPLES FALSE) # Build PHP-CPP example extensions
#set(PHPCPP_INSTALL        FALSE) # Generate PHP-CPP install target

# Options for building on Windows with MSVC
# -----------------------------------------------------------------------------
# PHP devel pack dir, download from https://windows.php.net/download/
#set(PHP_DEV_DIR         "d:/dev/cpp_php/ts/php-7.4.30-devel-vc15-x64")
# Set to TRUE if PHP was compiled with thread safe
#set(PHPCPP_COMPILE_TS   TRUE)
# Set to "x86_64" if architecture and PHP was compiled under x64 or "x86" for 32 bit
#set(PHPCPP_ARCH         "x86_64")


# Add PHP-CPP source directory to our build
add_subdirectory(PHP-CPP-cmake EXCLUDE_FROM_ALL)


# The extension
# -----------------------------------------------------------------------------
set(MY_EXTENSION_NAME "my_extension")
project(${MY_EXTENSION_NAME})
add_library(${PROJECT_NAME} MODULE )
target_sources(${PROJECT_NAME} PRIVATE ${MY_EXTENSION_NAME}.cpp)

# We need PHPCPP_INCLUDE_DIR, allowing to include php-cpp library headers
# in the way, eg: <phpcpp/visibility.h>
# because we don't use installed php-cpp headers in system directories
target_include_directories(${PROJECT_NAME}
   PUBLIC ${PROJECT_SOURCE_DIR}
   PUBLIC ${PHPCPP_INCLUDE_DIR} )

target_link_libraries(${PROJECT_NAME} PRIVATE phpcpp phpcpp-common)

if(WIN32)
   if (PHPCPP_BUILD_SHARED)
      target_compile_definitions(${PROJECT_NAME} PRIVATE USING_PHPCPP_DLL )
   endif()
else()
   target_link_options(${PROJECT_NAME} PRIVATE -shared)
   target_compile_options(${PROJECT_NAME} PRIVATE -c -Wall )
endif()

target_compile_features(${PROJECT_NAME} PUBLIC cxx_std_11)


# Copy binaries, resources to _output folder
# -----------------------------------------------------------------------------
set (OUTPUT_LIBDIR "${CMAKE_CURRENT_SOURCE_DIR}/_output/static")
if (PHPCPP_BUILD_SHARED)
  set (OUTPUT_LIBDIR "${CMAKE_CURRENT_SOURCE_DIR}/_output/shared")
endif()

# Copy extension to _output dir
add_custom_command(TARGET ${PROJECT_NAME} POST_BUILD
   COMMAND ${CMAKE_COMMAND} -E make_directory ${OUTPUT_LIBDIR}/$<$<CONFIG:Debug>:debug>$<$<CONFIG:Release>:release>
   COMMAND ${CMAKE_COMMAND} -E copy $<TARGET_FILE:${PROJECT_NAME}> ${OUTPUT_LIBDIR}/$<$<CONFIG:Debug>:debug>$<$<CONFIG:Release>:release> )

# Copy php sample to _output dir
add_custom_command(TARGET ${PROJECT_NAME} POST_BUILD
   COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_CURRENT_SOURCE_DIR}/${MY_EXTENSION_NAME}.php ${OUTPUT_LIBDIR}/$<$<CONFIG:Debug>:debug>$<$<CONFIG:Release>:release> )
