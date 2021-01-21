# zhengrr
# 2017-12-18 – 2021-01-21
# Unlicense

cmake_minimum_required(VERSION 3.10)
cmake_policy(VERSION 3.10)

include_guard()  # 3.10

#[=======================================================================[.rst:
.. command:: rr_check_cmake_name

  检查输入是否符合 CMake 推荐变量命名规则：
  仅包含拉丁字母、阿拉伯数字、下划线和连字符；
  另引入双冒号（``::``）用于域分隔，尾部双加号（``++``）用于某些库的 C++ 版本。

  .. code-block:: cmake

    rr_check_cmake_name(<name> <mode>)

  参见：

  - `message <https://cmake.org/cmake/help/latest/command/message.html>`_
  - `cmake-language(7) § Variables <https://cmake.org/cmake/help/latest/manual/cmake-language.7.html#variables>`_

#]=======================================================================]
function(rr_check_cmake_name sName oMode)
  #
  # 前置断言
  #

  if(NOT ${ARGC} EQUAL 2)
    message(FATAL_ERROR "Incorrect number of arguments: ${ARGV} (${ARGC}).")
  endif()

  #
  # 业务逻辑
  #

  if(NOT "${sName}" MATCHES [[^[-0-9A-Z_a-z]+(::[-0-9A-Z_a-z]+)*(\+\+)?$]])
    message(${oMode} "The name isn't meet CMake recommend variable rules: ${sName}.")
  endif()
endfunction()

#[=======================================================================[.rst:
.. command:: rr_check_c_name

  检查输入是否符合 C 语言标识符命名规则：
  仅包含拉丁字母、阿拉伯数字和下划线，且首字符不为数字。

  .. code-block:: cmake

    rr_check_c_name(<name> <mode>)

  参见：

  - `message <https://cmake.org/cmake/help/latest/command/message.html>`_
  - `C 语言标识符 <https://zh.cppreference.com/w/c/language/identifier>`_

#]=======================================================================]
function(rr_check_c_name sName oMode)
  #
  # 前置断言
  #

  if(NOT ${ARGC} EQUAL 2)
    message(FATAL_ERROR "Incorrect number of arguments: ${ARGV} (${ARGC}).")
  endif()

  #
  # 业务逻辑
  #

  if(NOT "${sName}" MATCHES [[^[A-Z_a-z]+[0-9A-Z_a-z]*$]])
    message(${oMode} "The name isn't meet C identifier rules: ${sName}.")
  endif()
endfunction()

#[=======================================================================[.rst:
.. command:: rr_check_fext_name

  检查输入是否符合（一般的）文件扩展名命名规则：
  首字符为下脚点，扩展名仅包含拉丁字母和阿拉伯数字，可以串接。

  另，临时文件偏好选用稀奇古怪的字符组成其后缀，如 ``!``、``#``、``$``、``&``、``@``、``_``、``~`` 等，此处没有考虑。

  .. code-block:: cmake

    rr_check_fext_name(<name> <mode>)

  参见：

  - `message <https://cmake.org/cmake/help/latest/command/message.html>`_
  - `Filename <https://wikipedia.org/wiki/Filename>`_
  - `List of filename extensions <https://wikipedia.org/wiki/List_of_filename_extensions>`_

#]=======================================================================]
function(rr_check_fext_name sName oMode)
  #
  # 前置断言
  #

  if(NOT ${ARGC} EQUAL 2)
    message(FATAL_ERROR "Incorrect number of arguments: ${ARGV} (${ARGC}).")
  endif()

  #
  # 业务逻辑
  #

  if(NOT "${sName}" MATCHES [[^(\.[0-9A-Za-z]+)+$]])
    message(${oMode} "The name isn't meet file extension rules: ${sName}.")
  endif()
endfunction()
