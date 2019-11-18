# zhengrr
# 2019-04-15 – 2019-11-18
# Unlicense

cmake_minimum_required(VERSION 3.10)
cmake_policy(VERSION 3.10)

include_guard()  # 3.10

if(NOT COMMAND get_link_libraries)
  include("${CMAKE_CURRENT_LIST_DIR}/GetLinkLibraries.cmake")
endif()

#===============================================================================
#.rst:
# .. command:: get_link_library_files
#
#   获取链接文件。
#
#   .. code-block:: cmake
#
#     get_link_library_files(
#       <variable> <target> [INCLUDE_ITSELF] [RECURSE]
#     )
function(get_link_library_files _VARIABLE _TARGET)
  set(zOptKws    INCLUDE_ITSELF
                 RECURSE)
  set(zOneValKws)
  set(zMutValKws)
  cmake_parse_arguments(PARSE_ARGV 2 "" "${zOptKws}" "${zOneValKws}" "${zMutValKws}")

  #-----------------------------------------------------------------------------
  # 规整化参数

  set(xVariable      "${_VARIABLE}")
  set(tTarget        "${_TARGET}")
  set(bIncludeItself "${_INCLUDE_ITSELF}")
  set(bRecurse       "${_RECURSE}")

  if(DEFINED _UNPARSED_ARGUMENTS)
    message(FATAL_ERROR "Unexpected arguments: ${_UNPARSED_ARGUMENTS}.")
  endif()

  if(NOT TARGET "${tTarget}")
    message(FATAL_ERROR "The name isn't a target: ${tTarget}.")
  endif()

  #-----------------------------------------------------------------------------
  # 查找链接文件

  # 查找链接库
  if(bIncludeItself)
    set(oIncludeItself INCLUDE_ITSELF)
  else()
    set(oIncludeItself)
  endif()

  if(bRecurse)
    set(oRecurse RECURSE)
  else()
    set(oRecurse)
  endif()

  get_link_libraries(zLibs "${tTarget}" ${oIncludeItself} ${oRecurse})

  # 查找链接库对应的文件
  set(zFiles)

  foreach(sLib IN LISTS zLibs)
    if(TARGET "${sLib}")
      get_target_property(sType "${sLib}" TYPE)
      if(sType STREQUAL SHARED_LIBRARY)
        list(APPEND zFiles "$<TARGET_FILE:${sLib}>")
      endif()
    elseif(EXISTS "${sLib}")
      list(APPEND zFiles "${sLib}")
    endif()
  endforeach()

  list(REMOVE_DUPLICATES zFiles)

  # 返回结果
  set("${xVariable}" ${zFiles} PARENT_SCOPE)

endfunction()
