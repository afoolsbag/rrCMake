cmake_minimum_required(VERSION 3.10)
cmake_policy(VERSION 3.10)

list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_LIST_DIR}/../../Modules")
include(rrCMake)

project(rrCheck NONE)


_rrcheck_check_message_mode(" " x)
message("x: ${x}")

set(zArgv "1" "2" "" "4")
rr_check_argc("${zArgv}" 3)

rr_check_fext_name("%0zArgv")
