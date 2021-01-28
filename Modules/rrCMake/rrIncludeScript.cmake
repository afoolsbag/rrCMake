# zhengrr
# 2019-06-05 – 2021-01-28
# Unlicense

cmake_minimum_required(VERSION 3.17)
cmake_policy(VERSION 3.17)

include_guard()  # 3.10

#[=======================================================================[.rst:
.. command:: rr_include_conan_script

  检查、下载并包含 `conan.cmake` 脚本。

  .. code-block:: cmake

    rr_include_conan_script()

  参见：

  - `cmake-conan <https://github.com/conan-io/cmake-conan>`_

#]=======================================================================]
macro(rr_include_conan_script)
  if(NOT EXISTS "${CMAKE_BINARY_DIR}/conan.cmake")
    message(CHECK_START "Downloading conan.cmake script")  # 3.17
    file(
      DOWNLOAD "https://raw.githubusercontent.com/conan-io/cmake-conan/master/conan.cmake"
               "${CMAKE_BINARY_DIR}/conan.cmake"
               SHOW_PROGRESS
      STATUS   _rr_include_conan_script_zStatus)
    list(GET _rr_include_conan_script_zStatus 0 _rr_include_conan_script_nStatusCode)
    if(NOT _rr_include_conan_script_nStatusCode EQUAL 0)
      file(REMOVE "${CMAKE_BINARY_DIR}/conan.cmake")
      list(GET _rr_include_conan_script_zStatus 1 _rr_include_conan_script_sStatusText)
      message(CHECK_FAIL "failed: ${_rr_include_conan_script_sStatusText}")
    endif()
    message(CHECK_PASS "done")
  endif()
  include("${CMAKE_BINARY_DIR}/conan.cmake")
endmacro()

#[=======================================================================[.rst:
.. command:: rr_include_hunter_gate_script

  检查、下载、包含并初始化 `HunterGate.cmake` 脚本。

  .. code-block:: cmake

    rr_include_hunter_gate_script()

  参见：

  - `Hunter <https://github.com/cpp-pm/hunter>`_

#]=======================================================================]
macro(rr_include_hunter_gate_script)
  if(NOT EXISTS "${CMAKE_BINARY_DIR}/HunterGate.cmake")
    message(CHECK_START "Downloading HunterGate.cmake script")
    file(
      DOWNLOAD "https://raw.githubusercontent.com/cpp-pm/gate/master/cmake/HunterGate.cmake"
               "${CMAKE_BINARY_DIR}/HunterGate.cmake"
               SHOW_PROGRESS
      STATUS   _rr_include_hunter_gate_script_zStatus)
    list(GET _rr_include_hunter_gate_script_zStatus 0 _rr_include_hunter_gate_script_nStatusCode)
    if(NOT _rr_include_hunter_gate_script_nStatusCode EQUAL 0)
      file(REMOVE "${CMAKE_BINARY_DIR}/HunterGate.cmake")
      list(GET _rr_include_hunter_gate_script_zStatus 1 _rr_include_hunter_gate_script_sStatusText)
      message(CHECK_FAIL "failed: ${_rr_include_hunter_gate_script_sStatusText}")
    endif()
    message(CHECK_PASS "done")
  endif()
  include("${CMAKE_BINARY_DIR}/HunterGate.cmake")

  # 允许在子目录的 project 指令前使用 HunterGate
  if(NOT CMAKE_CURRENT_SOURCE_DIR STREQUAL CMAKE_SOURCE_DIR AND PROJECT_NAME STREQUAL CMAKE_PROJECT_NAME)
    set(PROJECT_NAME)
  endif()

  # 默认启用“不要重复计算工具链标识”
  option(HUNTER_NO_TOOLCHAIN_ID_RECALCULATION "No Toolchain-ID recalculation" ON)

  # https://github.com/cpp-pm/hunter/releases
  HunterGate(
    URL "https://github.com/cpp-pm/hunter/archive/v0.23.291.tar.gz"
    SHA1 "4f57243b24a02b9c7ec5ea02c09d5c77c6a97cba"
  )

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
