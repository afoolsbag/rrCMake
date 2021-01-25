# zhengrr
# 2017-12-18 – 2021-01-25
# Unlicense

cmake_minimum_required(VERSION 3.10)
cmake_policy(VERSION 3.10)

include_guard()  # 3.10

#[=======================================================================[.rst:
.. command:: _rrcheck_check_message_mode

  检查输入字符串是否符合 ``message`` 命令的 ``<mode>`` 选项，返回真假值。

  .. code-block:: cmake

    _rrcheck_check_message_mode(<string> <variable>)

  用例：

  .. code-block:: cmake

    _rrcheck_check_message_mode("foobar" bResult)
    message("bResult: ${bResult}")

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

  检查参数数目。

  .. code-block:: cmake

    rr_check_argc(<argv> <upper-limit> [<mode> | <variable>])
    rr_check_argc(<argv> <lower-limit> <upper-limit> [<mode> | <variable>])
  
  用例：

  .. code-block:: cmake

    rr_check_argc("${ARGV}" 4 FATAL_ERROR)

  参见：

  - `function <https://cmake.org/cmake/help/latest/command/function.html>`_
  - `macro <https://cmake.org/cmake/help/latest/command/macro.html>`_
  - `message <https://cmake.org/cmake/help/latest/command/message.html>`_

#]=======================================================================]
function(rr_check_argc zArgv nPlaceholder)
  if("${ARGC}" EQUAL 2)
    # <argv> <upper-limit>
    unset(nLowerLimit)
    set(nUpperLimit "${ARGV1}")
    set(oModeOrVariable)

  elseif("${ARGC}" EQUAL 3)
    if("${ARGV2}" MATCHES [[^[0-9]+$]])
      # <argv> <lower-limit> <upper-limit>
      set(nLowerLimit "${ARGV1}")
      set(nUpperLimit "${ARGV2}")
      set(oModeOrVariable)

    else()
      # <argv> <upper-limit> <mode>|<variable>
      unset(nLowerLimit)
      set(nUpperLimit "${ARGV1}")
      set(oModeOrVariable "${ARGV2}")
    endif()

  elseif("${ARGC}" EQUAL 4)
    # <argv> <lower-limit> <upper-limit> <mode>|<variable>
    set(nLowerLimit "${ARGV1}")
    set(nUpperLimit "${ARGV2}")
    set(oModeOrVariable "${ARGV3}")
  
  else()
    message(FATAL_ERROR "Incorrect number of arguments: ${ARGV} (${ARGC}).")
  endif()

  #
  # 业务逻辑
  #

  list(LENGTH zArgv nArgc)
  if((DEFINED nLowerLimit AND nArgc LESS nLowerLimit) OR nArgc GREATER nUpperLimit)
    set(bPassed "FALSE")
  else()
    set(bPassed "TRUE")
  endif()

  _rrcheck_check_message_mode("${oModeOrVariable}" bReturnViaMessage)
  if(NOT bReturnViaMessage)
    set("${oModeOrVariable}" "${bPassed}" PARENT_SCOPE)
  elseif(NOT bPassed)
    if(DEFINED nLowerLimit)
      message(${oModeOrVariable} "Check result: Incorrect number of arguments: ${zArgv} (expect [${nLowerLimit}, ${nUpperLimit}], actually ${nArgc}).")
    else()
      message(${oModeOrVariable} "Check result: Incorrect number of arguments: ${zArgv} (expect <= ${nUpperLimit}, actually ${nArgc}).")
    endif()
  endif()
endfunction()

#[=======================================================================[.rst:
.. command:: rr_check_c_name

  检查输入是否符合 C 语言标识符命名规则：
  仅包含拉丁字母、阿拉伯数字和下划线，且首字符不为数字。

  .. code-block:: cmake

    rr_check_c_name(<name> [<mode> | <variable>])

  用例：

  .. code-block:: cmake

    rr_check_c_name("foobar" AUTHOR_WARNING)

  参见：

  - `message <https://cmake.org/cmake/help/latest/command/message.html>`_
  - `C 语言标识符 <https://zh.cppreference.com/w/c/language/identifier>`_

#]=======================================================================]
function(rr_check_c_name sName)
  if("${ARGC}" EQUAL 1)
    # <name>
    set(oModeOrVariable)

  elseif("${ARGC}" EQUAL 2)
    # <name> <mode>|<variable>
    set(oModeOrVariable "${ARGV1}")

  else()
    message(FATAL_ERROR "Incorrect number of arguments: ${ARGV} (${ARGC}).")
  endif()

  #
  # 业务逻辑
  #

  if("${sName}" MATCHES [[^[A-Z_a-z]+[0-9A-Z_a-z]*$]])
    set(bPassed "TRUE")
  else()
    set(bPassed "FALSE")
  endif()

  _rrcheck_check_message_mode("${oModeOrVariable}" bReturnViaMessage)
  if(NOT bReturnViaMessage)
    set("${oModeOrVariable}" "${bPassed}" PARENT_SCOPE)
  elseif(NOT bPassed)
    message(${oModeOrVariable} "Check result: The name isn't meet C identifier rules: ${sName}.")
  endif()
endfunction()

#[=======================================================================[.rst:
.. command:: rr_check_cmake_name

  检查输入是否符合 CMake 推荐变量命名规则：
  仅包含拉丁字母、阿拉伯数字、下划线和连字符；
  另引入双冒号（``::``）用于域分隔，尾部双加号（``++``）用于某些库的 C++ 版本。

  .. code-block:: cmake

    rr_check_cmake_name(<name> [<mode> | <variable>])

  用例：

  .. code-block:: cmake

    rr_check_cmake_name("foobar" AUTHOR_WARNING)

  参见：

  - `message <https://cmake.org/cmake/help/latest/command/message.html>`_
  - `cmake-language(7) § Variables <https://cmake.org/cmake/help/latest/manual/cmake-language.7.html#variables>`_

#]=======================================================================]
function(rr_check_cmake_name sName)
  if("${ARGC}" EQUAL 1)
    # <name>
    set(oModeOrVariable)

  elseif("${ARGC}" EQUAL 2)
    # <name> <mode>|<variable>
    set(oModeOrVariable "${ARGV1}")

  else()
    message(FATAL_ERROR "Incorrect number of arguments: ${ARGV} (${ARGC}).")
  endif()

  #
  # 业务逻辑
  #

  if("${sName}" MATCHES [[^[-0-9A-Z_a-z]+(::[-0-9A-Z_a-z]+)*(\+\+)?$]])
    set(bPassed "TRUE")
  else()
    set(bPassed "FALSE")
  endif()

  _rrcheck_check_message_mode("${oModeOrVariable}" bReturnViaMessage)
  if(NOT bReturnViaMessage)
    set("${oModeOrVariable}" "${bPassed}" PARENT_SCOPE)
  elseif(NOT bPassed)
    message(${oModeOrVariable} "Check result: The name isn't meet CMake recommend variable rules: ${sName}.")
  endif()
endfunction()

#[=======================================================================[.rst:
.. command:: rr_check_fext_name

  检查输入是否符合（一般的）文件扩展名命名规则：
  首字符为下脚点，扩展名仅包含拉丁字母和阿拉伯数字，可以串接。

  另，临时文件偏好选用稀奇古怪的字符组成其后缀，如 ``!``、``#``、``$``、``&``、``@``、``_``、``~`` 等，此处没有考虑。

  .. code-block:: cmake

    rr_check_fext_name(<name> [<mode> | <variable>])

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
    # <name>
    set(oModeOrVariable)

  elseif("${ARGC}" EQUAL 2)
    # <name> <mode>|<variable>
    set(oModeOrVariable "${ARGV1}")

  else()
    message(FATAL_ERROR "Incorrect number of arguments: ${ARGV} (${ARGC}).")
  endif()

  #
  # 业务逻辑
  #

  if("${sName}" MATCHES [[^(\.[0-9A-Za-z]+)+$]])
    set(bPassed "TRUE")
  else()
    set(bPassed "FALSE")
  endif()

  _rrcheck_check_message_mode("${oModeOrVariable}" bReturnViaMessage)
  if(NOT bReturnViaMessage)
    set("${oModeOrVariable}" "${bPassed}" PARENT_SCOPE)
  elseif(NOT bPassed)
    message(${oModeOrVariable} "Check result: The name isn't meet file extension rules: ${sName}.")
  endif()
endfunction()

#[=======================================================================[.rst:
.. command:: rr_check_no_argn

  检查不预期的剩余参数。

  .. code-block:: cmake

    rr_check_no_argn(<argn> [<mode> | <variable>])
  
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
    # <argn>
    set(oModeOrVariable)

  elseif("${ARGC}" EQUAL 2)
    # <argn> <mode>|<variable>
    set(oModeOrVariable "${ARGV1}")

  else()
    message(FATAL_ERROR "Incorrect number of arguments: ${ARGV} (${ARGC}).")
  endif()

  #
  # 业务逻辑
  #

  if("${zArgn}" STREQUAL "")
    set(bPassed "TRUE")
  else()
    set(bPassed "FALSE")
  endif()

  _rrcheck_check_message_mode("${oModeOrVariable}" bReturnViaMessage)
  if(NOT bReturnViaMessage)
    set("${oModeOrVariable}" "${bPassed}" PARENT_SCOPE)
  elseif(NOT bPassed)
    message(${oModeOrVariable} "Check result: Unexpected arguments: ${zArgn}.")
  endif()
endfunction()

#[=======================================================================[.rst:
.. command:: rr_check_target

  检查输入是否是对象。

  .. code-block:: cmake

    rr_check_target(<target-name> [<mode> | <variable>])

  用例：

  .. code-block:: cmake

    rr_check_target("foobar" FATAL_ERROR)

  参见：

  - `if <https://cmake.org/cmake/help/latest/command/if.html>`_
  - `message <https://cmake.org/cmake/help/latest/command/message.html>`_

#]=======================================================================]
function(rr_check_target sTargetName)
  if("${ARGC}" EQUAL 1)
    # <target-name>
    set(oModeOrVariable)

  elseif("${ARGC}" EQUAL 2)
    # <target-name> <mode>|<variable>
    set(oModeOrVariable "${ARGV1}")

  else()
    message(FATAL_ERROR "Incorrect number of arguments: ${ARGV} (${ARGC}).")
  endif()

  #
  # 业务逻辑
  #

  if(TARGET "${sTargetName}")
    set(bPassed "TRUE")
  else()
    set(bPassed "FALSE")
  endif()

  _rrcheck_check_message_mode("${oModeOrVariable}" bReturnViaMessage)
  if(NOT bReturnViaMessage)
    set("${oModeOrVariable}" "${bPassed}" PARENT_SCOPE)
  elseif(NOT bPassed)
    message(${oModeOrVariable} "Check result: The name isn't a target: ${sTargetName}.")
  endif()
endfunction()
