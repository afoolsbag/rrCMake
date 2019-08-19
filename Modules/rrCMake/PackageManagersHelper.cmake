# zhengrr
# 2019-06-05 – 2019-07-30
# Unlicense

cmake_minimum_required(VERSION 3.10)
cmake_policy(VERSION 3.10)

include_guard()

#.rst:
# .. command:: include_conan_script
#
#   检查、下载并包含 `conan` 脚本。
macro(include_conan_script)
  if(NOT EXISTS "${CMAKE_BINARY_DIR}/conan.cmake")
    message(STATUS "Downloading conan.cmake script")
    file(DOWNLOAD "https://raw.githubusercontent.com/conan-io/cmake-conan/master/conan.cmake"
                  "${CMAKE_BINARY_DIR}/conan.cmake"
         SHOW_PROGRESS STATUS zStatus)
    list(GET zStatus 0 sStatusCode)
    if(NOT sStatusCode EQUAL 0)
      file(REMOVE "${CMAKE_BINARY_DIR}/conan.cmake")
      list(GET zStatus 1 sStatusText)
      message(FATAL_ERROR "Download conan.cmake script failed: ${sStatusText}")
    endif()
    message(STATUS "Downloading conan.cmake script - done")
  endif()
  include("${CMAKE_BINARY_DIR}/conan.cmake")
endmacro()

#.rst:
# .. command:: include_hunter_gate_script
#
#   检查、下载并包含 `HunterGate` 脚本。
macro(include_hunter_gate_script)
  if(NOT EXISTS "${CMAKE_BINARY_DIR}/HunterGate.cmake")
    message(STATUS "Downloading HunterGate.cmake script")
    file(DOWNLOAD "https://raw.githubusercontent.com/hunter-packages/gate/master/cmake/HunterGate.cmake"
                  "${CMAKE_BINARY_DIR}/HunterGate.cmake"
         SHOW_PROGRESS STATUS zStatus)
    list(GET zStatus 0 sStatusCode)
    if(NOT sStatusCode EQUAL 0)
      file(REMOVE "${CMAKE_BINARY_DIR}/HunterGate.cmake")
      list(GET zStatus 1 sStatusText)
      message(FATAL_ERROR "Download HunterGate.cmake script failed: ${sStatusText}")
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

  # https://github.com/ruslo/hunter/releases
  HunterGate(
    URL "https://github.com/ruslo/hunter/archive/v0.23.211.tar.gz"
    SHA1 "c022f0c2480e835a6bafdd734035ec2071b51897")

  # 默认将 Hunter 参数隐藏到 Advanced
  mark_as_advanced(HUNTER_CONFIGURATION_TYPES
                   HUNTER_ENABLED
                   HUNTER_MSVC_VCVARSALL
                   HUNTER_NO_TOOLCHAIN_ID_RECALCULATION
                   HUNTER_STATUS_DEBUG
                   HUNTER_STATUS_PRINT
                   HUNTER_TLS_VERIFY)
endmacro()
