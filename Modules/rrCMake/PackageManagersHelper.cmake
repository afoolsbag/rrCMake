# zhengrr
# 2019-06-05 – 2019-06-05
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
  if(PROJECT_NAME STREQUAL "Project")
    set(PROJECT_NAME)
  endif()
  HunterGate(
    URL  "https://github.com/ruslo/hunter/archive/v0.23.204.tar.gz"
    SHA1 "32cfed254da901f6f184027d530d8da47e035b85")
endmacro()
