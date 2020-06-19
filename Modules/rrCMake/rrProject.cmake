# zhengrr
# 2016-10-08 – 2020-06-17
# Unlicense

cmake_minimum_required(VERSION 3.10)
cmake_policy(VERSION 3.10)

include_guard()  # 3.10

#.rst:
# .. command:: rr_project
#
#   基于 ``project`` 命令，提供更多选项和功能。
#
#   .. code-block:: cmake
#
#     rr_project(
#       <argument_of_"preject"_command>...
#       [TIME_AS_VERSION]
#       [AUTHORS <author>...]
#       [LICENSE <license>])
#
#   参见：
#
#   - `preject <https://cmake.org/cmake/help/latest/command/project.html>`_
#
macro(rr_project)
  set(_rr_project_zOptKws    TIME_AS_VERSION)
  set(_rr_project_zOneValKws LICENSE
                             VERSION)
  set(_rr_project_zMutValKws AUTHORS)
  cmake_parse_arguments("_rr_project" "${_rr_project_zOptKws}" "${_rr_project_zOneValKws}" "${_rr_project_zMutValKws}" ${ARGV})

  # 选项：TIME_AS_VERSION
  if(_rr_project_TIME_AS_VERSION)
    if(NOT DEFINED _rr_project_VERSION)
      string(TIMESTAMP _rr_project_VERSION "%Y.%m.%d.%H%M")
    else()
      message(AUTHOR_WARNING "Keyword VERSION is used, ignore keyword TIME_AS_VERSION.")
    endif()
  endif()
  if(DEFINED _rr_project_VERSION)
    list(INSERT _rr_project_VERSION 0 VERSION)
  endif()

  # 基础：project
  project(${_rr_project_UNPARSED_ARGUMENTS} ${_rr_project_VERSION})

  # 选项：AUTHORS
  if(DEFINED _rr_project_AUTHORS)
    set(PROJECT_AUTHORS ${_rr_project_AUTHORS})
    set("${PROJECT_NAME}_AUTHORS" ${_rr_project_AUTHORS})
    if(PROJECT_SOURCE_DIR STREQUAL CMAKE_SOURCE_DIR)
      set(CMAKE_PROJECT_AUTHORS ${_rr_project_AUTHORS})
    endif()
  elseif(DEFINED PRODUCT_AUTHORS)
    set(PROJECT_AUTHORS ${PRODUCT_AUTHORS})
    set("${PROJECT_NAME}_AUTHORS" ${PRODUCT_AUTHORS})
  else()
    set(PROJECT_AUTHORS)
    set("${PROJECT_NAME}_AUTHORS")
  endif()

  # 选项：LICENSE
  if(DEFINED _rr_project_LICENSE)
    set(PROJECT_LICENSE "${_rr_project_LICENSE}")
    set("${PROJECT_NAME}_LICENSE" "${_rr_project_LICENSE}")
    if(PROJECT_SOURCE_DIR STREQUAL CMAKE_SOURCE_DIR)
      set(CMAKE_PROJECT_LICENSE "${_rr_project_LICENSE}")
    endif()
  elseif(DEFINED PRODUCT_LICENSE)
    set(PROJECT_LICENSE "${PRODUCT_LICENSE}")
    set("${PROJECT_NAME}_LICENSE" "${PRODUCT_LICENSE}")
  else()
    set(PROJECT_LICENSE)
    set("${PROJECT_NAME}_LICENSE")
  endif()

  # 功能：PROJECT_NAME_LOWER
  string(TOLOWER "${PROJECT_NAME}" PROJECT_NAME_LOWER)
  set("${PROJECT_NAME}_LOWER" "${PROJECT_NAME_LOWER}")
  if(PROJECT_SOURCE_DIR STREQUAL CMAKE_SOURCE_DIR)
    set(CMAKE_PROJECT_NAME_LOWER "${PROJECT_NAME_LOWER}")
  endif()

  # 功能：PROJECT_NAME_UPPER
  string(TOUPPER "${PROJECT_NAME}" PROJECT_NAME_UPPER)
  set("${PROJECT_NAME}_UPPER" "${PROJECT_NAME_UPPER}")
  if(PROJECT_SOURCE_DIR STREQUAL CMAKE_SOURCE_DIR)
    set(CMAKE_PROJECT_NAME_UPPER "${PROJECT_NAME_UPPER}")
  endif()

  # 功能：PROJECT_VERSION_MAJOR 默认值
  if(NOT "${PROJECT_VERSION_MAJOR}")
    set(PROJECT_VERSION_MAJOR 0)
    set("${PROJECT_NAME}_VERSION_MAJOR" 0)
    if(PROJECT_SOURCE_DIR STREQUAL CMAKE_SOURCE_DIR)
      set(CMAKE_PROJECT_VERSION_MAJOR 0)
    endif()
  endif()

  # 功能：PROJECT_VERSION_MINOR 默认值
  if(NOT "${PROJECT_VERSION_MINOR}")
    set(PROJECT_VERSION_MINOR 0)
    set("${PROJECT_NAME}_VERSION_MINOR" 0)
    if(PROJECT_SOURCE_DIR STREQUAL CMAKE_SOURCE_DIR)
      set(CMAKE_PROJECT_VERSION_MINOR 0)
    endif()
  endif()

  # 功能：PROJECT_VERSION_PATCH 默认值
  if(NOT "${PROJECT_VERSION_PATCH}")
    set(PROJECT_VERSION_PATCH 0)
    set("${PROJECT_NAME}_VERSION_PATCH" 0)
    if(PROJECT_SOURCE_DIR STREQUAL CMAKE_SOURCE_DIR)
      set(CMAKE_PROJECT_VERSION_PATCH 0)
    endif()
  endif()

  # 功能：PROJECT_VERSION_TWEAK 默认值
  if(NOT "${PROJECT_VERSION_TWEAK}")
    set(PROJECT_VERSION_TWEAK 0)
    set("${PROJECT_NAME}_VERSION_TWEAK" 0)
    if(PROJECT_SOURCE_DIR STREQUAL CMAKE_SOURCE_DIR)
      set(CMAKE_PROJECT_VERSION_TWEAK 0)
    endif()
  endif()

endmacro()

#.rst:
# .. command:: rr_project_extra
#
#   为避免“No project() command is present. ......”开发者警告，提供 ``rr_project`` 命令的附加版命令。
#
#   .. code-block:: cmake
#
#     project(
#       <argument_of_"preject"_command>...)
#     rr_project_extra(
#       [TIME_AS_VERSION]
#       [AUTHORS <author>...]
#       [LICENSE <license>])
#
#   参见：
#
#   - :command:`rr_project`
#
function(rr_project_extra)
  set(zOptKws    TIME_AS_VERSION)
  set(zOneValKws LICENSE)
  set(zMutValKws AUTHORS)
  cmake_parse_arguments(PARSE_ARGV 0 "" "${zOptKws}" "${zOneValKws}" "${zMutValKws}")

  # 选项：TIME_AS_VERSION
  if(_TIME_AS_VERSION)
    string(LENGTH "${PROJECT_VERSION}" nLen)
    if(nLen EQUAL 0)
      string(TIMESTAMP vMajor "%Y")
      math(EXPR vMajor "${vMajor}")
      string(TIMESTAMP vMinor "%m")
      math(EXPR vMinor "${vMinor}")
      string(TIMESTAMP vPatch "%d")
      math(EXPR vPatch "${vPatch}")
      string(TIMESTAMP vTweak "%H%M")
      math(EXPR vTweak "${vTweak}")
      set(vVersion "${vMajor}.${vMinor}.${vPatch}.${vTweak}")
      set(PROJECT_VERSION_MAJOR "${vMajor}" PARENT_SCOPE)
      set(PROJECT_VERSION_MINOR "${vMinor}" PARENT_SCOPE)
      set(PROJECT_VERSION_PATCH "${vPatch}" PARENT_SCOPE)
      set(PROJECT_VERSION_TWEAK "${vTweak}" PARENT_SCOPE)
      set(PROJECT_VERSION "${vVersion}" PARENT_SCOPE)
      set("${PROJECT_NAME}_VERSION_MAJOR" "${vMajor}" PARENT_SCOPE)
      set("${PROJECT_NAME}_VERSION_MINOR" "${vMinor}" PARENT_SCOPE)
      set("${PROJECT_NAME}_VERSION_PATCH" "${vPatch}" PARENT_SCOPE)
      set("${PROJECT_NAME}_VERSION_TWEAK" "${vTweak}" PARENT_SCOPE)
      set("${PROJECT_NAME}_VERSION" "${vVersion}" PARENT_SCOPE)
      if(PROJECT_SOURCE_DIR STREQUAL CMAKE_SOURCE_DIR)
        set(CMAKE_PROJECT_VERSION_MAJOR "${vMajor}" PARENT_SCOPE)
        set(CMAKE_PROJECT_VERSION_MINOR "${vMinor}" PARENT_SCOPE)
        set(CMAKE_PROJECT_VERSION_PATCH "${vPatch}" PARENT_SCOPE)
        set(CMAKE_PROJECT_VERSION_TWEAK "${vTweak}" PARENT_SCOPE)
        set(CMAKE_PROJECT_VERSION "${vVersion}" PARENT_SCOPE)
      endif()
    else()
      message(AUTHOR_WARNING "PROJECT_VERSION isn't empty, ignore keyword TIME_AS_VERSION.")
    endif()
  endif()

  # 选项：AUTHORS
  if(DEFINED _AUTHORS)
    set(PROJECT_AUTHORS ${_AUTHORS} PARENT_SCOPE)
    set("${PROJECT_NAME}_AUTHORS" ${_AUTHORS} PARENT_SCOPE)
    if(PROJECT_SOURCE_DIR STREQUAL CMAKE_SOURCE_DIR)
      set(CMAKE_PROJECT_AUTHORS ${_AUTHORS} PARENT_SCOPE)
    endif()
  elseif(DEFINED PRODUCT_AUTHORS)
    set(PROJECT_AUTHORS ${PRODUCT_AUTHORS} PARENT_SCOPE)
    set("${PROJECT_NAME}_AUTHORS" ${PRODUCT_AUTHORS} PARENT_SCOPE)
  else()
    set(PROJECT_AUTHORS PARENT_SCOPE)
    set("${PROJECT_NAME}_AUTHORS" PARENT_SCOPE)
  endif()

  # 选项：LICENSE
  if(DEFINED _LICENSE)
    set(PROJECT_LICENSE "${_LICENSE}" PARENT_SCOPE)
    set("${PROJECT_NAME}_LICENSE" "${_LICENSE}" PARENT_SCOPE)
    if(PROJECT_SOURCE_DIR STREQUAL CMAKE_SOURCE_DIR)
      set(CMAKE_PROJECT_LICENSE "${_LICENSE}" PARENT_SCOPE)
    endif()
  elseif(DEFINED PRODUCT_LICENSE)
    set(PROJECT_LICENSE "${PRODUCT_LICENSE}" PARENT_SCOPE)
    set("${PROJECT_NAME}_LICENSE" "${PRODUCT_LICENSE}" PARENT_SCOPE)
  else()
    set(PROJECT_LICENSE PARENT_SCOPE)
    set("${PROJECT_NAME}_LICENSE" PARENT_SCOPE)
  endif()

  # 功能：PROJECT_NAME_LOWER
  string(TOLOWER "${PROJECT_NAME}" sLower)
  set(PROJECT_NAME_LOWER "${sLower}" PARENT_SCOPE)
  set("${PROJECT_NAME}_LOWER" "${sLower}" PARENT_SCOPE)
  if(PROJECT_SOURCE_DIR STREQUAL CMAKE_SOURCE_DIR)
    set(CMAKE_PROJECT_NAME_LOWER "${sLower}" PARENT_SCOPE)
  endif()

  # 功能：PROJECT_NAME_UPPER
  string(TOUPPER "${PROJECT_NAME}" sUpper)
  set(PROJECT_NAME_UPPER "${sUpper}" PARENT_SCOPE)
  set("${PROJECT_NAME}_UPPER" "${sUpper}" PARENT_SCOPE)
  if(PROJECT_SOURCE_DIR STREQUAL CMAKE_SOURCE_DIR)
    set(CMAKE_PROJECT_NAME_UPPER "${sUpper}" PARENT_SCOPE)
  endif()

  # 功能：PROJECT_VERSION_MAJOR 默认值
  if(NOT "${PROJECT_VERSION_MAJOR}" AND NOT _TIME_AS_VERSION)
    set(PROJECT_VERSION_MAJOR 0 PARENT_SCOPE)
    set("${PROJECT_NAME}_VERSION_MAJOR" 0 PARENT_SCOPE)
    if(PROJECT_SOURCE_DIR STREQUAL CMAKE_SOURCE_DIR)
      set(CMAKE_PROJECT_VERSION_MAJOR 0 PARENT_SCOPE)
    endif()
  endif()

  # 功能：PROJECT_VERSION_MINOR 默认值
  if(NOT "${PROJECT_VERSION_MINOR}" AND NOT _TIME_AS_VERSION)
    set(PROJECT_VERSION_MINOR 0 PARENT_SCOPE)
    set("${PROJECT_NAME}_VERSION_MINOR" 0 PARENT_SCOPE)
    if(PROJECT_SOURCE_DIR STREQUAL CMAKE_SOURCE_DIR)
      set(CMAKE_PROJECT_VERSION_MINOR 0 PARENT_SCOPE)
    endif()
  endif()

  # 功能：PROJECT_VERSION_PATCH 默认值
  if(NOT "${PROJECT_VERSION_PATCH}" AND NOT _TIME_AS_VERSION)
    set(PROJECT_VERSION_PATCH 0 PARENT_SCOPE)
    set("${PROJECT_NAME}_VERSION_PATCH" 0 PARENT_SCOPE)
    if(PROJECT_SOURCE_DIR STREQUAL CMAKE_SOURCE_DIR)
      set(CMAKE_PROJECT_VERSION_PATCH 0 PARENT_SCOPE)
    endif()
  endif()

  # 功能：PROJECT_VERSION_TWEAK 默认值
  if(NOT "${PROJECT_VERSION_TWEAK}" AND NOT _TIME_AS_VERSION)
    set(PROJECT_VERSION_TWEAK 0 PARENT_SCOPE)
    set("${PROJECT_NAME}_VERSION_TWEAK" 0 PARENT_SCOPE)
    if(PROJECT_SOURCE_DIR STREQUAL CMAKE_SOURCE_DIR)
      set(CMAKE_PROJECT_VERSION_TWEAK 0 PARENT_SCOPE)
    endif()
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
#   - `preject <https://cmake.org/cmake/help/latest/command/project.html>`_
#   - :command:`rr_project`
#   - :command:`rr_project_extra`
#
function(rr_project_debug_information)
  set(CMAKE_MESSAGE_LOG_LEVEL DEBUG)
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
  get_property(zLang GLOBAL PROPERTY ENABLED_LANGUAGES)
  message(DEBUG "ENABLED_LANGUAGES:                 '${zLang}'")
  message(DEBUG "--------------------------------------------------------------------------------")
endfunction()
