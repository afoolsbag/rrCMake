# zhengrr
# 2018-06-06 – 2019-11-19
# Unlicense

cmake_minimum_required(VERSION 3.10)
cmake_policy(VERSION 3.10)

include_guard()  # 3.10

if(NOT COMMAND check_name_with_cmake_rules)
  include("${CMAKE_CURRENT_LIST_DIR}/CheckNameWithCMakeRules.cmake")
endif()

#===============================================================================
#.rst:
# .. command::get_address_model_tag
#
#   获取地址模型标签（get address model tag）。
#
#   .. code-block:: cmake
#
#     get_address_model_tag(
#       <variable>
#     )
#
#   参见：
#
#   - :command:`check_name_with_cmake_rules`
#   - `<https://boost.org/doc/libs/master/more/getting_started/windows.html#library-naming>`_
#   - `<https://gitlab.kitware.com/cmake/cmake/blob/master/Modules/FindBoost.cmake>`_
function(get_address_model_tag xVariable)
  check_name_with_cmake_rules("${xVariable}" AUTHOR_WARNING)

  if(CMAKE_SIZEOF_VOID_P EQUAL 8)
    set("${xVariable}" "64" PARENT_SCOPE)
    return()
  endif()

  if(CMAKE_SIZEOF_VOID_P EQUAL 4)
    set("${xVariable}" "32" PARENT_SCOPE)
    return()
  endif()

  set("${xVariable}" "" PARENT_SCOPE)
endfunction()
