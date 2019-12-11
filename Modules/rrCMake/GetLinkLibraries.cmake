# zhengrr
# 2019-04-15 – 2019-11-20
# Unlicense

cmake_minimum_required(VERSION 3.10)
cmake_policy(VERSION 3.10)

include_guard()  # 3.10

if(NOT COMMAND check_name_with_cmake_rules)
  include("${CMAKE_CURRENT_LIST_DIR}/CheckNameWithCMakeRules.cmake")
endif()

#.rst:
# .. command:: get_link_libraries
#
#   获取链接库。
#
#   .. code-block:: cmake
#
#     get_link_libraries(
#       <variable> <target> [INCLUDE_ITSELF] [RECURSE]
#     )
#
#   参见：
#
#   - :command:`check_name_with_cmake_rules`
#
function(get_link_libraries _VARIABLE _TARGET)
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

  # <variable>
  set(xVariable "${_VARIABLE}")
  check_name_with_cmake_rules("${xVariable}" AUTHOR_WARNING)

  # <target>
  set(tTarget "${_TARGET}")
  if(NOT TARGET "${tTarget}")
    message(FATAL_ERROR "The name isn't a target: ${tTarget}.")
  endif()

  # [INCLUDE_ITSELF]
  set(bIncludeItself "${_INCLUDE_ITSELF}")

  # [RECURSE]
  set(bRecurse "${_RECURSE}")

  #
  # 查找链接库
  #

  # 查找直接链接库
  get_target_property(sType "${tTarget}" TYPE)
  if(sType STREQUAL INTERFACE_LIBRARY)
    get_target_property(zItems "${tTarget}" INTERFACE_LINK_LIBRARIES)
  else()
    get_target_property(zTemps1 "${tTarget}" INTERFACE_LINK_LIBRARIES)
    get_target_property(zTemps2 "${tTarget}" LINK_LIBRARIES)
    set(zItems ${zTemps1} ${zTemps2})
  endif()

  if(bIncludeItself)
    list(APPEND zItems "${tTarget}")
  endif()

  list(REMOVE_DUPLICATES zItems)

  # 查找间接链接库
  if(bRecurse)
    set(zTodos ${zItems})
    set(zDones)

    list(LENGTH zTodos nLen)
    while(NOT nLen EQUAL 0)

      foreach(sTodo IN LISTS zTodos)
        if(TARGET "${sTodo}")
          get_target_property(sType "${sTodo}" TYPE)
          if(sType STREQUAL INTERFACE_LIBRARY)
            get_target_property(zTemps "${sTodo}" INTERFACE_LINK_LIBRARIES)
            list(APPEND zTodos ${zTemps})
          else()
            get_target_property(zTemps1 "${sTodo}" INTERFACE_LINK_LIBRARIES)
            get_target_property(zTemps2 "${sTodo}" LINK_LIBRARIES)
            list(APPEND zTodos ${zTemps1} ${zTemps2})
          endif()
        endif()
        list(APPEND zDones "${sTodo}")
      endforeach()

      list(REMOVE_DUPLICATES zTodos)
      list(REMOVE_ITEM zTodos ${zDones})

      list(LENGTH zTodos nLen)
    endwhile()

    set(zItems ${zDones})
  endif()

  # 返回结果
  set("${xVariable}" ${zItems} PARENT_SCOPE)

endfunction()