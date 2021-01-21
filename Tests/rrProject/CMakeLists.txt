cmake_minimum_required(VERSION 3.10)
cmake_policy(VERSION 3.10)

list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_LIST_DIR}/../../Modules")
include(rrCMake)

project(
  rrProject
  LANGUAGES NONE)
rr_project_extra(
  TIME_AS_VERSION
  AUTHORS   "zhengrr"
  LICENSE   "Unlicense")

#[[
rr_project(
  rrProject
  LANGUAGES NONE
  TIME_AS_VERSION
  AUTHORS   "zhengrr"
  LICENSE   "Unlicense")
#]]

rr_project_debug_information()
