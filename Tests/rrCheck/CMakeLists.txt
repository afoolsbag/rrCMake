cmake_minimum_required(VERSION 3.10)
cmake_policy(VERSION 3.10)

list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_LIST_DIR}/../../Modules")
include(rrCMake)

project(rrCheck NONE)

set(zArgv "foo" "bar" "" "1337")
rr_check_argc("${zArgv}" 3)
rr_check_argc("${zArgv}" 3 3)
rr_check_argc("${zArgv}" 4 4 FATAL_ERROR)

rr_check_c_name("1337")
rr_check_c_name("foobar" FATAL_ERROR)

rr_check_cmake_name("1/52")
rr_check_cmake_name("foobar" FATAL_ERROR)

rr_check_fext_name("lala")
rr_check_fext_name(".exe" FATAL_ERROR)

set(zArgn "foo" "bar")
rr_check_no_argn("${zArgn}")
rr_check_no_argn("" FATAL_ERROR)

rr_check_target("foobar")
