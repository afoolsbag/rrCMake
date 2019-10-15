# zhengrr
# 2017-12-18 – 2019-10-15
# Unlicense

cmake_minimum_required(VERSION 3.10)
cmake_policy(VERSION 3.10)

include_guard()  # 3.10

if(NOT COMMAND check_name_with_cmake_rules)
  include("${CMAKE_CURRENT_LIST_DIR}/CheckName.cmake")
endif()

#===============================================================================
#.rst:
# .. command:: add_subdirectory_con
#
#   添加子目录到构建（add subdirectory），遵循惯例（convention）。
#
#   .. code-block:: cmake
#
#     add_subdirectory_con(
#       <argument-of-add-subdirectory>...
#       [WITHOUT_OPTION]
#       [OPTION_PREFIX  <option-prefix>]
#       [OPTION_INITIAL <option-initial>]
#     )
#
#   参见：
#
#   - `add_subdirectory <https://cmake.org/cmake/help/latest/command/add_subdirectory.html>`_
function(add_subdirectory_con _SOURCE_DIRECTORY)
  set(zOptKws    WITHOUT_OPTION)
  set(zOneValKws OPTION_PREFIX
                 OPTION_INITIAL)
  set(zMutValKws)
  cmake_parse_arguments(PARSE_ARGV 1 "" "${zOptKws}" "${zOneValKws}" "${zMutValKws}")

  #-----------------------------------------------------------------------------
  # 规整化参数

  # SOURCE_DIRECTORY
  set(pSourceDirectory "${_SOURCE_DIRECTORY}")

  string(TOUPPER "${pSourceDirectory}" sSourceDirectoryUpper)

  # ARGUMENTS_OF_ADD_SUBDIRECTORY
  set(zArgumentsOfAddSubdirectory ${_UNPARSED_ARGUMENTS})

  # WITHOUT_OPTION
  set(bWithoutOption ${_WITHOUT_OPTION})

  # OPTION_PREFIX
  unset(sOptionPrefix)
  if(DEFINED _OPTION_PREFIX)
    if(_OPTION_PREFIX MATCHES "_$")
      set(sOptionPrefix "${_OPTION_PREFIX}")
    else()
      set(sOptionPrefix "${_OPTION_PREFIX}_")
    endif()
  endif()

  # OPTION_INITIAL
  set(bOptionInitial)
  if(DEFINED _OPTION_INITIAL)
    if(_OPTION_INITIAL)
      set(bOptionInitial ON)
    else()
      set(bOptionInitial OFF)
    endif()
  endif()

  #-----------------------------------------------------------------------------
  # 启停配置

  if(NOT bWithoutOption)

    set(vOptName "${sOptionPrefix}${sSourceDirectoryUpper}")
    check_name_with_cmake_rules("${vOptName}" WARNING)

    option(${vOptName} "Sub-directory ${pSourceDirectory}." ${bOptionInitial})
    if(NOT ${vOptName})
      return()
    endif()

  endif()

  #-----------------------------------------------------------------------------
  # 添加子目录

  add_subdirectory("${pSourceDirectory}" ${zArgumentsOfAddSubdirectory})
endfunction()

#===============================================================================
# .rst
# .. command:: add_aux_subdirectories_con
#
#   搜集当前目录的子目录并加入构建（add auxiliary subdirectories），遵循惯例（convention）。
#
#   .. code-block:: cmake
#
#     add_aux_subdirectories_con(
#       <argument-of-add-subdirectory-con>...
#     )
function(add_aux_subdirectories_con)
  file(
    GLOB     zSubDirs
    RELATIVE "${CMAKE_CURRENT_LIST_DIR}"
             "${CMAKE_CURRENT_LIST_DIR}/*")

  foreach(pSubDir IN LISTS zSubDirs)
    if(NOT IS_DIRECTORY "${CMAKE_CURRENT_LIST_DIR}/${pSubDir}")
      continue()
    endif()
    if(NOT EXISTS "${CMAKE_CURRENT_LIST_DIR}/${pSubDir}/CMakeLists.txt")
      continue()
    endif()
    add_subdirectory_con("${pSubDir}" ${ARGV})
  endforeach()
endfunction()
