# zhengrr
# 2017-12-18 – 2019-11-20
# Unlicense

cmake_minimum_required(VERSION 3.10)
cmake_policy(VERSION 3.10)

include_guard()  # 3.10

if(NOT COMMAND add_subdirectory_con)
  include("${CMAKE_CURRENT_LIST_DIR}/AddSubdirectoryCon.cmake")
endif()

#.rst:
# .. command:: add_subdirectory_aux
#
#   添加子目录到构建（add subdirectory），帮助搜集当前目录的子目录（auxiliary）。
#
#   .. code-block:: cmake
#
#     add_subdirectory_aux(
#       <argument-of-add_subdirectory_con>...
#     )
#
#   参见：
#
#   - :command:`add_subdirectory_con`
#
macro(add_subdirectory_aux)
  file(
    GLOB     _add_subdirectory_aux_SubDirs
    RELATIVE "${CMAKE_CURRENT_LIST_DIR}"
             "${CMAKE_CURRENT_LIST_DIR}/*")
  foreach(_add_subdirectory_aux_SubDir IN LISTS _add_subdirectory_aux_SubDirs)
    if(NOT IS_DIRECTORY "${CMAKE_CURRENT_LIST_DIR}/${_add_subdirectory_aux_SubDir}")
      continue()
    endif()
    if(NOT EXISTS "${CMAKE_CURRENT_LIST_DIR}/${_add_subdirectory_aux_SubDir}/CMakeLists.txt")
      continue()
    endif()
    add_subdirectory_con("${_add_subdirectory_aux_SubDir}" ${ARGV})
  endforeach()
endmacro()
