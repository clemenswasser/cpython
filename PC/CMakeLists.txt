add_library(pythondll SHARED "python${PROJECT_VERSION_MAJOR}dll.c")
py_set_output_name(pythondll "python${PROJECT_VERSION_MAJOR}")
target_link_libraries(pythondll PRIVATE py_default_options)
target_compile_definitions(pythondll PRIVATE "PYTHON_DLL_NAME=\"python${PROJECT_VERSION_MAJOR}${PROJECT_VERSION_MINOR}$<$<CONFIG:Debug>:_d>\"")

add_executable(py_venvlauncher launcher.c)
py_set_output_name(py_venvlauncher venvlauncher)
target_link_libraries(py_venvlauncher PRIVATE py_default_static_options)
target_compile_definitions(py_venvlauncher PRIVATE $<$<COMPILE_LANGUAGE:C>:_CONSOLE> $<$<COMPILE_LANGUAGE:C>:VENV_REDIRECT>)

add_executable(py_venvwlauncher WIN32 launcher.c)
py_set_output_name(py_venvwlauncher venvwlauncher)
target_link_libraries(py_venvwlauncher PRIVATE py_default_static_options)
target_compile_definitions(py_venvwlauncher PRIVATE $<$<COMPILE_LANGUAGE:C>:_WINDOWS> $<$<COMPILE_LANGUAGE:C>:VENV_REDIRECT>)

add_executable(pylauncher launcher2.c pylauncher.rc)
py_set_output_name(pylauncher py)
target_link_libraries(pylauncher PRIVATE py_default_static_options)
target_compile_definitions(pylauncher PRIVATE $<$<COMPILE_LANGUAGE:C>:_CONSOLE> $<$<COMPILE_LANGUAGE:C>:_UNICODE> $<$<COMPILE_LANGUAGE:C>:UNICODE>)

add_executable(pywlauncher WIN32 launcher.c)
py_set_output_name(pywlauncher pyw)
target_link_libraries(pywlauncher PRIVATE py_default_static_options)
target_compile_definitions(pywlauncher PRIVATE $<$<COMPILE_LANGUAGE:C>:_WINDOWS> $<$<COMPILE_LANGUAGE:C>:_UNICODE> $<$<COMPILE_LANGUAGE:C>:UNICODE>)

py_module(py_module_testconsole _testconsole "_testconsole.c")
target_compile_definitions(py_module_testconsole PRIVATE _CONSOLE)

add_executable(pythonw WIN32 WinMain.c)
py_set_output_name(pythonw pythonw)
target_link_libraries(pythonw PRIVATE py_default_static_options pythoncore)
target_compile_definitions(pythonw PRIVATE _WINDOWS)
py_set_stack_size(pythonw)

py_module(py_module_winsound winsound winsound.c)
target_link_libraries(py_module_winsound PRIVATE winmm.lib)

enable_language(CXX)
py_module(py_module_wmi _wmi _wmimodule.cpp)
target_compile_features(py_module_wmi PRIVATE cxx_std_20)
target_link_libraries(py_module_wmi PRIVATE wbemuuid.lib propsys.lib)
