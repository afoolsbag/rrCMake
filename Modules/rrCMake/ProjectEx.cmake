# zhengrr
# 2016-10-08 – 2019-11-20
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
#       <argument-of-preject>...
#       [TIME_AS_VERSION]
#       [AUTHORS <author>...]
#       [LICENSE <license>]
#     )
#
#   参见：
#
#   - `preject <https://cmake.org/cmake/help/latest/command/project.html>`_
#
macro(project_ex)
  set(zOptKws    TIME_AS_VERSION)
  set(zOneValKws LICENSE
                 VERSION)
  set(zMutValKws AUTHORS)
  cmake_parse_arguments("_project_ex" "${zOptKws}" "${zOneValKws}" "${zMutValKws}" ${ARGV})

  #
  # 参数规整
  #

  # TIME_AS_VERSION
  if(_project_ex_TIME_AS_VERSION)
    if(NOT DEFINED _project_ex_VERSION)
      string(TIMESTAMP _project_ex_VERSION "%Y.%m.%d.%H%M")
    else()
      message(AUTHOR_WARNING "Keyword VERSION is used, ignore keyword TIME_AS_VERSION.")
    endif()
  endif()
  if(DEFINED _project_ex_VERSION)
    list(INSERT _project_ex_VERSION 0 VERSION)
  endif()

  #
  # 基础功能
  #

  project(${_project_ex_UNPARSED_ARGUMENTS} ${_project_ex_VERSION})

  #
  # 扩展功能
  #

  # PROJECT_AUTHORS
  if(DEFINED _project_ex_AUTHORS)
    set(PROJECT_AUTHORS ${_project_ex_AUTHORS})
  elseif(DEFINED PRODUCT_AUTHORS)
    set(PROJECT_AUTHORS ${PRODUCT_AUTHORS})
  else()
    set(PROJECT_AUTHORS)
  endif()

  # PROJECT_LICENSE
  if(DEFINED _project_ex_LICENSE)
    set(PROJECT_LICENSE "${_project_ex_LICENSE}")
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
