# zhengrr
# 2016-10-08 – 2019-11-18
# Unlicense

cmake_minimum_required(VERSION 3.10)
cmake_policy(VERSION 3.10)

include_guard()  # 3.10

if(NOT COMMAND add_doxygen)
  include("${CMAKE_CURRENT_LIST_DIR}/AddDoxygen.cmake")
endif()

#===============================================================================
#.rst:
# .. command:: add_doxygen_con
#
#   添加 Doxygen 目标到项目，遵循惯例（convention）。
#
#   .. code-block:: cmake
#
#     add_doxygen_con(
#       <name> <argument-of-add-doxygen>...
#     )
#
#   参见：
#
#   - `option <https://cmake.org/cmake/help/latest/command/option.html>`_
#   - :command:`add_doxygen`
#   - `install <https://cmake.org/cmake/help/latest/command/install.html>`_
function(add_doxygen_con _NAME)
  set(zDoxOneValKws)
  set(zDoxMutValKws)
  list(APPEND zDoxOneValKws STRIP_FROM_PATH
                            EXTRACT_ALL
                            HTML_OUTPUT
                            USE_MATHJAX
                            DOT_PATH
                            PLANTUML_JAR_PATH)
  set(zOptKws    ALL
                 EXCLUDE_FROM_ALL)
  set(zOneValKws WORKING_DIRECTORY
                 COMMENT
                 ${zDoxOneValKws})
  set(zMutValKws ${zDoxMutValKws})
  cmake_parse_arguments(PARSE_ARGV 1 "" "${zOptKws}" "${zOneValKws}" "${zMutValKws}")

  #-----------------------------------------------------------------------------
  # 规整化参数

  set(sName                  "${_NAME}")
  set(bAll                   "${_ALL}")
  set(bExcludeFromAll        "${_EXCLUDE_FROM_ALL}")

  if(DEFINED _WORKING_DIRECTORY)
    set(pWorkingDirectory    "${_WORKING_DIRECTORY}")
  else()
    set(pWorkingDirectory    "${PROJECT_BINARY_DIR}")
  endif()

  if(DEFINED _COMMENT)
    set(sComment             "${_COMMENT}")
  else()
    set(sComment             "Generating documentation with Doxygen.")
  endif()

  # 以下参数原样传递给 Doxygen，因而全部视为简单字符串

  if(DEFINED _STRIP_FROM_PATH)
    set(sStripFromPath       "${_STRIP_FROM_PATH}")
  else()
    set(sStripFromPath       "${PROJECT_SOURCE_DIR}")
  endif()

  if(DEFINED _EXTRACT_ALL)
    set(sExtractAll          "${_EXTRACT_ALL}")
  else()
    set(sExtractAll          "YES")
  endif()

  if(DEFINED _HTML_OUTPUT)
    set(sHtmlOutput          "${_HTML_OUTPUT}")
  else()
    set(sHtmlOutput          "doxygen")
  endif()

  if(DEFINED _USE_MATHJAX)
    set(sUseMathjax          "${_USE_MATHJAX}")
  else()
    set(sUseMathjax          "YES")
  endif()

  if(DEFINED _DOT_PATH)
    set(sDotPath             "${_DOT_PATH}")
  else()
    set(sDotPath             "$ENV{GRAPHVIZ_DOT}")
  endif()

  if(DEFINED _PLANTUML_JAR_PATH)
    set(sPlantumlJarPath     "${_PLANTUML_JAR_PATH}")
  else()
    set(sPlantumlJarPath     "$ENV{PLANTUML}")
  endif()

  set(zArgumentsOfAddDoxygen ${_UNPARSED_ARGUMENTS})

  #-----------------------------------------------------------------------------
  # 启停选项

  string(TOUPPER "${sName}" sNameUpper)
  string(TOUPPER "${PROJECT_NAME}" sProjectNameUpper)
  string(REGEX REPLACE "^${sProjectNameUpper}_?" "" sTrimmedNameUpper "${sNameUpper}")
  string(LENGTH "${sTrimmedNameUpper}" sLen)
  if(0 LESS sLen)
    set(xOptVar ${sProjectNameUpper}_${sTrimmedNameUpper}_DOCUMENTATION)
  else()
    set(xOptVar ${sProjectNameUpper}_DOCUMENTATION)
  endif()

  option(${xOptVar} "Build ${sName} documentation." ${DOXYGEN_FOUND})
  if(NOT ${xOptVar})
    return()
  endif()

  #-----------------------------------------------------------------------------
  # 引入并配置目标

  if(bExcludeFromAll)  # 只取决于 EXCLUDE_FROM_ALL 参数，忽略 ALL 参数
    set(oAll)
  else()
    set(oAll ALL)
  endif()

  add_doxygen(
    "${sName}"        "${PROJECT_SOURCE_DIR}"
                      ${zArgumentsOfAddDoxygen}
                      ${oAll}
    WORKING_DIRECTORY "${pWorkingDirectory}"
    COMMENT           "${sComment}"
    STRIP_FROM_PATH   "${sStripFromPath}"
    EXTRACT_ALL       "${sExtractAll}"
    HTML_OUTPUT       "${sHtmlOutput}"
    USE_MATHJAX       "${sUseMathjax}"
    DOT_PATH          "${sDotPath}"
    PLANTUML_JAR_PATH "${sPlantumlJarPath}")

  install(
    DIRECTORY   "${PROJECT_BINARY_DIR}/${sHtmlOutput}/"
    DESTINATION "doc/${sName}")

endfunction()
