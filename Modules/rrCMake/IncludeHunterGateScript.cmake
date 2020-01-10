# zhengrr
# 2019-06-05 – 2020-01-08
# Unlicense

cmake_minimum_required(VERSION 3.10)
cmake_policy(VERSION 3.10)

include_guard()  # 3.10

#.rst:
# .. command:: include_hunter_gate_script
#
#   检查、下载并包含 `HunterGate.cmake` 脚本。
#
#   .. code-block:: cmake
#
#     include_conan_script()
#
#   参见：
#
#   - `Hunter <https://github.com/cpp-pm/hunter>`_
#
macro(include_hunter_gate_script)
  if(NOT EXISTS "${CMAKE_BINARY_DIR}/HunterGate.cmake")
    message(STATUS "Downloading HunterGate.cmake script")
    file(
      DOWNLOAD "https://raw.githubusercontent.com/hunter-packages/gate/master/cmake/HunterGate.cmake"
               "${CMAKE_BINARY_DIR}/HunterGate.cmake"
               SHOW_PROGRESS
      STATUS   _include_hunter_gate_script_Status)
    list(GET _include_hunter_gate_script_Status 0 _include_hunter_gate_script_StatusCode)
    if(NOT _include_hunter_gate_script_StatusCode EQUAL 0)
      file(REMOVE "${CMAKE_BINARY_DIR}/HunterGate.cmake")
      list(GET _include_hunter_gate_script_Status 1 _include_hunter_gate_script_StatusText)
      message(FATAL_ERROR "Download HunterGate.cmake script failed: ${_include_hunter_gate_script_StatusText}")
    endif()
    message(STATUS "Downloading HunterGate.cmake script - done")
  endif()
  include("${CMAKE_BINARY_DIR}/HunterGate.cmake")

  # 在 CMake 3.14.0-rc3 中，PROJECT_NAME 的缺省值为 "Project" 而非 ""
  if(PROJECT_NAME STREQUAL "Project")
    set(PROJECT_NAME)
  endif()

  # 允许在子目录的 project 指令前使用 HunterGate
  if(NOT CMAKE_CURRENT_SOURCE_DIR STREQUAL CMAKE_SOURCE_DIR AND PROJECT_NAME STREQUAL CMAKE_PROJECT_NAME)
    set(PROJECT_NAME)
  endif()

  # 默认禁用“重复计算工具链标识”
  option(HUNTER_NO_TOOLCHAIN_ID_RECALCULATION "No Toolchain-ID recalculation" ON)

  # https://github.com/cpp-pm/hunter/releases
  HunterGate(
    URL "https://github.com/cpp-pm/hunter/archive/v0.23.241.tar.gz"
    SHA1 "0897935585580d4eece64804f4f48fe9199a7a2c")

  # 默认将 Hunter 参数隐藏到 Advanced
  mark_as_advanced(
    HUNTER_CONFIGURATION_TYPES
    HUNTER_ENABLED
    HUNTER_MSVC_VCVARSALL
    HUNTER_NO_TOOLCHAIN_ID_RECALCULATION
    HUNTER_STATUS_DEBUG
    HUNTER_STATUS_PRINT
    HUNTER_TLS_VERIFY)
endmacro()
