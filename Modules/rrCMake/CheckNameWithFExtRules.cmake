# zhengrr
# 2017-12-18 – 2019-11-19
# Unlicense

cmake_minimum_required(VERSION 3.10)
cmake_policy(VERSION 3.10)

include_guard()  # 3.10

#.rst:
# .. command:: check_name_with_fext_rules
#
#   检查输入是否符合（一般的）文件扩展名命名规则：
#   首字符为下脚点，扩展名仅包含拉丁字母和阿拉伯数字，可以串接。
#
#   另，临时文件偏好选用稀奇古怪的字符组成其后缀，如 ``!``、``#``、``$``、``&``、``@``、``_``、``~`` 等，此处没有考虑。
#
#   .. code-block:: cmake
#
#     check_name_with_fext_rules(
#       <name>
#       <STATUS|WARNING|AUTHOR_WARNING|SEND_ERROR|FATAL_ERROR|DEPRECATION>
#     )
#
#   参见：
#
#   - `<https://wikipedia.org/wiki/Filename>`_
#   - `<https://wikipedia.org/wiki/List_of_filename_extensions>`_
function(check_name_with_fext_rules sName oMode)
  if(NOT ${ARGC} EQUAL 2)
    message(FATAL_ERROR "Incorrect number of arguments: ${ARGN}.")
  endif()
  if(NOT "${sName}" MATCHES [[^(\.[0-9A-Za-z]+)+$]])
    message(${oMode} "The name isn't meet file extension rules: ${sName}.")
  endif()
endfunction()
