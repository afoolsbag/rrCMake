# zhengrr
# 2016-10-08 – 2019-11-18
# Unlicense

cmake_minimum_required(VERSION 3.10)
cmake_policy(VERSION 3.10)

include_guard()  # 3.10

#===============================================================================
#.rst:
# .. command:: add_doxygen
#
#   添加 Doxygen 目标到项目。
#
#   .. code-block:: cmake
#
#     add_doxygen(                                                       default
#       <argument-of-doxygen-add-docs>...
#       [FULL_PATH_NAMES       <YES|NO>]                                     YES
#       [STRIP_FROM_PATH       path]
#       [JAVADOC_AUTOBRIEF     <YES|NO>]                                      NO
#       [OPTIMIZE_OUTPUT_FOR_C <YES|NO>]                                      NO
#       [EXTRACT_ALL           <YES|NO>]                                      NO
#       [HTML_OUTPUT           directory]                                   html
#       [USE_MATHJAX           <YES|NO>]                                      NO
#       [DOT_PATH              path]
#       [UML_LOOK              <YES|NO>]                                      NO
#       [PLANTUML_JAR_PATH     path]
#     )
#
#   参见：
#
#   - `FindDoxygen <https://cmake.org/cmake/help/latest/module/FindDoxygen.html>`_
#   - `Configuration <http://doxygen.org/manual/config.html>`_
function(add_doxygen)
  set(zDoxOneValKws)
  set(zDoxMutValKws)
  list(APPEND zDoxOneValKws FULL_PATH_NAMES
                            STRIP_FROM_PATH
                            JAVADOC_AUTOBRIEF
                            OPTIMIZE_OUTPUT_FOR_C
                            EXTRACT_ALL
                            HTML_OUTPUT
                            USE_MATHJAX
                            DOT_PATH
                            UML_LOOK
                            PLANTUML_JAR_PATH)
  set(zOptKws)
  set(zOneValKws ${zDoxOneValKws})
  set(zMutValKws ${zDoxMutValKws})
  cmake_parse_arguments(PARSE_ARGV 0 "" "${zOptKws}" "${zOneValKws}" "${zMutValKws}")

  #-----------------------------------------------------------------------------
  # 规整化参数

  set(zArgumentsOfDoxygenAddDocs ${_UNPARSED_ARGUMENTS})

  #-----------------------------------------------------------------------------
  # 查找依赖、配置参数并添加目标

  find_package(Doxygen)
  if(NOT DOXYGEN_FOUND)
    message(FATAL_ERROR "Doxygen is needed to generate doxygen documentation.")
  endif()

  foreach(sDoxConfName IN LISTS zDoxOneValKws zDoxMutValKws)
    if(DEFINED _${sDoxConfName})
      set(DOXYGEN_${sDoxConfName} ${_${sDoxConfName}})
    endif()
  endforeach()

  doxygen_add_docs(${zArgumentsOfDoxygenAddDocs})

endfunction()
