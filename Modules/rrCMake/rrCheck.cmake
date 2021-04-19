# zhengrr
# 2017-12-18 – 2021-04-19
# Unlicense

#[=======================================================================[.rst:
rrCheck
-------

提供若干检查函数，以便利断言。
#]=======================================================================]

cmake_minimum_required(VERSION 3.10)
cmake_policy(VERSION 3.10)

include_guard()  # 3.10


#[=======================================================================[.rst:
.. command:: _rrcheck_check_message_mode

  内部函数：检查输入字符串是否符合 ``message`` 命令的 ``<mode>`` 选项，返回真假值。

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


#   ___                                       _
#  / _ \                                     | |
# / /_\ \_ __ __ _ _   _ _ __ ___   ___ _ __ | |_ ___
# |  _  | '__/ _` | | | | '_ ` _ \ / _ \ '_ \| __/ __|
# | | | | | | (_| | |_| | | | | | |  __/ | | | |_\__ \
# \_| |_/_|  \__, |\__,_|_| |_| |_|\___|_| |_|\__|___/
#            __/ |
#           |___/
#
# 参见：
#
# - `function <https://cmake.org/cmake/help/latest/command/function.html>`_
# - `macro <https://cmake.org/cmake/help/latest/command/macro.html>`_


#[=======================================================================[.rst:
.. command:: rr_check_argc

  检查输入列表的元素数目是否在指定范围，输出消息或返回真假值。

  .. code-block:: cmake

    rr_check_argc(<argv> <upper-limit> [<message-mode> | <variable>])
    rr_check_argc(<argv> <lower-limit> <upper-limit> [<message-mode> | <variable>])
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
    # invalid input
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
.. command:: rr_check_no_argn

  检查输入列表是否为空，输出消息或返回真假值。

  .. code-block:: cmake

    rr_check_no_argn(<argn> [<message-mode> | <variable>])
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


#  _____     _     _                      _____ _               _
# |  ___|   (_)   | |                    /  __ \ |             | |
# | |____  ___ ___| |_ ___ _ __   ___ ___| /  \/ |__   ___  ___| | _____
# |  __\ \/ / / __| __/ _ \ '_ \ / __/ _ \ |   | '_ \ / _ \/ __| |/ / __|
# | |___>  <| \__ \ ||  __/ | | | (_|  __/ \__/\ | | |  __/ (__|   <\__ \
# \____/_/\_\_|___/\__\___|_| |_|\___\___|\____/_| |_|\___|\___|_|\_\___/
#
# 参见：
#
# - `if § Existence Checks <https://cmake.org/cmake/help/latest/command/if.html#existence-checks>`_


#[=======================================================================[.rst:
.. command:: rr_check_command

  检查输入名是否为可调用的命令、宏或函数，输出消息或返回真假值。

  .. code-block:: cmake

    rr_check_command(<command-name> [<message-mode> | <variable>])
#]=======================================================================]
function(rr_check_command sCommandName)
  if("${ARGC}" EQUAL 1)
    set(oMessageModeOrVariable)
  elseif("${ARGC}" EQUAL 2)
    set(oMessageModeOrVariable "${ARGV1}")
  else()
    message(FATAL_ERROR "Incorrect number of arguments: ${ARGV} (${ARGC}).")
  endif()

  if(COMMAND "${sCommandName}")
    set(bPassed "TRUE")
  else()
    set(bPassed "FALSE")
  endif()

  _rrcheck_check_message_mode("${oMessageModeOrVariable}" bMessageMode)
  if(NOT bMessageMode)
    set("${oMessageModeOrVariable}" "${bPassed}" PARENT_SCOPE)
  elseif(NOT bPassed)
    message(${oMessageModeOrVariable} "Assertion error: The name is not a command: ${sCommandName}.")
  endif()
endfunction()


#[=======================================================================[.rst:
.. command:: rr_check_policy

  检查输入标识是否为策略，输出消息或返回真假值。

  .. code-block:: cmake

    rr_check_policy(<policy-id> [<message-mode> | <variable>])
#]=======================================================================]
function(rr_check_policy sPolicyId)
  if("${ARGC}" EQUAL 1)
    set(oMessageModeOrVariable)
  elseif("${ARGC}" EQUAL 2)
    set(oMessageModeOrVariable "${ARGV1}")
  else()
    message(FATAL_ERROR "Incorrect number of arguments: ${ARGV} (${ARGC}).")
  endif()

  if(POLICY "${sPolicyId}")
    set(bPassed "TRUE")
  else()
    set(bPassed "FALSE")
  endif()

  _rrcheck_check_message_mode("${oMessageModeOrVariable}" bMessageMode)
  if(NOT bMessageMode)
    set("${oMessageModeOrVariable}" "${bPassed}" PARENT_SCOPE)
  elseif(NOT bPassed)
    message(${oMessageModeOrVariable} "Assertion error: The identifier is not a policy: ${sPolicyId}.")
  endif()
endfunction()


#[=======================================================================[.rst:
.. command:: rr_check_target

  检查输入名是否为对象，输出消息或返回真假值。

  .. code-block:: cmake

    rr_check_target(<target-name> [<message-mode> | <variable>])
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
    message(${oMessageModeOrVariable} "Assertion error: The name is not a target: ${sTargetName}.")
  endif()
endfunction()


# ______ _ _       _____                      _   _
# |  ___(_) |     |  _  |                    | | (_)
# | |_   _| | ___ | | | |_ __   ___ _ __ __ _| |_ _  ___  _ __  ___ 
# |  _| | | |/ _ \| | | | '_ \ / _ \ '__/ _` | __| |/ _ \| '_ \/ __|
# | |   | | |  __/\ \_/ / |_) |  __/ | | (_| | |_| | (_) | | | \__ \
# \_|   |_|_|\___| \___/| .__/ \___|_|  \__,_|\__|_|\___/|_| |_|___/
#                       | |
#                       |_|
#
# 参见：
#
# - `if § File Operations <https://cmake.org/cmake/help/latest/command/if.html#file-operations>`_


#[=======================================================================[.rst:
.. command:: rr_check_exists

  检查输入路径是否为存在，输出消息或返回真假值。

  .. code-block:: cmake

    rr_check_exists(<path> [<message-mode> | <variable>])
#]=======================================================================]
function(rr_check_exists sPath)
  if("${ARGC}" EQUAL 1)
    set(oMessageModeOrVariable)
  elseif("${ARGC}" EQUAL 2)
    set(oMessageModeOrVariable "${ARGV1}")
  else()
    message(FATAL_ERROR "Incorrect number of arguments: ${ARGV} (${ARGC}).")
  endif()

  if(EXISTS "${sPath}")
    set(bPassed "TRUE")
  else()
    set(bPassed "FALSE")
  endif()

  _rrcheck_check_message_mode("${oMessageModeOrVariable}" bMessageMode)
  if(NOT bMessageMode)
    set("${oMessageModeOrVariable}" "${bPassed}" PARENT_SCOPE)
  elseif(NOT bPassed)
    message(${oMessageModeOrVariable} "Assertion error: The path dose not exist: ${sPath}.")
  endif()
endfunction()


#[=======================================================================[.rst:
.. command:: rr_check_directory

  检查输入路径是否为目录，输出消息或返回真假值。

  .. code-block:: cmake

    rr_check_directory(<directory-path> [<message-mode> | <variable>])
#]=======================================================================]
function(rr_check_directory sDirectoryPath)
  if("${ARGC}" EQUAL 1)
    set(oMessageModeOrVariable)
  elseif("${ARGC}" EQUAL 2)
    set(oMessageModeOrVariable "${ARGV1}")
  else()
    message(FATAL_ERROR "Incorrect number of arguments: ${ARGV} (${ARGC}).")
  endif()

  if(IS_DIRECTORY "${sDirectoryPath}")
    set(bPassed "TRUE")
  else()
    set(bPassed "FALSE")
  endif()

  _rrcheck_check_message_mode("${oMessageModeOrVariable}" bMessageMode)
  if(NOT bMessageMode)
    set("${oMessageModeOrVariable}" "${bPassed}" PARENT_SCOPE)
  elseif(NOT bPassed)
    message(${oMessageModeOrVariable} "Assertion error: The path is not a directory: ${sDirectoryPath}.")
  endif()
endfunction()


#[=======================================================================[.rst:
.. command:: rr_check_symlink

  检查输入路径是否为符号链接，输出消息或返回真假值。

  .. code-block:: cmake

    rr_check_symlink(<symlink-path> [<message-mode> | <variable>])
#]=======================================================================]
function(rr_check_symlink sSymlinkPath)
  if("${ARGC}" EQUAL 1)
    set(oMessageModeOrVariable)
  elseif("${ARGC}" EQUAL 2)
    set(oMessageModeOrVariable "${ARGV1}")
  else()
    message(FATAL_ERROR "Incorrect number of arguments: ${ARGV} (${ARGC}).")
  endif()

  if(IS_SYMLINK "${sSymlinkPath}")
    set(bPassed "TRUE")
  else()
    set(bPassed "FALSE")
  endif()

  _rrcheck_check_message_mode("${oMessageModeOrVariable}" bMessageMode)
  if(NOT bMessageMode)
    set("${oMessageModeOrVariable}" "${bPassed}" PARENT_SCOPE)
  elseif(NOT bPassed)
    message(${oMessageModeOrVariable} "Assertion error: The path is not a symbolic link: ${sSymlinkPath}.")
  endif()
endfunction()


#[=======================================================================[.rst:
.. command:: rr_check_absolute

  检查输入路径是否为绝对路径，输出消息或返回真假值。

  .. code-block:: cmake

    rr_check_absolute(<absolute-path> [<message-mode> | <variable>])
#]=======================================================================]
function(rr_check_absolute sAbsolutePath)
  if("${ARGC}" EQUAL 1)
    set(oMessageModeOrVariable)
  elseif("${ARGC}" EQUAL 2)
    set(oMessageModeOrVariable "${ARGV1}")
  else()
    message(FATAL_ERROR "Incorrect number of arguments: ${ARGV} (${ARGC}).")
  endif()

  if(IS_ABSOLUTE "${sAbsolutePath}")
    set(bPassed "TRUE")
  else()
    set(bPassed "FALSE")
  endif()

  _rrcheck_check_message_mode("${oMessageModeOrVariable}" bMessageMode)
  if(NOT bMessageMode)
    set("${oMessageModeOrVariable}" "${bPassed}" PARENT_SCOPE)
  elseif(NOT bPassed)
    message(${oMessageModeOrVariable} "Assertion error: The path is not a absolute: ${sAbsolutePath}.")
  endif()
endfunction()


# ___  ___
# |  \/  |
# | .  . | ___  _ __ ___
# | |\/| |/ _ \| '__/ _ \
# | |  | | (_) | | |  __/
# \_|  |_/\___/|_|  \___|
#


#[=======================================================================[.rst:
.. command:: rr_check_c_name

  检查输入字符串是否符合 C 语言标识符命名规则：

  1. 仅包含拉丁字母、阿拉伯数字和下划线；
  2. 首字符不为数字。

  输出消息或返回真假值。

  .. code-block:: cmake

    rr_check_c_name(<name> [<message-mode> | <variable>])

  参见：

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
