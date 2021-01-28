# zhengrr
# 2019-06-05 – 2019-11-20
# Unlicense

cmake_minimum_required(VERSION 3.10)
cmake_policy(VERSION 3.10)

include_guard()  # 3.10

#.rst:
# .. command:: include_conan_script
#
#   检查、下载并包含 `conan.cmake` 脚本。
#
#   .. code-block:: cmake
#
#     include_conan_script()
#
#   参见：
#
#   - `cmake-conan <https://github.com/conan-io/cmake-conan>`_
#
macro(include_conan_script)
  if(NOT EXISTS "${CMAKE_BINARY_DIR}/conan.cmake")
    message(STATUS "Downloading conan.cmake script")
    file(
      DOWNLOAD "https://raw.githubusercontent.com/conan-io/cmake-conan/master/conan.cmake"
               "${CMAKE_BINARY_DIR}/conan.cmake"
               SHOW_PROGRESS
      STATUS   _include_conan_script_Status)
    list(GET _include_conan_script_Status 0 _include_conan_script_StatusCode)
    if(NOT _include_conan_script_StatusCode EQUAL 0)
      file(REMOVE "${CMAKE_BINARY_DIR}/conan.cmake")
      list(GET _include_conan_script_Status 1 _include_conan_script_StatusText)
      message(FATAL_ERROR "Download conan.cmake script failed: ${_include_conan_script_StatusText}")
    endif()
    message(STATUS "Downloading conan.cmake script - done")
  endif()
  include("${CMAKE_BINARY_DIR}/conan.cmake")
endmacro()
