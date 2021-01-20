# zhengrr
# 2016-10-08 – 2021-01-20
# Unlicense

cmake_minimum_required(VERSION 3.10)
cmake_policy(VERSION 3.10)

include_guard()  # 3.10

#[=======================================================================[.rst:
.. command:: _rrproject_set_project_variable

  内部命令：设置项目变量。

  .. code-block:: cmake

    _rrproject_set_project_variable(<name-without-prefix> [<value>...])

  该命令将至少设置以下两个变量：

  - ``PROJECT_<name-without-prefix>``
  - ``${PROJECT_NAME}_<name-without-prefix>``

  且，若当前项目为顶层项目，该命令还会设置 ``CMAKE_PROJECT`` 前缀变量：

  - ``CMAKE_PROJECT_<name-without-prefix>``

  参见：

  - `project <https://cmake.org/cmake/help/latest/command/project.html>`_
  - `set <https://cmake.org/cmake/help/latest/command/set.html>`_

#]=======================================================================]
macro(_rrproject_set_project_variable sNameWithoutPrefix)
  set("PROJECT_${sNameWithoutPrefix}" ${ARGN})
  set("${PROJECT_NAME}_${sNameWithoutPrefix}" ${ARGN})
  if(PROJECT_SOURCE_DIR STREQUAL CMAKE_SOURCE_DIR)
    set("CMAKE_PROJECT_${sNameWithoutPrefix}" ${ARGN})
  endif()
endmacro()

#[=======================================================================[.rst:
.. command:: rr_project

  基于 ``project`` 命令，提供更多选项和功能。

  .. code-block:: cmake

    rr_project(
      <argument-of-preject-command>...
      [TIME_AS_VERSION]
      [AUTHORS <author>...]
      [LICENSE <license>])

  参见：

  - `project <https://cmake.org/cmake/help/latest/command/project.html>`_

#]=======================================================================]
macro(rr_project)
  set(_rr_project_zOptKws    TIME_AS_VERSION)
  set(_rr_project_zOneValKws LICENSE
                             VERSION)
  set(_rr_project_zMutValKws AUTHORS)
  cmake_parse_arguments("_rr_project" "${_rr_project_zOptKws}" "${_rr_project_zOneValKws}" "${_rr_project_zMutValKws}" ${ARGV})
  unset(_rr_project_zMutValKws)
  unset(_rr_project_zOneValKws)
  unset(_rr_project_zOptKws)

  # 选项：VERSION 和 TIME_AS_VERSION
  if(DEFINED _rr_project_VERSION)
    if(_rr_project_TIME_AS_VERSION)
      message(AUTHOR_WARNING "Keyword VERSION is used, ignore keyword TIME_AS_VERSION.")
    endif()
    set(_rr_project_oVersion VERSION ${_rr_project_VERSION})
  else()
    if(_rr_project_TIME_AS_VERSION)
      string(TIMESTAMP _rr_project_oVersion "%Y.%m.%d.%H%M")
      list(INSERT _rr_project_oVersion 0 VERSION)
    else()
      set(_rr_project_oVersion)
    endif()
  endif()

  # 基础：project
  project(${_rr_project_UNPARSED_ARGUMENTS} ${_rr_project_oVersion})

  unset(_rr_project_oVersion)

  # 选项：AUTHORS
  if(DEFINED _rr_project_AUTHORS)
    _rrproject_set_project_variable(AUTHORS ${_rr_project_AUTHORS})
  elseif(DEFINED PRODUCT_AUTHORS)
    _rrproject_set_project_variable(AUTHORS ${PRODUCT_AUTHORS})
  else()
    _rrproject_set_project_variable(AUTHORS)
  endif()

  # 选项：LICENSE
  if(DEFINED _rr_project_LICENSE)
    _rrproject_set_project_variable(LICENSE "${_rr_project_LICENSE}")
  elseif(DEFINED PRODUCT_LICENSE)
    _rrproject_set_project_variable(LICENSE "${PRODUCT_LICENSE}")
  else()
    _rrproject_set_project_variable(LICENSE)
  endif()

  # 功能：PROJECT_NAME_LOWER
  string(TOLOWER "${PROJECT_NAME}" _rr_project_sNameLower)
  _rrproject_set_project_variable(NAME_LOWER "${_rr_project_sNameLower}")
  unset(_rr_project_sNameLower)

  # 功能：PROJECT_NAME_UPPER
  string(TOUPPER "${PROJECT_NAME}" _rr_project_sNameUpper)
  _rrproject_set_project_variable(NAME_UPPER "${_rr_project_sNameUpper}")
  unset(_rr_project_sNameUpper)

  # 功能：PROJECT_VERSION_MAJOR 默认值
  if("${PROJECT_VERSION_MAJOR}" STREQUAL "")
    _rrproject_set_project_variable(VERSION_MAJOR 0)
  endif()

  # 功能：PROJECT_VERSION_MINOR 默认值
  if("${PROJECT_VERSION_MINOR}" STREQUAL "")
    _rrproject_set_project_variable(VERSION_MINOR 0)
  endif()

  # 功能：PROJECT_VERSION_PATCH 默认值
  if("${PROJECT_VERSION_PATCH}" STREQUAL "")
    _rrproject_set_project_variable(VERSION_PATCH 0)
  endif()

  # 功能：PROJECT_VERSION_TWEAK 默认值
  if("${PROJECT_VERSION_TWEAK}" STREQUAL "")
    _rrproject_set_project_variable(VERSION_TWEAK 0)
  endif()

endmacro()

#[=======================================================================[.rst:
.. command:: rr_project_extra

  为避免
  
  ::

    CMake Warning (dev) in CMakeLists.txt:
    No project() command is present.  The top-level CMakeLists.txt file must
    contain a literal, direct call to the project() command.  Add a line of
    code such as

      project(ProjectName)

    near the top of the file, but after cmake_minimum_required().

    CMake is pretending there is a "project(Project)" command on the first
    line.
    This warning is for project developers.  Use -Wno-dev to suppress it.

  开发者警告，提供 ``rr_project`` 命令的缀加版。

  .. code-block:: cmake

    project(
      <argument-of-preject-command>...)
    rr_project_extra(
      [TIME_AS_VERSION]
      [AUTHORS <author>...]
      [LICENSE <license>])

  参见：

  - `project <https://cmake.org/cmake/help/latest/command/project.html>`_
  - :command:`rr_project`

#]=======================================================================]
function(rr_project_extra)
  set(zOptKws    TIME_AS_VERSION)
  set(zOneValKws LICENSE)
  set(zMutValKws AUTHORS)
  cmake_parse_arguments(PARSE_ARGV 0 "" "${zOptKws}" "${zOneValKws}" "${zMutValKws}")

  # 选项：TIME_AS_VERSION
  if(_TIME_AS_VERSION)
    if(NOT "${PROJECT_VERSION}" STREQUAL "")
      message(AUTHOR_WARNING "PROJECT_VERSION isn't empty, ignore keyword TIME_AS_VERSION.")
    else()
      string(TIMESTAMP vMajor "%Y")
      math(EXPR vMajor "${vMajor}")
      _rrproject_set_project_variable(VERSION_MAJOR "${vMajor}" PARENT_SCOPE)
      set(PROJECT_VERSION_MAJOR "${vMajor}")  # 同时改变本作用域内的变量值，用于后续的默认值判定

      string(TIMESTAMP vMinor "%m")
      math(EXPR vMinor "${vMinor}")
      _rrproject_set_project_variable(VERSION_MINOR "${vMinor}" PARENT_SCOPE)
      set(PROJECT_VERSION_MINOR "${vMinor}")  # 同上

      string(TIMESTAMP vPatch "%d")
      math(EXPR vPatch "${vPatch}")
      _rrproject_set_project_variable(VERSION_PATCH "${vPatch}" PARENT_SCOPE)
      set(PROJECT_VERSION_PATCH "${vPatch}")  # 同上

      string(TIMESTAMP vTweak "%H%M")
      math(EXPR vTweak "${vTweak}")
      _rrproject_set_project_variable(VERSION_TWEAK "${vTweak}" PARENT_SCOPE)
      set(PROJECT_VERSION_TWEAK "${vTweak}")  # 同上

      set(vVersion "${vMajor}.${vMinor}.${vPatch}.${vTweak}")
      _rrproject_set_project_variable(VERSION "${vVersion}" PARENT_SCOPE)
    endif()
  endif()

  # 选项：AUTHORS
  if(DEFINED _AUTHORS)
    _rrproject_set_project_variable(AUTHORS ${_AUTHORS} PARENT_SCOPE)
  elseif(DEFINED PRODUCT_AUTHORS)
    _rrproject_set_project_variable(AUTHORS ${PRODUCT_AUTHORS} PARENT_SCOPE)
  else()
    _rrproject_set_project_variable(AUTHORS PARENT_SCOPE)
  endif()

  # 选项：LICENSE
  if(DEFINED _LICENSE)
    _rrproject_set_project_variable(LICENSE ${_LICENSE} PARENT_SCOPE)
  elseif(DEFINED PRODUCT_LICENSE)
    _rrproject_set_project_variable(LICENSE ${PRODUCT_LICENSE} PARENT_SCOPE)
  else()
    _rrproject_set_project_variable(LICENSE PARENT_SCOPE)
  endif()

  # 功能：PROJECT_NAME_LOWER
  string(TOLOWER "${PROJECT_NAME}" sLower)
  _rrproject_set_project_variable(NAME_LOWER "${sLower}" PARENT_SCOPE)

  # 功能：PROJECT_NAME_UPPER
  string(TOUPPER "${PROJECT_NAME}" sUpper)
  _rrproject_set_project_variable(NAME_UPPER "${sUpper}" PARENT_SCOPE)

  # 功能：PROJECT_VERSION_MAJOR 默认值
  if("${PROJECT_VERSION_MAJOR}" STREQUAL "")
    _rrproject_set_project_variable(VERSION_MAJOR 0 PARENT_SCOPE)
  endif()

  # 功能：PROJECT_VERSION_MINOR 默认值
  if("${PROJECT_VERSION_MINOR}" STREQUAL "")
    _rrproject_set_project_variable(VERSION_MINOR 0 PARENT_SCOPE)
  endif()

  # 功能：PROJECT_VERSION_PATCH 默认值
  if("${PROJECT_VERSION_PATCH}" STREQUAL "")
    _rrproject_set_project_variable(VERSION_PATCH 0 PARENT_SCOPE)
  endif()

  # 功能：PROJECT_VERSION_TWEAK 默认值
  if("${PROJECT_VERSION_TWEAK}" STREQUAL "")
    _rrproject_set_project_variable(VERSION_TWEAK 0 PARENT_SCOPE)
  endif()
endfunction()

#.rst:
# .. command:: rr_project_debug_information
#
#   将 ``rr_project`` 命令相关的信息输出，以帮助调试。
#
#   .. code-block:: cmake
#
#     rr_project_debug_information()
#
#   参见：
#
#   - `project <https://cmake.org/cmake/help/latest/command/project.html>`_
#   - :command:`rr_project`
#   - :command:`rr_project_extra`
#   - `CMAKE_MESSAGE_LOG_LEVEL <https://cmake.org/cmake/help/latest/variable/CMAKE_MESSAGE_LOG_LEVEL.html>`_
#
function(rr_project_debug_information)
  if(NOT DEFINED CACHE{CMAKE_MESSAGE_LOG_LEVEL})
    set(CMAKE_MESSAGE_LOG_LEVEL "DEBUG" CACHE STRING "message() logging level.")
    set_property(CACHE CMAKE_MESSAGE_LOG_LEVEL
                 PROPERTY STRINGS "FATAL_ERROR"
                                  "SEND_ERROR"
                                  "WARNING"
                                  "AUTHOR_WARNING"
                                  "DEPRECATION"
                                  "NOTICE"
                                  "STATUS"
                                  "VERBOSE"
                                  "DEBUG"
                                  "TRACE")
  endif()

  get_property(zLang GLOBAL PROPERTY ENABLED_LANGUAGES)

  message(DEBUG "================================================================================")
  message(DEBUG "RR_PROJECT_DEBUG_INFORMATION")
  message(DEBUG "")
  message(DEBUG "CMAKE_PROJECT_NAME:                '${CMAKE_PROJECT_NAME}'")
  message(DEBUG "CMAKE_SOURCE_DIR:                  '${CMAKE_SOURCE_DIR}'")
  message(DEBUG "CMAKE_BINARY_DIR:                  '${CMAKE_BINARY_DIR}'")
  message(DEBUG "CMAKE_PROJECT_VERSION:             '${CMAKE_PROJECT_VERSION}'")
  message(DEBUG "CMAKE_PROJECT_VERSION_MAJOR:       '${CMAKE_PROJECT_VERSION_MAJOR}'")
  message(DEBUG "CMAKE_PROJECT_VERSION_MINOR:       '${CMAKE_PROJECT_VERSION_MINOR}'")
  message(DEBUG "CMAKE_PROJECT_VERSION_PATCH:       '${CMAKE_PROJECT_VERSION_PATCH}'")
  message(DEBUG "CMAKE_PROJECT_VERSION_TWEAK:       '${CMAKE_PROJECT_VERSION_TWEAK}'")
  message(DEBUG "CMAKE_PROJECT_VERSION_DESCRIPTION: '${CMAKE_PROJECT_VERSION_DESCRIPTION}'")
  message(DEBUG "CMAKE_PROJECT_HOMEPAGE_URL:        '${CMAKE_PROJECT_HOMEPAGE_URL}'")
  message(DEBUG "CMAKE_PROJECT_AUTHORS:             '${CMAKE_PROJECT_AUTHORS}'")
  message(DEBUG "CMAKE_PROJECT_LICENSE:             '${CMAKE_PROJECT_LICENSE}'")
  message(DEBUG "")
  message(DEBUG "PROJECT_NAME:                      '${PROJECT_NAME}'")
  message(DEBUG "PROJECT_SOURCE_DIR:                '${PROJECT_SOURCE_DIR}'")
  message(DEBUG "PROJECT_BINARY_DIR:                '${PROJECT_BINARY_DIR}'")
  message(DEBUG "PROJECT_VERSION:                   '${PROJECT_VERSION}'")
  message(DEBUG "PROJECT_VERSION_MAJOR:             '${PROJECT_VERSION_MAJOR}'")
  message(DEBUG "PROJECT_VERSION_MINOR:             '${PROJECT_VERSION_MINOR}'")
  message(DEBUG "PROJECT_VERSION_PATCH:             '${PROJECT_VERSION_PATCH}'")
  message(DEBUG "PROJECT_VERSION_TWEAK:             '${PROJECT_VERSION_TWEAK}'")
  message(DEBUG "PROJECT_VERSION_DESCRIPTION:       '${PROJECT_VERSION_DESCRIPTION}'")
  message(DEBUG "PROJECT_HOMEPAGE_URL:              '${PROJECT_HOMEPAGE_URL}'")
  message(DEBUG "PROJECT_AUTHORS:                   '${PROJECT_AUTHORS}'")
  message(DEBUG "PROJECT_LICENSE:                   '${PROJECT_LICENSE}'")
  message(DEBUG "")
  message(DEBUG "ENABLED_LANGUAGES:                 '${zLang}'")
  message(DEBUG "--------------------------------------------------------------------------------")
endfunction()
