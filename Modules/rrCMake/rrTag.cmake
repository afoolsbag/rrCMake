# zhengrr
# 2018-06-06 – 2021-01-21
# Unlicense

cmake_minimum_required(VERSION 3.10)
cmake_policy(VERSION 3.10)

include_guard()  # 3.10

if(NOT COMMAND rr_check_cmake_name)
  include("${CMAKE_CURRENT_LIST_DIR}/rrNaming.cmake")
endif()

#[=======================================================================[.rst:
.. command:: rr_get_toolset_tag

  获取工具集标签，如 ``vc141``（Visual Studio 2017）、``vc142``（Visual Studio 2019）。

  .. code-block:: cmake

    rr_get_toolset_tag(<variable>)

  参见：

  - `Boost Library Naming <https://boost.org/doc/libs/master/more/getting_started/windows.html#library-naming>`_
  - `FindBoost.cmake <https://gitlab.kitware.com/cmake/cmake/blob/master/Modules/FindBoost.cmake>`_

#]=======================================================================]
function(rr_get_toolset_tag xVariable)
  #
  # 前置断言
  #

  if(NOT ${ARGC} EQUAL 1)
    message(FATAL_ERROR "Incorrect number of arguments: ${ARGV} (${ARGC}).")
  endif()

  rr_check_cmake_name("${xVariable}" AUTHOR_WARNING)

  #
  # 业务逻辑
  #

  get_cmake_property(zLangs ENABLED_LANGUAGES)
  foreach(sLang IN LISTS zLangs)

    # https://cmake.org/cmake/help/latest/variable/CMAKE_LANG_COMPILER_ID.html
    if(CMAKE_${sLang}_COMPILER_ID STREQUAL "Intel")
      if(WIN32)
        set("${xVariable}" "iw" PARENT_SCOPE)
      else()
        set("${xVariable}" "il" PARENT_SCOPE)
      endif()
      return()
    endif()

    # https://cmake.org/cmake/help/latest/variable/GHS-MULTI.html
    if(GHS-MULTI)
      set("${xVariable}" "ghs" PARENT_SCOPE)
      return()
    endif()

    # https://cmake.org/cmake/help/latest/variable/MSVC.html
    # https://cmake.org/cmake/help/latest/variable/MSVC_TOOLSET_VERSION.html
    if(MSVC)
      if(80 LESS_EQUAL MSVC_TOOLSET_VERSION)
        set("${xVariable}" "vc${MSVC_TOOLSET_VERSION}" PARENT_SCOPE)
      elseif(1310 LESS_EQUAL MSVC_VERSION)
        set("${xVariable}" "vc71" PARENT_SCOPE)
      elseif(1300 LESS_EQUAL MSVC_VERSION)
        set("${xVariable}" "vc7" PARENT_SCOPE)
      elseif(1200 LESS_EQUAL MSVC_VERSION)
        set("${xVariable}" "vc6" PARENT_SCOPE)
      else()
        set("${xVariable}" "vc" PARENT_SCOPE)
      endif()
      return()
    endif()

    # https://cmake.org/cmake/help/latest/variable/BORLAND.html
    if(BORLAND)
      set("${xVariable}" "bcb" PARENT_SCOPE)
      return()
    endif()

    # https://cmake.org/cmake/help/latest/variable/CMAKE_LANG_COMPILER_ID.html
    if(CMAKE_${sLang}_COMPILER_ID STREQUAL "SunPro")
      set("${xVariable}" "sw" PARENT_SCOPE)
      return()
    endif()

    # https://cmake.org/cmake/help/latest/variable/CMAKE_LANG_COMPILER_ID.html
    if(CMAKE_${sLang}_COMPILER_ID STREQUAL "XL")
      set("${xVariable}" "xlc" PARENT_SCOPE)
      return()
    endif()

    # https://cmake.org/cmake/help/latest/variable/MINGW.html
    if(MINGW)
      string(REGEX REPLACE "([0-9]+)\\.([0-9]+)(\\.[0-9]+)?" "\\1\\2" sVer "${CMAKE_${sLang}_COMPILER_VERSION}")
      set("${xVariable}" "mgw${sVer}" PARENT_SCOPE)
      return()
    endif()

    # https://cmake.org/cmake/help/latest/variable/UNIX.html
    # https://cmake.org/cmake/help/latest/variable/CMAKE_LANG_COMPILER_ID.html
    if(UNIX AND CMAKE_${sLang}_COMPILER_ID STREQUAL "GNU")
      string(REGEX REPLACE "([0-9]+)\\.([0-9]+)(\\.[0-9]+)?" "\\1\\2" sVer "${CMAKE_${sLang}_COMPILER_VERSION}")
      if(APPLE)
        set("${xVariable}" "xgcc${sVer}" PARENT_SCOPE)
      else()
        set("${xVariable}" "gcc${sVer}" PARENT_SCOPE)
      endif()
      return()
    endif()

    # https://cmake.org/cmake/help/latest/variable/UNIX.html
    # https://cmake.org/cmake/help/latest/variable/CMAKE_LANG_COMPILER_ID.html
    if(UNIX AND CMAKE_${sLang}_COMPILER_ID STREQUAL "Clang")
      string(REGEX REPLACE "([0-9]+)\\.([0-9]+)(\\.[0-9]+)?" "\\1\\2" sVer "${CMAKE_${sLang}_COMPILER_VERSION}")
      set("${xVariable}" "clang${sVer}" PARENT_SCOPE)
      return()
    endif()

  endforeach()
  set("${xVariable}" "" PARENT_SCOPE)
endfunction()

#[=======================================================================[.rst:
.. command:: rr_get_architecture_tag

  获取架构标签，如 ``x``（x86-32 和 x86-64）、``a``（ARM）。

  .. code-block:: cmake

    rr_get_architecture_tag(<variable>)

  参见：

  - `Boost Library Naming <https://boost.org/doc/libs/master/more/getting_started/windows.html#library-naming>`_
  - `FindBoost.cmake <https://gitlab.kitware.com/cmake/cmake/blob/master/Modules/FindBoost.cmake>`_

#]=======================================================================]
function(rr_get_architecture_tag xVariable)
  #
  # 前置断言
  #

  if(NOT ${ARGC} EQUAL 1)
    message(FATAL_ERROR "Incorrect number of arguments: ${ARGV} (${ARGC}).")
  endif()

  rr_check_cmake_name("${xVariable}" AUTHOR_WARNING)

  #
  # 业务逻辑
  #

  get_cmake_property(zLangs ENABLED_LANGUAGES)
  foreach(sLang IN LISTS zLangs)

    if(CMAKE_${sLang}_COMPILER_ARCHITECTURE_ID STREQUAL "IA64")
      set("${xVariable}" "i" PARENT_SCOPE)
      return()
    endif()

    if(CMAKE_${sLang}_COMPILER_ARCHITECTURE_ID STREQUAL "X86" OR
       CMAKE_${sLang}_COMPILER_ARCHITECTURE_ID STREQUAL "x64")
      set("${xVariable}" "x" PARENT_SCOPE)
      return()
    endif()

    if(CMAKE_${sLang}_COMPILER_ARCHITECTURE_ID MATCHES "^ARM")
      set("${xVariable}" "a" PARENT_SCOPE)
      return()
    endif()

    if(CMAKE_${sLang}_COMPILER_ARCHITECTURE_ID STREQUAL "MIPS")
      set("${xVariable}" "m" PARENT_SCOPE)
      return()
    endif()

  endforeach()
  set("${xVariable}" "" PARENT_SCOPE)
endfunction()

#[=======================================================================[.rst:
.. command::rr_get_address_model_tag

  获取地址模型标签，如 ``64``、``32``。

  .. code-block:: cmake

    rr_get_address_model_tag(<variable>)

  参见：

  - `Boost Library Naming <https://boost.org/doc/libs/master/more/getting_started/windows.html#library-naming>`_
  - `FindBoost.cmake <https://gitlab.kitware.com/cmake/cmake/blob/master/Modules/FindBoost.cmake>`_

#]=======================================================================]
function(rr_get_address_model_tag xVariable)
  #
  # 前置断言
  #

  if(NOT ${ARGC} EQUAL 1)
    message(FATAL_ERROR "Incorrect number of arguments: ${ARGV} (${ARGC}).")
  endif()

  rr_check_cmake_name("${xVariable}" AUTHOR_WARNING)

  #
  # 业务逻辑
  #

  if(CMAKE_SIZEOF_VOID_P EQUAL 8)
    set("${xVariable}" "64" PARENT_SCOPE)
    return()
  endif()

  if(CMAKE_SIZEOF_VOID_P EQUAL 4)
    set("${xVariable}" "32" PARENT_SCOPE)
    return()
  endif()

  set("${xVariable}" "" PARENT_SCOPE)
endfunction()

#[=======================================================================[.rst:
rst:
.. command::rr_get_aa_tag

  获取架构和地址模型标签，如 ``x32``（x86-32）、``x64``（x86-64）。

  .. code-block:: cmake

    rr_get_aa_tag(<variable>)

  参见：

  - :command:`rr_get_architecture_tag`
  - :command:`rr_get_address_model_tag`

#]=======================================================================]
function(rr_get_aa_tag xVariable)
  #
  # 前置断言
  #

  if(NOT ${ARGC} EQUAL 1)
    message(FATAL_ERROR "Incorrect number of arguments: ${ARGV} (${ARGC}).")
  endif()

  rr_check_cmake_name("${xVariable}" AUTHOR_WARNING)

  #
  # 业务逻辑
  #

  rr_get_architecture_tag(sArch)
  rr_get_address_model_tag(sAddr)
  set("${xVariable}" "${sArch}${sAddr}" PARENT_SCOPE)
endfunction()

#[=======================================================================[.rst:
.. command::rr_get_taa_tag

  获取工具集、架构和地址模型标签，如 ``vc142x64``（Visual Studio 2019 x86-64）。

  .. code-block:: cmake

    rr_get_taa_tag(<variable>)

  参见：

  - :command:`rr_get_toolset_tag`
  - :command:`rr_get_architecture_tag`
  - :command:`rr_get_address_model_tag`

#]=======================================================================]
function(rr_get_taa_tag xVariable)
  #
  # 前置断言
  #

  if(NOT ${ARGC} EQUAL 1)
    message(FATAL_ERROR "Incorrect number of arguments: ${ARGV} (${ARGC}).")
  endif()

  check_name_with_cmake_rules("${xVariable}" AUTHOR_WARNING)

  #
  # 业务逻辑
  #

  rr_get_toolset_tag(sTool)
  rr_get_architecture_tag(sArch)
  rr_get_address_model_tag(sAddr)
  set("${xVariable}" "${sTool}${sArch}${sAddr}" PARENT_SCOPE)
endfunction()
