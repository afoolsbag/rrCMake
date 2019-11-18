# zhengrr
# 2018-06-06 – 2019-11-18
# Unlicense

cmake_minimum_required(VERSION 3.10)
cmake_policy(VERSION 3.10)

include_guard()  # 3.10

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
#   - `<https://boost.org/doc/libs/master/more/getting_started/windows.html#library-naming>`_
#   - `<https://gitlab.kitware.com/cmake/cmake/blob/master/Modules/FindBoost.cmake>`_
function(get_address_model_tag vVariable)
  if(CMAKE_SIZEOF_VOID_P EQUAL 8)
    set(${vVariable} "64" PARENT_SCOPE)
    return()
  endif()

  if(CMAKE_SIZEOF_VOID_P EQUAL 4)
    set(${vVariable} "32" PARENT_SCOPE)
    return()
  endif()

  set(${vVariable} "" PARENT_SCOPE)
endfunction()
