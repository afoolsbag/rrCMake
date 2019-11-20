# zhengrr
# 2017-12-18 – 2019-11-20
# Unlicense

cmake_minimum_required(VERSION 3.10)
cmake_policy(VERSION 3.10)

include_guard()  # 3.10

if(NOT COMMAND check_name_with_cmake_rules)
  include("${CMAKE_CURRENT_LIST_DIR}/CheckNameWithCMakeRules.cmake")
endif()

#.rst:
# .. command:: add_subdirectory_con
#
#   添加子目录到构建（add subdirectory），遵循惯例（convention）。
#
#   .. code-block:: cmake
#
#     add_subdirectory_con(
#       <source-directory> <argument-of-add_subdirectory>...
#       [WITHOUT_OPTION]
#       [OPTION_PREFIX  <option-prefix>]
#       [OPTION_INITIAL <option-initial>]
#     )
#
#   参见：
#
#   - `add_subdirectory <https://cmake.org/cmake/help/latest/command/add_subdirectory.html>`_
#
function(add_subdirectory_con _SOURCE_DIRECTORY)
  set(zOptKws    WITHOUT_OPTION)
  set(zOneValKws OPTION_INITIAL
                 OPTION_PREFIX)
  set(zMutValKws)
  cmake_parse_arguments(PARSE_ARGV 1 "" "${zOptKws}" "${zOneValKws}" "${zMutValKws}")

  #
  # 参数规整
  #

  # <source-directory>
  set(pSourceDirectory "${_SOURCE_DIRECTORY}")
  get_filename_component(sSourceDirectoryName NAME)
  string(TOUPPER "${sSourceDirectoryName}" sSourceDirectoryNameUpper)

  # <argument-of-add_subdirectory>...
  set(zArgumentsOfAddSubdirectory ${_UNPARSED_ARGUMENTS})

  # [WITHOUT_OPTION]
  set(bWithoutOption ${_WITHOUT_OPTION})

  # [OPTION_PREFIX <option-prefix>]
  if(DEFINED _OPTION_PREFIX)
    set(sOptionPrefix "${_OPTION_PREFIX}")
    if(NOT sOptionPrefix MATCHES "_$")
      string(APPEND sOptionPrefix "_")
    endif()
  else()
    set(sOptionPrefix)
  endif()

  # [OPTION_INITIAL <option-initial>]
  unset(oOptionInitial)
  if(DEFINED _OPTION_INITIAL)
    if(_OPTION_INITIAL)
      set(oOptionInitial ON)
    else()
      set(oOptionInitial OFF)
    endif()
  endif()

  #
  # 启停选项
  #

  if(NOT bWithoutOption)

    set(xOptName "${sOptionPrefix}${sSourceDirectoryNameUpper}")
    check_name_with_cmake_rules("${xOptName}" AUTHOR_WARNING)

    option(${xOptName} "Sub-directory ${pSourceDirectory}." ${oOptionInitial})
    if(NOT ${xOptName})
      return()
    endif()

  endif()

  #
  # 业务逻辑
  #

  add_subdirectory("${pSourceDirectory}" ${zArgumentsOfAddSubdirectory})

endfunction()
