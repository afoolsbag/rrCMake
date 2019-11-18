# zhengrr
# 2017-12-18 – 2019-11-18
# Unlicense

cmake_minimum_required(VERSION 3.10)
cmake_policy(VERSION 3.10)

include_guard()  # 3.10

if(NOT COMMAND add_subdirectory_con)
  include("${CMAKE_CURRENT_LIST_DIR}/AddSubdirectoryCon.cmake")
endif()

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
