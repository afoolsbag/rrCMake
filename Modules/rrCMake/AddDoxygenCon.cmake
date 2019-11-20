# zhengrr
# 2016-10-08 – 2019-11-20
# Unlicense

cmake_minimum_required(VERSION 3.10)
cmake_policy(VERSION 3.10)

include_guard()  # 3.10

if(NOT COMMAND add_doxygen)
  include("${CMAKE_CURRENT_LIST_DIR}/AddDoxygen.cmake")
endif()
if(NOT COMMAND check_name_with_cmake_rules)
  include("${CMAKE_CURRENT_LIST_DIR}/CheckNameWithCMakeRules.cmake")
endif()

#.rst:
# .. command:: add_doxygen_con
#
#   添加 Doxygen 目标到项目，遵循惯例（convention）。
#
#   .. code-block:: cmake
#
#     add_doxygen_con(
#       <name> <argument-of-add_doxygen>...
#     )
#
#   参见：
#
#   - :command:`add_doxygen`
#   - :command:`check_name_with_cmake_rules`
#   - `option <https://cmake.org/cmake/help/latest/command/option.html>`_
#   - `install <https://cmake.org/cmake/help/latest/command/install.html>`_
#
function(add_doxygen_con _NAME)
  set(zDoxOneValKws DOT_PATH
                    EXTRACT_ALL
                    HTML_OUTPUT
                    PLANTUML_JAR_PATH
                    STRIP_FROM_PATH
                    USE_MATHJAX)
  set(zDoxMutValKws)
  set(zOptKws       ALL
                    EXCLUDE_FROM_ALL)
  set(zOneValKws    WORKING_DIRECTORY
                    COMMENT
                    ${zDoxOneValKws})
  set(zMutValKws    ${zDoxMutValKws})
  cmake_parse_arguments(PARSE_ARGV 1 "" "${zOptKws}" "${zOneValKws}" "${zMutValKws}")

  #
  # 参数规整
  #

  # <name>
  set(sName "${_NAME}")
  check_name_with_cmake_rules("${sName}" AUTHOR_WARNING)
  string(TOUPPER "${sName}" sNameUpper)

  # <argument-of-add_doxygen>...
  set(zArgumentsOfAddDoxygen ${_UNPARSED_ARGUMENTS})

  # doxygen_add_docs 参数惯例值

  if(_EXCLUDE_FROM_ALL)
    set(oAll)
  else()
    set(oAll ALL)
  endif()

  if(DEFINED _WORKING_DIRECTORY)
    set(pWorkingDirectory "${_WORKING_DIRECTORY}")
  else()
    set(pWorkingDirectory "${PROJECT_BINARY_DIR}")
  endif()

  if(DEFINED _COMMENT)
    set(sComment          "${_COMMENT}")
  else()
    set(sComment          "Generating documentation with Doxygen.")
  endif()

  # doxygen_add_docs 配置惯例值

  if(DEFINED _STRIP_FROM_PATH)
    set(sStripFromPath    "${_STRIP_FROM_PATH}")
  else()
    set(sStripFromPath    "${PROJECT_SOURCE_DIR}")
  endif()

  if(DEFINED _EXTRACT_ALL)
    set(sExtractAll       "${_EXTRACT_ALL}")
  else()
    set(sExtractAll       "YES")
  endif()

  if(DEFINED _HTML_OUTPUT)
    set(sHtmlOutput       "${_HTML_OUTPUT}")
  else()
    set(sHtmlOutput       "doxygen")
  endif()

  if(DEFINED _USE_MATHJAX)
    set(sUseMathjax       "${_USE_MATHJAX}")
  else()
    set(sUseMathjax       "YES")
  endif()

  if(DEFINED _DOT_PATH)
    set(sDotPath          "${_DOT_PATH}")
  else()
    set(sDotPath          "$ENV{GRAPHVIZ_DOT}")
  endif()

  if(DEFINED _PLANTUML_JAR_PATH)
    set(sPlantumlJarPath  "${_PLANTUML_JAR_PATH}")
  else()
    set(sPlantumlJarPath  "$ENV{PLANTUML}")
  endif()

  #
  # 启停选项
  #

  string(TOUPPER "${PROJECT_NAME}" sProjectNameUpper)
  string(REGEX REPLACE "^${sProjectNameUpper}_?" "" sTrimmedNameUpper "${sNameUpper}")
  string(LENGTH "${sTrimmedNameUpper}" nLen)
  if(0 LESS nLen)
    set(xOptVar ${sProjectNameUpper}_${sTrimmedNameUpper}_DOCUMENTATION)
  else()
    set(xOptVar ${sProjectNameUpper}_DOCUMENTATION)
  endif()

  option(${xOptVar} "Build ${sName} documentation." ${DOXYGEN_FOUND})
  if(NOT ${xOptVar})
    return()
  endif()

  #
  # 业务逻辑
  #

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
