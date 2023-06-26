cmake_minimum_required(VERSION 3.25)
project(CPython LANGUAGES C ASM VERSION 3.13)

include(CMake/default_options.cmake)

add_subdirectory(Programs)
add_subdirectory(Python)
add_subdirectory(Modules)

if(WIN32)
  add_subdirectory(PC)
endif()
