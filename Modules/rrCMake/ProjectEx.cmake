# zhengrr
# 2016-10-08 – 2019-11-19
# Unlicense

cmake_minimum_required(VERSION 3.10)
cmake_policy(VERSION 3.10)

include_guard()  # 3.10

#.rst:
# .. command:: project_ex
#
#   设定项目属性（project），扩展功能（extend）。
#
#   .. code-block:: cmake
#
#     project_ex(
#       <argument>...
#       [TIME_AS_VERSION]
#       [AUTHORS <author>...]
#       [LICENSE <license>]
#     )
#
#   参见：
#
#   - `preject <https://cmake.org/cmake/help/latest/command/project.html>`_
macro(project_ex)
  set(zOptKws    TIME_AS_VERSION)
  set(zOneValKws VERSION
                 LICENSE)
  set(zMutValKws AUTHORS)
  cmake_parse_arguments("PROJECT_EX_ARG" "${zOptKws}" "${zOneValKws}" "${zMutValKws}" ${ARGV})
  # 宏的参数解析使用全局前缀，并跳过参数规整化，减少变量污染

  # TIME_AS_VERSION
  if(PROJECT_EX_ARG_TIME_AS_VERSION)
    if(NOT DEFINED PROJECT_EX_ARG_VERSION)
      string(TIMESTAMP PROJECT_EX_ARG_VERSION "%Y.%m.%d.%H%M")
    else()
      message(WARNING "Keyword VERSION is used, ignore keyword TIME_AS_VERSION.")
    endif()
  endif()
  if(DEFINED PROJECT_EX_ARG_VERSION)
    list(INSERT PROJECT_EX_ARG_VERSION 0 VERSION)
  endif()

  # 基础功能
  project(${PROJECT_EX_ARG_UNPARSED_ARGUMENTS} ${PROJECT_EX_ARG_VERSION})

  # PROJECT_AUTHORS
  if(DEFINED PROJECT_EX_ARG_AUTHORS)
    set(PROJECT_AUTHORS ${PROJECT_EX_ARG_AUTHORS})
  elseif(DEFINED PRODUCT_AUTHORS)
    set(PROJECT_AUTHORS ${PRODUCT_AUTHORS})
  else()
    set(PROJECT_AUTHORS)
  endif()

  # PROJECT_LICENSE
  if(DEFINED PROJECT_EX_ARG_LICENSE)
    set(PROJECT_LICENSE "${PROJECT_EX_ARG_LICENSE}")
  elseif(DEFINED PRODUCT_LICENSE)
    set(PROJECT_LICENSE "${PRODUCT_LICENSE}")
  else()
    set(PROJECT_LICENSE)
  endif()

  # PROJECT_NAME_LOWER
  string(TOLOWER "${PROJECT_NAME}" PROJECT_NAME_LOWER)

  # PROJECT_NAME_UPPER
  string(TOUPPER "${PROJECT_NAME}" PROJECT_NAME_UPPER)

  # PROJECT_VERSION_MAJOR 默认值
  if(NOT "${PROJECT_VERSION_MAJOR}")
    set(PROJECT_VERSION_MAJOR 0)
  endif()

  # PROJECT_VERSION_MINOR 默认值
  if(NOT "${PROJECT_VERSION_MINOR}")
    set(PROJECT_VERSION_MINOR 0)
  endif()

  # PROJECT_VERSION_PATCH 默认值
  if(NOT "${PROJECT_VERSION_PATCH}")
    set(PROJECT_VERSION_PATCH 0)
  endif()

  # PROJECT_VERSION_TWEAK 默认值
  if(NOT "${PROJECT_VERSION_TWEAK}")
    set(PROJECT_VERSION_TWEAK 0)
  endif()

endmacro()
