set_property(GLOBAL PROPERTY USE_FOLDERS ON)

set(CMAKE_RUNTIME_OUTPUT_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}")
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}")
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}")

if(MSVC)
    enable_language(ASM_MASM)
    set(CMAKE_ASM_MASM_FLAGS "/nologo /quiet ${CMAKE_ASM_MASM_FLAGS}")
    string(REPLACE "/D_WINDOWS" "" CMAKE_C_FLAGS "${CMAKE_C_FLAGS}")
endif()

if(MSVC_IDE)
    string(APPEND CMAKE_C_FLAGS " /MP")
endif()

function(py_set_output_name target_name output_name)
    set_target_properties("${target_name}" PROPERTIES OUTPUT_NAME "${output_name}$<$<CONFIG:Debug>:_d>")
endfunction()

add_library(py_default_static_options INTERFACE)
target_include_directories(py_default_static_options INTERFACE
    "${CPython_SOURCE_DIR}/Include"
    "${CPython_SOURCE_DIR}/Include/internal"
    "${CPython_SOURCE_DIR}/PC")
target_compile_definitions(py_default_static_options INTERFACE
    $<$<COMPILE_LANGUAGE:C>:WIN32>
    "$<$<COMPILE_LANGUAGE:C>:PY${PROJECT_VERSION_MAJOR}_DLLNAME=L\"python${PROJECT_VERSION_MAJOR}$<$<CONFIG:DEBUG>:_d>\">"
    $<$<COMPILE_LANGUAGE:C>:_M_X64>
    $<$<COMPILE_LANGUAGE:C>:_WIN64>
    $<$<CONFIG:Debug>:_DEBUG>)
target_compile_options(py_default_static_options INTERFACE
    $<$<COMPILE_LANGUAGE:C>:/Oi>
    $<$<COMPILE_LANGUAGE:C>:/TC>
    $<$<COMPILE_LANGUAGE:C>:/utf-8>)
target_link_libraries(py_default_static_options INTERFACE
    bcrypt.lib
    odbc32.lib
    odbccp32.lib
    pathcch.lib
    version.lib
    ws2_32.lib)

add_library(py_default_options INTERFACE)
target_link_libraries(py_default_options INTERFACE py_default_static_options)
target_compile_definitions(py_default_options INTERFACE _WINDLL)
