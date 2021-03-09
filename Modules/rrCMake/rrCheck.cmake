# zhengrr
# 2017-12-18 – 2021-03-02
# Unlicense

cmake_minimum_required(VERSION 3.10)
cmake_policy(VERSION 3.10)

include_guard()  # 3.10

#[=======================================================================[.rst:
.. command:: _rrcheck_check_message_mode

  检查输入字符串是否符合 ``message`` 命令的 ``<mode>`` 选项，返回真假值。

  .. code-block:: cmake

    _rrcheck_check_message_mode(<string> <variable>)

  参见：

  - `message <https://cmake.org/cmake/help/latest/command/message.html>`_

#]=======================================================================]
function(_rrcheck_check_message_mode sString xVariable)
  string(TOUPPER "${sString}" sUpper)
  foreach(sKeyword "FATAL_ERROR" "SEND_ERROR" "WARNING" "AUTHOR_WARNING" "DEPRECATION" "" "NOTICE" "STATUS" "VERBOSE" "DEBUG" "TRACE")
    if("${sUpper}" STREQUAL "${sKeyword}")
      set("${xVariable}" "TRUE" PARENT_SCOPE)
      return()
    endif()
  endforeach()
  set("${xVariable}" "FALSE" PARENT_SCOPE)
endfunction()

#[=======================================================================[.rst:
.. command:: rr_check_argc

  检查输入列表的元素数目是否在指定范围，输出消息或返回真假值。

  .. code-block:: cmake

    rr_check_argc(<argv> <upper-limit> [<message-mode> | <variable>])
    rr_check_argc(<argv> <lower-limit> <upper-limit> [<message-mode> | <variable>])
  
  用例：

  .. code-block:: cmake

    rr_check_argc("${ARGV}" 4 FATAL_ERROR)

  参见：

  - `function <https://cmake.org/cmake/help/latest/command/function.html>`_
  - `macro <https://cmake.org/cmake/help/latest/command/macro.html>`_
  - `message <https://cmake.org/cmake/help/latest/command/message.html>`_

#]=======================================================================]
function(rr_check_argc zArgv sPlaceholder1)
  if("${ARGC}" EQUAL 2)
    # <argv> <upper-limit>
    unset(nLowerLimit)
    set(nUpperLimit "${ARGV1}")
    set(oMessageModeOrVariable)
  elseif("${ARGC}" EQUAL 3)
    if("${ARGV2}" MATCHES [[^[0-9]+$]])
      # <argv> <lower-limit> <upper-limit>
      set(nLowerLimit "${ARGV1}")
      set(nUpperLimit "${ARGV2}")
      set(oMessageModeOrVariable)
    else()
      # <argv> <upper-limit> <message-mode>|<variable>
      unset(nLowerLimit)
      set(nUpperLimit "${ARGV1}")
      set(oMessageModeOrVariable "${ARGV2}")
    endif()
  elseif("${ARGC}" EQUAL 4)
    # <argv> <lower-limit> <upper-limit> <message-mode>|<variable>
    set(nLowerLimit "${ARGV1}")
    set(nUpperLimit "${ARGV2}")
    set(oMessageModeOrVariable "${ARGV3}")
  else()
    message(FATAL_ERROR "Incorrect number of arguments: ${ARGV} (${ARGC}).")
  endif()

  list(LENGTH zArgv nArgc)
  if((DEFINED nLowerLimit AND nArgc LESS nLowerLimit) OR nArgc GREATER nUpperLimit)
    set(bPassed "FALSE")
  else()
    set(bPassed "TRUE")
  endif()

  _rrcheck_check_message_mode("${oMessageModeOrVariable}" bMessageMode)
  if(NOT bMessageMode)
    set("${oMessageModeOrVariable}" "${bPassed}" PARENT_SCOPE)
  elseif(NOT bPassed)
    if(NOT DEFINED nLowerLimit)
      message(${oMessageModeOrVariable} "Assertion error: Incorrect number of arguments: ${zArgv} (expect <= ${nUpperLimit}, actually ${nArgc}).")
    elseif(nLowerLimit EQUAL nUpperLimit)
      message(${oMessageModeOrVariable} "Assertion error: Incorrect number of arguments: ${zArgv} (expect ${nLowerLimit}, actually ${nArgc}).")
    else()
      message(${oMessageModeOrVariable} "Assertion error: Incorrect number of arguments: ${zArgv} (expect [${nLowerLimit}, ${nUpperLimit}], actually ${nArgc}).")
    endif()
  endif()
endfunction()

#[=======================================================================[.rst:
.. command:: rr_check_c_name

  检查输入字符串是否符合 C 语言标识符命名规则：

  1. 仅包含拉丁字母、阿拉伯数字和下划线；
  2. 首字符不为数字。

  输出消息或返回真假值。

  .. code-block:: cmake

    rr_check_c_name(<name> [<message-mode> | <variable>])

  用例：

  .. code-block:: cmake

    rr_check_c_name("foobar" AUTHOR_WARNING)

  参见：

  - `message <https://cmake.org/cmake/help/latest/command/message.html>`_
  - `C 语言标识符 <https://zh.cppreference.com/w/c/language/identifier>`_

#]=======================================================================]
function(rr_check_c_name sName)
  if("${ARGC}" EQUAL 1)
    set(oMessageModeOrVariable)
  elseif("${ARGC}" EQUAL 2)
    set(oMessageModeOrVariable "${ARGV1}")
  else()
    message(FATAL_ERROR "Incorrect number of arguments: ${ARGV} (${ARGC}).")
  endif()

  if("${sName}" MATCHES [[^[A-Z_a-z]+[0-9A-Z_a-z]*$]])
    set(bPassed "TRUE")
  else()
    set(bPassed "FALSE")
  endif()

  _rrcheck_check_message_mode("${oMessageModeOrVariable}" bMessageMode)
  if(NOT bMessageMode)
    set("${oMessageModeOrVariable}" "${bPassed}" PARENT_SCOPE)
  elseif(NOT bPassed)
    message(${oMessageModeOrVariable} "Assertion error: The name isn't meet C identifier rules: ${sName}.")
  endif()
endfunction()

#[=======================================================================[.rst:
.. command:: rr_check_cmake_name

  检查输入字符串是否符合 CMake 推荐变量命名规则：

  1. 仅包含拉丁字母、阿拉伯数字、下划线和连字符；
  2. 额外引入双冒号（``::``）用于域分隔；
  3. 额外引入尾部双加号（``++``）用于某些库的 C++ 版本。

  输出消息或返回真假值。

  .. code-block:: cmake

    rr_check_cmake_name(<name> [<message-mode> | <variable>])

  用例：

  .. code-block:: cmake

    rr_check_cmake_name("foobar" AUTHOR_WARNING)

  参见：

  - `message <https://cmake.org/cmake/help/latest/command/message.html>`_
  - `cmake-language(7) § Variables <https://cmake.org/cmake/help/latest/manual/cmake-language.7.html#variables>`_

#]=======================================================================]
function(rr_check_cmake_name sName)
  if("${ARGC}" EQUAL 1)
    set(oMessageModeOrVariable)
  elseif("${ARGC}" EQUAL 2)
    set(oMessageModeOrVariable "${ARGV1}")
  else()
    message(FATAL_ERROR "Incorrect number of arguments: ${ARGV} (${ARGC}).")
  endif()

  if("${sName}" MATCHES [[^[-0-9A-Z_a-z]+(::[-0-9A-Z_a-z]+)*(\+\+)?$]])
    set(bPassed "TRUE")
  else()
    set(bPassed "FALSE")
  endif()

  _rrcheck_check_message_mode("${oMessageModeOrVariable}" bMessageMode)
  if(NOT bMessageMode)
    set("${oMessageModeOrVariable}" "${bPassed}" PARENT_SCOPE)
  elseif(NOT bPassed)
    message(${oMessageModeOrVariable} "Assertion error: The name isn't meet CMake recommend variable rules: ${sName}.")
  endif()
endfunction()

#[=======================================================================[.rst:
.. command:: rr_check_fext_name

  检查输入字符串是否符合（一般的）文件扩展名命名规则：

  1. 首字符为下脚点；
  2. 扩展名仅包含拉丁字母和阿拉伯数字；
  3. 可以串接。

  输出消息或返回真假值。

  值得注意的是，临时文件偏好选用稀奇古怪的字符组成其后缀，如 ``!``、``#``、``$``、``&``、``@``、``_``、``~`` 等，此处没有考虑。

  .. code-block:: cmake

    rr_check_fext_name(<name> [<message-mode> | <variable>])

  用例：

  .. code-block:: cmake

    rr_check_fext_name("foobar" AUTHOR_WARNING)

  参见：

  - `message <https://cmake.org/cmake/help/latest/command/message.html>`_
  - `Filename <https://wikipedia.org/wiki/Filename>`_
  - `List of filename extensions <https://wikipedia.org/wiki/List_of_filename_extensions>`_

#]=======================================================================]
function(rr_check_fext_name sName)
  if("${ARGC}" EQUAL 1)
    set(oMessageModeOrVariable)
  elseif("${ARGC}" EQUAL 2)
    set(oMessageModeOrVariable "${ARGV1}")
  else()
    message(FATAL_ERROR "Incorrect number of arguments: ${ARGV} (${ARGC}).")
  endif()

  if("${sName}" MATCHES [[^(\.[0-9A-Za-z]+)+$]])
    set(bPassed "TRUE")
  else()
    set(bPassed "FALSE")
  endif()

  _rrcheck_check_message_mode("${oMessageModeOrVariable}" bMessageMode)
  if(NOT bMessageMode)
    set("${oMessageModeOrVariable}" "${bPassed}" PARENT_SCOPE)
  elseif(NOT bPassed)
    message(${oMessageModeOrVariable} "Assertion error: The name isn't meet file extension rules: ${sName}.")
  endif()
endfunction()

#[=======================================================================[.rst:
.. command:: rr_check_no_argn

  检查输入列表是否为空，输出消息或返回真假值。

  .. code-block:: cmake

    rr_check_no_argn(<argn> [<message-mode> | <variable>])
  
  用例：

  .. code-block:: cmake

    rr_check_no_argn("${ARGN}" FATAL_ERROR)

  参见：

  - `function <https://cmake.org/cmake/help/latest/command/function.html>`_
  - `macro <https://cmake.org/cmake/help/latest/command/macro.html>`_
  - `message <https://cmake.org/cmake/help/latest/command/message.html>`_

#]=======================================================================]
function(rr_check_no_argn zArgn)
  if("${ARGC}" EQUAL 1)
    set(oMessageModeOrVariable)
  elseif("${ARGC}" EQUAL 2)
    set(oMessageModeOrVariable "${ARGV1}")
  else()
    message(FATAL_ERROR "Incorrect number of arguments: ${ARGV} (${ARGC}).")
  endif()

  if("${zArgn}" STREQUAL "")
    set(bPassed "TRUE")
  else()
    set(bPassed "FALSE")
  endif()

  _rrcheck_check_message_mode("${oMessageModeOrVariable}" bMessageMode)
  if(NOT bMessageMode)
    set("${oMessageModeOrVariable}" "${bPassed}" PARENT_SCOPE)
  elseif(NOT bPassed)
    message(${oMessageModeOrVariable} "Assertion error: Unexpected arguments: ${zArgn}.")
  endif()
endfunction()

#[=======================================================================[.rst:
.. command:: rr_check_target

  检查输入字符串是否为对象，输出消息或返回真假值。

  .. code-block:: cmake

    rr_check_target(<target-name> [<message-mode> | <variable>])

  用例：

  .. code-block:: cmake

    rr_check_target("foobar" FATAL_ERROR)

  参见：

  - `if <https://cmake.org/cmake/help/latest/command/if.html>`_
  - `message <https://cmake.org/cmake/help/latest/command/message.html>`_

#]=======================================================================]
function(rr_check_target sTargetName)
  if("${ARGC}" EQUAL 1)
    set(oMessageModeOrVariable)
  elseif("${ARGC}" EQUAL 2)
    set(oMessageModeOrVariable "${ARGV1}")
  else()
    message(FATAL_ERROR "Incorrect number of arguments: ${ARGV} (${ARGC}).")
  endif()

  if(TARGET "${sTargetName}")
    set(bPassed "TRUE")
  else()
    set(bPassed "FALSE")
  endif()

  _rrcheck_check_message_mode("${oMessageModeOrVariable}" bMessageMode)
  if(NOT bMessageMode)
    set("${oMessageModeOrVariable}" "${bPassed}" PARENT_SCOPE)
  elseif(NOT bPassed)
    message(${oMessageModeOrVariable} "Assertion error: The name isn't a target: ${sTargetName}.")
  endif()
endfunction()
