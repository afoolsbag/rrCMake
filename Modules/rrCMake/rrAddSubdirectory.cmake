# zhengrr
# 2017-12-18 – 2021-03-11
# Unlicense

cmake_minimum_required(VERSION 3.10)
cmake_policy(VERSION 3.10)

include_guard()  # 3.10

if(NOT COMMAND rr_check_cmake_name)
  include("${CMAKE_CURRENT_LIST_DIR}/rrCheck.cmake")
endif()

#[=======================================================================[.rst:
.. command:: rr_add_subdirectory

  基于 ``add_subdirectory`` 命令，提供更多选项和功能。

  .. code-block:: cmake

    rr_add_subdirectory(
      <source-directory> <argument-of-"add_subdirectory"-command>...
      [WITH_OPTION]
      [OPTION_PREFIX  <option-prefix>]
      [OPTION_INITIAL <option-initial>])

  参见：

  - `add_subdirectory <https://cmake.org/cmake/help/latest/command/add_subdirectory.html>`_

#]=======================================================================]
function(rr_add_subdirectory pSourceDirectory)
  set(zOptKws    WITH_OPTION)
  set(zOneValKws OPTION_INITIAL
                 OPTION_PREFIX)
  set(zMutValKws)
  cmake_parse_arguments(PARSE_ARGV 1 "" "${zOptKws}" "${zOneValKws}" "${zMutValKws}")

  # <source-directory>
  # -> pSourceDirectory
  # -> sSourceDirectoryName
  # -> sSourceDirectoryNameUpper
  get_filename_component(sSourceDirectoryName "${pSourceDirectory}" NAME)
  string(TOUPPER "${sSourceDirectoryName}" sSourceDirectoryNameUpper)

  # OPTION_PREFIX <option-prefix>
  # -> sOptionPrefix
  if(DEFINED _OPTION_PREFIX)
    set(sOptionPrefix "${_OPTION_PREFIX}")
    if(NOT sOptionPrefix MATCHES "_$")
      string(APPEND sOptionPrefix "_")
    endif()
  else()
    set(sOptionPrefix)
  endif()

  # OPTION_INITIAL <option-initial>
  # -> oOptionInitial
  unset(oOptionInitial)
  if(DEFINED _OPTION_INITIAL AND _OPTION_INITIAL)
    set(oOptionInitial ON)
  else()
    set(oOptionInitial OFF)
  endif()

  if(_WITH_OPTION)
    set(xOptName "${sOptionPrefix}${sSourceDirectoryNameUpper}")
    rr_check_cmake_name("${xOptName}" AUTHOR_WARNING)

    option(${xOptName} "Sub-directory ${pSourceDirectory}." ${oOptionInitial})
    if(NOT ${xOptName})
      return()
    endif()
  endif()

  add_subdirectory("${pSourceDirectory}" ${_UNPARSED_ARGUMENTS})
endfunction()

#[=======================================================================[.rst:
.. command:: rr_aux_subdirectories

  遍历当前目录的子目录，挑选出可纳入构建的，执行 ``rr_add_subdirectory`` 命令。

  .. code-block:: cmake

    rr_aux_subdirectories(<argument-of-"rr_add_subdirectory"-command>...)

  参见：

  - :command:`rr_add_subdirectory`

#]=======================================================================]
macro(rr_aux_subdirectories)
  file(
    GLOB     _rr_aux_subdirectories_zSubDirs
    RELATIVE "${CMAKE_CURRENT_LIST_DIR}"
             "${CMAKE_CURRENT_LIST_DIR}/*")
  foreach(_rr_aux_subdirectories_pSubDir IN LISTS _rr_aux_subdirectories_zSubDirs)
    if(NOT IS_DIRECTORY "${CMAKE_CURRENT_LIST_DIR}/${_rr_aux_subdirectories_pSubDir}")
      continue()
    endif()
    if(NOT EXISTS "${CMAKE_CURRENT_LIST_DIR}/${_rr_aux_subdirectories_pSubDir}/CMakeLists.txt")
      continue()
    endif()
    rr_add_subdirectory("${_rr_aux_subdirectories_pSubDir}" ${ARGV})
  endforeach()
endmacro()
