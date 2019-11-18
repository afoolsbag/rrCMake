# zhengrr
# 2019-06-05 – 2019-11-18
# Unlicense

cmake_minimum_required(VERSION 3.10)
cmake_policy(VERSION 3.10)

include_guard()  # 3.10

#.rst:
# .. command:: include_hunter_gate_script
#
#   检查、下载并包含 `HunterGate` 脚本。
macro(include_hunter_gate_script)
  if(NOT EXISTS "${CMAKE_BINARY_DIR}/HunterGate.cmake")
    message(STATUS "Downloading HunterGate.cmake script")
    file(DOWNLOAD "https://raw.githubusercontent.com/hunter-packages/gate/master/cmake/HunterGate.cmake"
                  "${CMAKE_BINARY_DIR}/HunterGate.cmake"
                  SHOW_PROGRESS
         STATUS   INCLUDE_HUNTER_GATE_SCRIPT_VAR_STATUS)
    list(GET INCLUDE_HUNTER_GATE_SCRIPT_VAR_STATUS 0 INCLUDE_HUNTER_GATE_SCRIPT_VAR_STATUS_CODE)
    if(NOT INCLUDE_HUNTER_GATE_SCRIPT_VAR_STATUS_CODE EQUAL 0)
      file(REMOVE "${CMAKE_BINARY_DIR}/HunterGate.cmake")
      list(GET INCLUDE_HUNTER_GATE_SCRIPT_VAR_STATUS 1 INCLUDE_HUNTER_GATE_SCRIPT_VAR_STATUS_TEXT)
      message(FATAL_ERROR "Download HunterGate.cmake script failed: ${INCLUDE_HUNTER_GATE_SCRIPT_VAR_STATUS_TEXT}")
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
    URL "https://github.com/cpp-pm/hunter/archive/v0.23.228.tar.gz"
    SHA1 "0546cabd20ed784a2245083eb59e9185bf1d63a9")

  # 默认将 Hunter 参数隐藏到 Advanced
  mark_as_advanced(HUNTER_CONFIGURATION_TYPES
                   HUNTER_ENABLED
                   HUNTER_MSVC_VCVARSALL
                   HUNTER_NO_TOOLCHAIN_ID_RECALCULATION
                   HUNTER_STATUS_DEBUG
                   HUNTER_STATUS_PRINT
                   HUNTER_TLS_VERIFY)
endmacro()
