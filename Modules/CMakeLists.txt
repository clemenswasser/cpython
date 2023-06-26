function(py_module target_name output_name)
    add_library("${target_name}" SHARED ${ARGN})
    set_target_properties("${target_name}" PROPERTIES SUFFIX ".pyd" FOLDER "py_modules")
    py_set_output_name("${target_name}" "${output_name}")
    target_link_libraries("${target_name}" PRIVATE py_default_options pythoncore)
endfunction()

py_module(py_module_asyncio _asyncio _asynciomodule.c)

py_module(py_module_bz2 _bz2 _bz2module.c
    "${CPython_SOURCE_DIR}/externals/bzip2-1.0.8/blocksort.c"
    "${CPython_SOURCE_DIR}/externals/bzip2-1.0.8/bzlib.c"
    "${CPython_SOURCE_DIR}/externals/bzip2-1.0.8/compress.c"
    "${CPython_SOURCE_DIR}/externals/bzip2-1.0.8/crctable.c"
    "${CPython_SOURCE_DIR}/externals/bzip2-1.0.8/decompress.c"
    "${CPython_SOURCE_DIR}/externals/bzip2-1.0.8/huffman.c"
    "${CPython_SOURCE_DIR}/externals/bzip2-1.0.8/randtable.c")
target_compile_definitions(py_module_bz2 PRIVATE _FILE_OFFSET_BITS=64)
target_include_directories(py_module_bz2 PRIVATE "${CPython_SOURCE_DIR}/externals/bzip2-1.0.8")

if(WIN32)
    target_compile_definitions(py_module_bz2 PRIVATE _CRT_SECURE_NO_DEPRECATE _CRT_NONSTDC_NO_DEPRECATE)
    target_compile_options(py_module_bz2 PRIVATE /wd4244 /wd4267)
endif()

py_module(py_module_ctypes _ctypes
    _ctypes/_ctypes.c
    _ctypes/callbacks.c
    _ctypes/callproc.c
    _ctypes/cfield.c
    _ctypes/malloc_closure.c
    _ctypes/stgdict.c)
target_compile_definitions(py_module_ctypes PRIVATE USING_MALLOC_CLOSURE_DOT_C=1)
target_include_directories(py_module_ctypes PRIVATE "${CPython_SOURCE_DIR}/externals/libffi-3.4.4/amd64/include")
target_link_directories(py_module_ctypes PRIVATE "${CPython_SOURCE_DIR}/externals/libffi-3.4.4/amd64")
target_link_libraries(py_module_ctypes PRIVATE libffi-8)

function(copy_libffi dest_dir)
    file(COPY_FILE "${CPython_SOURCE_DIR}/externals/libffi-3.4.4/amd64/libffi-8.dll" "${dest_dir}/libffi-8.dll" ONLY_IF_DIFFERENT)
endfunction()

if(DEFINED CMAKE_CONFIGURATION_TYPES)
    foreach(config_type IN LISTS CMAKE_CONFIGURATION_TYPES)
        file(MAKE_DIRECTORY "${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/${config_type}")
        copy_libffi("${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/${config_type}")
    endforeach()
else()
    file(MAKE_DIRECTORY "${CMAKE_RUNTIME_OUTPUT_DIRECTORY}")
    copy_libffi("${CMAKE_RUNTIME_OUTPUT_DIRECTORY}")
endif()

py_module(py_module_ctypes_test _ctypes_test _ctypes/_ctypes_test.c)

py_module(py_module_decimal _decimal _decimal/_decimal.c _decimal/libmpdec/vcdiv64.asm _decimal/libmpdec/basearith.c _decimal/libmpdec/constants.c _decimal/libmpdec/context.c _decimal/libmpdec/convolute.c _decimal/libmpdec/crt.c _decimal/libmpdec/difradix2.c _decimal/libmpdec/fnt.c _decimal/libmpdec/fourstep.c _decimal/libmpdec/io.c _decimal/libmpdec/mpalloc.c _decimal/libmpdec/mpdecimal.c _decimal/libmpdec/numbertheory.c _decimal/libmpdec/sixstep.c _decimal/libmpdec/transpose.c)
target_include_directories(py_module_decimal PRIVATE "${CMAKE_CURRENT_LIST_DIR}/_decimal/libmpdec")
target_compile_definitions(py_module_decimal PRIVATE CONFIG_64 MASM _CRT_SECURE_NO_WARNINGS)

py_module(py_module_elementtree _elementtree _elementtree.c expat/xmlparse.c expat/xmlrole.c expat/xmltok.c)
target_compile_definitions(py_module_elementtree PRIVATE _CRT_SECURE_NO_WARNINGS XML_STATIC)
target_include_directories(py_module_elementtree PRIVATE expat)

py_module(py_module_hashlib _hashlib _hashopenssl.c)
target_include_directories(py_module_hashlib PRIVATE "${CPython_SOURCE_DIR}/externals/openssl-bin-1.1.1u/amd64/include")
target_link_directories(py_module_hashlib PRIVATE "${CPython_SOURCE_DIR}/externals/openssl-bin-1.1.1u/amd64")
target_link_libraries(py_module_hashlib PRIVATE libcrypto libssl)

add_library(py_external_lzma)
set_target_properties(py_external_lzma PROPERTIES FOLDER "py_externals")
py_set_output_name(py_external_lzma lzma)
target_link_libraries(py_external_lzma PRIVATE py_default_options)
target_compile_definitions(py_external_lzma PRIVATE HAVE_CONFIG_H _LIB)
target_compile_options(py_external_lzma PRIVATE /wd4028 /wd4113 /wd4133 /wd4244 /wd4267 /wd4996)
target_include_directories(py_external_lzma PRIVATE
    "${CPython_SOURCE_DIR}/externals/xz-5.2.5/windows/vs2019"
    "${CPython_SOURCE_DIR}/externals/xz-5.2.5/src/liblzma/common"
    "${CPython_SOURCE_DIR}/externals/xz-5.2.5/src/common"
    "${CPython_SOURCE_DIR}/externals/xz-5.2.5/src/liblzma/api"
    "${CPython_SOURCE_DIR}/externals/xz-5.2.5/src/liblzma/check"
    "${CPython_SOURCE_DIR}/externals/xz-5.2.5/src/liblzma/delta"
    "${CPython_SOURCE_DIR}/externals/xz-5.2.5/src/liblzma/lz"
    "${CPython_SOURCE_DIR}/externals/xz-5.2.5/src/liblzma/lzma"
    "${CPython_SOURCE_DIR}/externals/xz-5.2.5/src/liblzma/rangecoder"
    "${CPython_SOURCE_DIR}/externals/xz-5.2.5/src/liblzma/simple")
target_sources(py_external_lzma PRIVATE
    "${CPython_SOURCE_DIR}/externals/xz-5.2.5/src/common/tuklib_cpucores.c"
    "${CPython_SOURCE_DIR}/externals/xz-5.2.5/src/common/tuklib_physmem.c"
    "${CPython_SOURCE_DIR}/externals/xz-5.2.5/src/liblzma/check/check.c"
    "${CPython_SOURCE_DIR}/externals/xz-5.2.5/src/liblzma/check/crc32_fast.c"
    "${CPython_SOURCE_DIR}/externals/xz-5.2.5/src/liblzma/check/crc32_table.c"
    "${CPython_SOURCE_DIR}/externals/xz-5.2.5/src/liblzma/check/crc64_fast.c"
    "${CPython_SOURCE_DIR}/externals/xz-5.2.5/src/liblzma/check/crc64_table.c"
    "${CPython_SOURCE_DIR}/externals/xz-5.2.5/src/liblzma/check/sha256.c"
    "${CPython_SOURCE_DIR}/externals/xz-5.2.5/src/liblzma/common/alone_decoder.c"
    "${CPython_SOURCE_DIR}/externals/xz-5.2.5/src/liblzma/common/alone_encoder.c"
    "${CPython_SOURCE_DIR}/externals/xz-5.2.5/src/liblzma/common/auto_decoder.c"
    "${CPython_SOURCE_DIR}/externals/xz-5.2.5/src/liblzma/common/block_buffer_decoder.c"
    "${CPython_SOURCE_DIR}/externals/xz-5.2.5/src/liblzma/common/block_buffer_encoder.c"
    "${CPython_SOURCE_DIR}/externals/xz-5.2.5/src/liblzma/common/block_decoder.c"
    "${CPython_SOURCE_DIR}/externals/xz-5.2.5/src/liblzma/common/block_encoder.c"
    "${CPython_SOURCE_DIR}/externals/xz-5.2.5/src/liblzma/common/block_header_decoder.c"
    "${CPython_SOURCE_DIR}/externals/xz-5.2.5/src/liblzma/common/block_header_encoder.c"
    "${CPython_SOURCE_DIR}/externals/xz-5.2.5/src/liblzma/common/block_util.c"
    "${CPython_SOURCE_DIR}/externals/xz-5.2.5/src/liblzma/common/common.c"
    "${CPython_SOURCE_DIR}/externals/xz-5.2.5/src/liblzma/common/easy_buffer_encoder.c"
    "${CPython_SOURCE_DIR}/externals/xz-5.2.5/src/liblzma/common/easy_decoder_memusage.c"
    "${CPython_SOURCE_DIR}/externals/xz-5.2.5/src/liblzma/common/easy_encoder.c"
    "${CPython_SOURCE_DIR}/externals/xz-5.2.5/src/liblzma/common/easy_encoder_memusage.c"
    "${CPython_SOURCE_DIR}/externals/xz-5.2.5/src/liblzma/common/easy_preset.c"
    "${CPython_SOURCE_DIR}/externals/xz-5.2.5/src/liblzma/common/filter_buffer_decoder.c"
    "${CPython_SOURCE_DIR}/externals/xz-5.2.5/src/liblzma/common/filter_buffer_encoder.c"
    "${CPython_SOURCE_DIR}/externals/xz-5.2.5/src/liblzma/common/filter_common.c"
    "${CPython_SOURCE_DIR}/externals/xz-5.2.5/src/liblzma/common/filter_decoder.c"
    "${CPython_SOURCE_DIR}/externals/xz-5.2.5/src/liblzma/common/filter_encoder.c"
    "${CPython_SOURCE_DIR}/externals/xz-5.2.5/src/liblzma/common/filter_flags_decoder.c"
    "${CPython_SOURCE_DIR}/externals/xz-5.2.5/src/liblzma/common/filter_flags_encoder.c"
    "${CPython_SOURCE_DIR}/externals/xz-5.2.5/src/liblzma/common/hardware_cputhreads.c"
    "${CPython_SOURCE_DIR}/externals/xz-5.2.5/src/liblzma/common/hardware_physmem.c"
    "${CPython_SOURCE_DIR}/externals/xz-5.2.5/src/liblzma/common/index.c"
    "${CPython_SOURCE_DIR}/externals/xz-5.2.5/src/liblzma/common/index_decoder.c"
    "${CPython_SOURCE_DIR}/externals/xz-5.2.5/src/liblzma/common/index_encoder.c"
    "${CPython_SOURCE_DIR}/externals/xz-5.2.5/src/liblzma/common/index_hash.c"
    "${CPython_SOURCE_DIR}/externals/xz-5.2.5/src/liblzma/common/outqueue.c"
    "${CPython_SOURCE_DIR}/externals/xz-5.2.5/src/liblzma/common/stream_buffer_decoder.c"
    "${CPython_SOURCE_DIR}/externals/xz-5.2.5/src/liblzma/common/stream_buffer_encoder.c"
    "${CPython_SOURCE_DIR}/externals/xz-5.2.5/src/liblzma/common/stream_decoder.c"
    "${CPython_SOURCE_DIR}/externals/xz-5.2.5/src/liblzma/common/stream_encoder.c"
    "${CPython_SOURCE_DIR}/externals/xz-5.2.5/src/liblzma/common/stream_encoder_mt.c"
    "${CPython_SOURCE_DIR}/externals/xz-5.2.5/src/liblzma/common/stream_flags_common.c"
    "${CPython_SOURCE_DIR}/externals/xz-5.2.5/src/liblzma/common/stream_flags_decoder.c"
    "${CPython_SOURCE_DIR}/externals/xz-5.2.5/src/liblzma/common/stream_flags_encoder.c"
    "${CPython_SOURCE_DIR}/externals/xz-5.2.5/src/liblzma/common/vli_decoder.c"
    "${CPython_SOURCE_DIR}/externals/xz-5.2.5/src/liblzma/common/vli_encoder.c"
    "${CPython_SOURCE_DIR}/externals/xz-5.2.5/src/liblzma/common/vli_size.c"
    "${CPython_SOURCE_DIR}/externals/xz-5.2.5/src/liblzma/delta/delta_common.c"
    "${CPython_SOURCE_DIR}/externals/xz-5.2.5/src/liblzma/delta/delta_decoder.c"
    "${CPython_SOURCE_DIR}/externals/xz-5.2.5/src/liblzma/delta/delta_encoder.c"
    "${CPython_SOURCE_DIR}/externals/xz-5.2.5/src/liblzma/lzma/fastpos_table.c"
    "${CPython_SOURCE_DIR}/externals/xz-5.2.5/src/liblzma/lzma/lzma2_decoder.c"
    "${CPython_SOURCE_DIR}/externals/xz-5.2.5/src/liblzma/lzma/lzma2_encoder.c"
    "${CPython_SOURCE_DIR}/externals/xz-5.2.5/src/liblzma/lzma/lzma_decoder.c"
    "${CPython_SOURCE_DIR}/externals/xz-5.2.5/src/liblzma/lzma/lzma_encoder.c"
    "${CPython_SOURCE_DIR}/externals/xz-5.2.5/src/liblzma/lzma/lzma_encoder_optimum_fast.c"
    "${CPython_SOURCE_DIR}/externals/xz-5.2.5/src/liblzma/lzma/lzma_encoder_optimum_normal.c"
    "${CPython_SOURCE_DIR}/externals/xz-5.2.5/src/liblzma/lzma/lzma_encoder_presets.c"
    "${CPython_SOURCE_DIR}/externals/xz-5.2.5/src/liblzma/lz/lz_decoder.c"
    "${CPython_SOURCE_DIR}/externals/xz-5.2.5/src/liblzma/lz/lz_encoder.c"
    "${CPython_SOURCE_DIR}/externals/xz-5.2.5/src/liblzma/lz/lz_encoder_mf.c"
    "${CPython_SOURCE_DIR}/externals/xz-5.2.5/src/liblzma/rangecoder/price_table.c"
    "${CPython_SOURCE_DIR}/externals/xz-5.2.5/src/liblzma/simple/arm.c"
    "${CPython_SOURCE_DIR}/externals/xz-5.2.5/src/liblzma/simple/armthumb.c"
    "${CPython_SOURCE_DIR}/externals/xz-5.2.5/src/liblzma/simple/ia64.c"
    "${CPython_SOURCE_DIR}/externals/xz-5.2.5/src/liblzma/simple/powerpc.c"
    "${CPython_SOURCE_DIR}/externals/xz-5.2.5/src/liblzma/simple/simple_coder.c"
    "${CPython_SOURCE_DIR}/externals/xz-5.2.5/src/liblzma/simple/simple_decoder.c"
    "${CPython_SOURCE_DIR}/externals/xz-5.2.5/src/liblzma/simple/simple_encoder.c"
    "${CPython_SOURCE_DIR}/externals/xz-5.2.5/src/liblzma/simple/sparc.c"
    "${CPython_SOURCE_DIR}/externals/xz-5.2.5/src/liblzma/simple/x86.c")

py_module(py_module_lzma _lzma _lzmamodule.c)
target_link_libraries(py_module_lzma PRIVATE py_external_lzma)
target_compile_definitions(py_module_lzma PRIVATE _FILE_OFFSET_BITS=64 _CRT_SECURE_NO_DEPRECATE _CRT_NONSTDC_NO_DEPRECATE LZMA_API_STATIC)
target_include_directories(py_module_lzma PRIVATE "${CPython_SOURCE_DIR}/externals/xz-5.2.5/src/liblzma/api")

py_module(py_module_multiprocessing _multiprocessing _multiprocessing/multiprocessing.c _multiprocessing/semaphore.c)

py_module(py_module_overlapped _overlapped overlapped.c)

py_module(py_module_pyexpat pyexpat pyexpat.c expat/xmlparse.c expat/xmlrole.c expat/xmltok.c)
target_include_directories(py_module_pyexpat PRIVATE expat)

py_module(py_module_queue _queue _queuemodule.c)

py_module(py_module_select select selectmodule.c)

add_library(py_external_sqlite3 SHARED "${CPython_SOURCE_DIR}/externals/sqlite-3.42.0.0/sqlite3.c")
set_target_properties(py_external_sqlite3 PROPERTIES FOLDER "py_externals")
py_set_output_name(py_external_sqlite3 sqlite3)
target_link_libraries(py_external_sqlite3 PRIVATE py_default_options)
target_compile_definitions(py_external_sqlite3 PRIVATE SQLITE_ENABLE_MATH_FUNCTIONS SQLITE_ENABLE_FTS4 SQLITE_ENABLE_FTS5 SQLITE_ENABLE_RTREE SQLITE_OMIT_AUTOINIT [[SQLITE_API=__declspec(dllexport)]])

py_module(py_module_sqlite3 _sqlite3
    _sqlite/connection.c
    _sqlite/cursor.c
    _sqlite/microprotocols.c
    _sqlite/module.c
    _sqlite/prepare_protocol.c
    _sqlite/row.c
    _sqlite/statement.c
    _sqlite/util.c
    _sqlite/blob.c)
target_include_directories(py_module_sqlite3 PRIVATE "${CPython_SOURCE_DIR}/externals/sqlite-3.42.0.0")
target_link_libraries(py_module_sqlite3 PRIVATE py_external_sqlite3)
target_compile_definitions(py_module_sqlite3 PRIVATE PY_SQLITE_HAVE_SERIALIZE PY_SQLITE_ENABLE_LOAD_EXTENSION)

py_module(py_module_ssl _ssl _ssl.c "${CPython_SOURCE_DIR}/externals/openssl-bin-1.1.1u/amd64/include/applink.c")
target_include_directories(py_module_ssl PRIVATE "${CPython_SOURCE_DIR}/externals/openssl-bin-1.1.1u/amd64/include")
set_source_files_properties("${CPython_SOURCE_DIR}/externals/openssl-bin-1.1.1u/amd64/include/applink.c" PROPERTIES COMPILE_DEFINITIONS _CRT_SECURE_NO_WARNINGS)
target_link_directories(py_module_ssl PRIVATE "${CPython_SOURCE_DIR}/externals/openssl-bin-1.1.1u/amd64")
target_link_libraries(py_module_ssl PRIVATE py_module_socket crypt32.lib libcrypto libssl)

function(copy_openssl dest_dir)
    file(COPY_FILE "${CPython_SOURCE_DIR}/externals/openssl-bin-1.1.1u/amd64/libcrypto-1_1.dll" "${dest_dir}/libcrypto-1_1.dll" ONLY_IF_DIFFERENT)
    file(COPY_FILE "${CPython_SOURCE_DIR}/externals/openssl-bin-1.1.1u/amd64/libssl-1_1.pdb" "${dest_dir}/libssl-1_1.pdb" ONLY_IF_DIFFERENT)
    file(COPY_FILE "${CPython_SOURCE_DIR}/externals/openssl-bin-1.1.1u/amd64/libssl-1_1.dll" "${dest_dir}/libssl-1_1.dll" ONLY_IF_DIFFERENT)
    file(COPY_FILE "${CPython_SOURCE_DIR}/externals/openssl-bin-1.1.1u/amd64/libcrypto-1_1.pdb" "${dest_dir}/libcrypto-1_1.pdb" ONLY_IF_DIFFERENT)
endfunction()

if(DEFINED CMAKE_CONFIGURATION_TYPES)
    foreach(config_type IN LISTS CMAKE_CONFIGURATION_TYPES)
        copy_openssl("${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/${config_type}")
    endforeach()
else()
    copy_openssl("${CMAKE_RUNTIME_OUTPUT_DIRECTORY}")
endif()

py_module(py_module_socket _socket socketmodule.c)

if(WIN32)
    target_link_libraries(py_module_socket PRIVATE iphlpapi.lib Rpcrt4.lib)
endif()

py_module(py_module_testbuffer _testbuffer _testbuffer.c)

py_module(py_module_testcapi _testcapi
    _testcapimodule.c
    _testcapi/getargs.c
    _testcapi/vectorcall.c
    _testcapi/vectorcall_limited.c
    _testcapi/heaptype.c
    _testcapi/heaptype_relative.c
    _testcapi/unicode.c
    _testcapi/pytime.c
    _testcapi/datetime.c
    _testcapi/docstring.c
    _testcapi/mem.c
    _testcapi/watchers.c
    _testcapi/float.c
    _testcapi/long.c
    _testcapi/structmember.c
    _testcapi/exceptions.c
    _testcapi/code.c
    _testcapi/buffer.c
    _testcapi/pyos.c
    _testcapi/immortal.c
    _testcapi/gc.c)
target_link_libraries(py_module_testcapi PRIVATE pythondll)

py_module(py_module_testimportmultiple _testimportmultiple _testimportmultiple.c)

py_module(py_module_testinternalcapi _testinternalcapi _testinternalcapi.c)

py_module(py_module_testmultiphase _testmultiphase _testmultiphase.c)
target_compile_definitions(py_module_testmultiphase PRIVATE _CONSOLE)

py_module(py_module_testsinglephase _testsinglephase _testsinglephase.c)
target_compile_definitions(py_module_testsinglephase PRIVATE _CONSOLE)

function(copy_tkinter dest_dir)
    file(COPY_FILE "${CPython_SOURCE_DIR}/externals/tcltk-8.6.13.0/amd64/bin/tcl86t.dll" "${dest_dir}/tcl86t.dll" ONLY_IF_DIFFERENT)
    file(COPY_FILE "${CPython_SOURCE_DIR}/externals/tcltk-8.6.13.0/amd64/bin/zlib1.dll" "${dest_dir}/zlib1.dll" ONLY_IF_DIFFERENT)
    file(COPY_FILE "${CPython_SOURCE_DIR}/externals/tcltk-8.6.13.0/amd64/bin/tk86t.dll" "${dest_dir}/tk86t.dll" ONLY_IF_DIFFERENT)
    file(WRITE "${dest_dir}/TCL_LIBRARY.env" "${CPython_SOURCE_DIR}/externals/tcltk-8.6.13.0/amd64/lib/tcl8.6")
endfunction()

if(DEFINED CMAKE_CONFIGURATION_TYPES)
    foreach(config_type IN LISTS CMAKE_CONFIGURATION_TYPES)
        copy_tkinter("${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/${config_type}")
    endforeach()
else()
    copy_tkinter("${CMAKE_RUNTIME_OUTPUT_DIRECTORY}")
endif()


py_module(py_module_tkinter _tkinter _tkinter.c tkappinit.c)
target_include_directories(py_module_tkinter PRIVATE "${CPython_SOURCE_DIR}/externals/tcltk-8.6.13.0/amd64/include")
target_compile_definitions(py_module_tkinter PRIVATE
    "Py_TCLTK_DIR=\"${CPython_SOURCE_DIR}/externals/tcltk-8.6.13.0/amd64\""
    WITH_APPINIT)
target_link_libraries(py_module_tkinter PRIVATE
    "${CPython_SOURCE_DIR}/externals/tcltk-8.6.13.0/amd64/lib/tcl86t.lib"
    "${CPython_SOURCE_DIR}/externals/tcltk-8.6.13.0/amd64/lib/tk86t.lib")

py_module(py_module_unicodedata unicodedata unicodedata.c)

py_module(py_module_uuid _uuid _uuidmodule.c)

if(WIN32)
    target_link_libraries(py_module_uuid PRIVATE rpcrt4.lib)
endif()

py_module(py_module_xxlimited xxlimited xxlimited.c)
set_target_properties(py_module_xxlimited PROPERTIES OUTPUT_NAME xxlimited)
target_link_libraries(py_module_xxlimited PRIVATE pythondll)

if(WIN32)
    target_link_libraries(py_module_xxlimited PRIVATE wsock32.lib)
endif()

py_module(py_module_xxlimited_35 xxlimited_35 xxlimited_35.c)
set_target_properties(py_module_xxlimited_35 PROPERTIES OUTPUT_NAME xxlimited_35)
target_link_libraries(py_module_xxlimited_35 PRIVATE pythondll)

if(WIN32)
    target_link_libraries(py_module_xxlimited_35 PRIVATE wsock32.lib)
endif()

py_module(py_module_zoneinfo _zoneinfo _zoneinfo.c)