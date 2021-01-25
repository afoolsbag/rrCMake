# zhengrr
# 2019-04-15 – 2019-11-20
# Unlicense

cmake_minimum_required(VERSION 3.10)
cmake_policy(VERSION 3.10)

include_guard()  # 3.10

if(NOT COMMAND check_name_with_cmake_rules)
  include("${CMAKE_CURRENT_LIST_DIR}/CheckNameWithCMakeRules.cmake")
endif()
if(NOT COMMAND get_link_libraries)
  include("${CMAKE_CURRENT_LIST_DIR}/GetLinkLibraries.cmake")
endif()

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
#
#   参见：
#
#   - :command:`check_name_with_cmake_rules`
#   - :command:`get_link_libraries`
#
function(get_link_library_files _VARIABLE _TARGET)
  set(zOptKws    INCLUDE_ITSELF
                 RECURSE)
  set(zOneValKws)
  set(zMutValKws)
  cmake_parse_arguments(PARSE_ARGV 2 "" "${zOptKws}" "${zOneValKws}" "${zMutValKws}")

  #
  # 参数规整
  #

  if(DEFINED _UNPARSED_ARGUMENTS)
    message(FATAL_ERROR "Unexpected arguments: ${_UNPARSED_ARGUMENTS}.")
  endif()

  # VARIABLE
  set(xVariable "${_VARIABLE}")
  check_name_with_cmake_rules("${xVariable}" AUTHOR_WARNING)

  # TARGET
  set(tTarget "${_TARGET}")
  if(NOT TARGET "${tTarget}")
    message(FATAL_ERROR "The name isn't a target: ${tTarget}.")
  endif()

  # INCLUDE_ITSELF
  unset(oIncludeItself)
  if(_INCLUDE_ITSELF)
    set(oIncludeItself INCLUDE_ITSELF)
  endif()

  # RECURSE
  unset(oRecurse)
  if(_RECURSE)
    set(oRecurse RECURSE)
  endif()

  #
  # 查找链接文件
  #

  # 查找链接库
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
