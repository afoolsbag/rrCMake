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
function(include_conan_script)
  if(NOT EXISTS "${CMAKE_BINARY_DIR}/conan.cmake")
    message(STATUS "Downloading conan.cmake script")
    file(DOWNLOAD "https://raw.githubusercontent.com/conan-io/cmake-conan/v0.14/conan.cmake"
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
endfunction()
