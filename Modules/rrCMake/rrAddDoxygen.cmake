# zhengrr
# 2016-10-08 – 2021-04-07
# Unlicense

cmake_minimum_required(VERSION 3.10)
cmake_policy(VERSION 3.10)

include_guard()  # 3.10

if(NOT COMMAND rr_check_cmake_name)
  include("${CMAKE_CURRENT_LIST_DIR}/rrCheck.cmake")
endif()


#[=======================================================================[.rst:
.. command:: rr_add_doxygen

  添加 Doxygen 文档构建目标。

  基于 ``doxygen_add_docs`` 命令，将“通过变量配置”包装为“通过参数配置”。

  .. code-block:: cmake

    rr_add_doxygen(                                                    default
      <argument-of-"doxygen_add_docs"-command>...
      [FULL_PATH_NAMES       {YES|NO}]                                     YES
      [STRIP_FROM_PATH       <path>]
      [JAVADOC_AUTOBRIEF     {YES|NO}]                                      NO
      [OPTIMIZE_OUTPUT_FOR_C {YES|NO}]                                      NO
      [EXTRACT_ALL           {YES|NO}]                                      NO
      [HTML_OUTPUT           <directory>]                                 html
      [USE_MATHJAX           {YES|NO}]                                      NO
      [DOT_PATH              <path>]
      [UML_LOOK              {YES|NO}]                                      NO
      [PLANTUML_JAR_PATH     <path>])

  参见：

  - `FindDoxygen <https://cmake.org/cmake/help/latest/module/FindDoxygen.html>`_
  - `Configuration <http://doxygen.org/manual/config.html>`_
#]=======================================================================]
function(rr_add_doxygen)
  set(zDoxOneValKws DOT_PATH
                    EXTRACT_ALL
                    FULL_PATH_NAMES
                    HTML_OUTPUT
                    JAVADOC_AUTOBRIEF
                    OPTIMIZE_OUTPUT_FOR_C
                    PLANTUML_JAR_PATH
                    STRIP_FROM_PATH
                    UML_LOOK
                    USE_MATHJAX)
  set(zDoxMutValKws)
  set(zOptKws)
  set(zOneValKws ${zDoxOneValKws})
  set(zMutValKws ${zDoxMutValKws})
  cmake_parse_arguments(PARSE_ARGV 0 "" "${zOptKws}" "${zOneValKws}" "${zMutValKws}")

  # FindDoxygen
  find_package(Doxygen)
  if(NOT DOXYGEN_FOUND)
    message(FATAL_ERROR "Doxygen is needed to generate doxygen documentation.")
  endif()

  # <DoxValKwd> -> DOXYGEN_<DoxValKwd>
  foreach(sDoxConfName IN LISTS zDoxOneValKws zDoxMutValKws)
    if(DEFINED "_${sDoxConfName}")
      set("DOXYGEN_${sDoxConfName}" ${_${sDoxConfName}})
    endif()
  endforeach()

  # FindDoxygen § doxygen_add_docs
  doxygen_add_docs(${_UNPARSED_ARGUMENTS})
endfunction()


#[=======================================================================[.rst:
.. command:: rr_add_doxygen_with_convention

  类似 ``rr_add_doxygen`` 命令，并依据惯例进行更多配置：

  - 

  参见：

  - :command:`rr_add_doxygen`
  - `option <https://cmake.org/cmake/help/latest/command/option.html>`_
  - `install <https://cmake.org/cmake/help/latest/command/install.html>`_
#]=======================================================================]
function(rr_add_doxygen_with_convention _NAME)
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
  rr_check_cmake_name("${sName}" AUTHOR_WARNING)
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

  rr_add_doxygen(
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
