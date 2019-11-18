# zhengrr
# 2019-06-05 – 2019-11-18
# Unlicense

cmake_minimum_required(VERSION 3.10)
cmake_policy(VERSION 3.10)

include_guard()  # 3.10

#.rst:
# .. command:: include_conan_script
#
#   检查、下载并包含 `conan` 脚本。
macro(include_conan_script)
  if(NOT EXISTS "${CMAKE_BINARY_DIR}/conan.cmake")
    message(STATUS "Downloading conan.cmake script")
    file(DOWNLOAD "https://raw.githubusercontent.com/conan-io/cmake-conan/master/conan.cmake"
                  "${CMAKE_BINARY_DIR}/conan.cmake"
                  SHOW_PROGRESS
         STATUS   INCLUDE_CONAN_SCRIPT_VAR_STATUS)
    list(GET INCLUDE_CONAN_SCRIPT_VAR_STATUS 0 INCLUDE_CONAN_SCRIPT_VAR_STATUS_CODE)
    if(NOT INCLUDE_CONAN_SCRIPT_VAR_STATUS_CODE EQUAL 0)
      file(REMOVE "${CMAKE_BINARY_DIR}/conan.cmake")
      list(GET INCLUDE_CONAN_SCRIPT_VAR_STATUS 1 INCLUDE_CONAN_SCRIPT_VAR_STATUS_TEXT)
      message(FATAL_ERROR "Download conan.cmake script failed: ${INCLUDE_CONAN_SCRIPT_VAR_STATUS_TEXT}")
    endif()
    message(STATUS "Downloading conan.cmake script - done")
  endif()
  include("${CMAKE_BINARY_DIR}/conan.cmake")
endmacro()
