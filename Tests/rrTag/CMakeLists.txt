cmake_minimum_required(VERSION 3.10)
cmake_policy(VERSION 3.10)

list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_LIST_DIR}/../../Modules")
include(rrCMake)

project(rrTag)
rr_get_taa_tag(sTaaTag)
message("Current TAA tag: '${sTaaTag}'")
