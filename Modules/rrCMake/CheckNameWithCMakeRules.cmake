# zhengrr
# 2017-12-18 – 2019-11-19
# Unlicense

cmake_minimum_required(VERSION 3.10)
cmake_policy(VERSION 3.10)

include_guard()  # 3.10

#.rst:
# .. command:: check_name_with_cmake_rules
#
#   检查输入是否符合 CMake 推荐变量命名规则：
#   仅包含拉丁字母、阿拉伯数字、下划线和连字符。
#
#   .. code-block:: cmake
#
#     check_name_with_cmake_rules(
#       <name>
#       <STATUS|WARNING|AUTHOR_WARNING|SEND_ERROR|FATAL_ERROR|DEPRECATION>
#     )
#
#   参见：
#
#   - `<https://cmake.org/cmake/help/latest/manual/cmake-language.7.html#variables>`_
function(check_name_with_cmake_rules sName oMode)
  if(NOT ${ARGC} EQUAL 2)
    message(FATAL_ERROR "Incorrect number of arguments: ${ARGN}.")
  endif()
  if(NOT "${sName}" MATCHES "^[-0-9A-Z_a-z]+$")
    message(${oMode} "The name isn't meet CMake recommend variable rules: ${sName}.")
  endif()
endfunction()
