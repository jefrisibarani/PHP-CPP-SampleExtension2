cmake_minimum_required(VERSION 3.11-3.18)

# Add php-cpp source directory to our build
add_subdirectory(d:/projects/php-cpp/PHP-CPP-cmake build-php-cpp)

set(MY_EXTENSION_NAME "my_extension")

if(PHPCPP_BUILD_SHARED)
   message(STATUS "Using php-cpp shared library...")
else()
   message(STATUS "Using php-cpp static library...")
endif()


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
