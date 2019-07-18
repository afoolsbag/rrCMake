# zhengrr
# 2016-10-08 – 2019-07-18
# Unlicense

cmake_minimum_required(VERSION 3.10)
cmake_policy(VERSION 3.10)

include_guard()

#.rst:
# .. command:: project_ex
#
#   设定项目属性（project），扩展功能（extend）。
#
#   .. code-block:: cmake
#
#     project_ex(
#       <argument>...
#       [AUTHORS <author>...]
#       [LICENSE <license>]
#     )
#
#   参见：
#
#   - `preject <https://cmake.org/cmake/help/latest/command/project.html>`_
macro(project_ex)
  set(zOptKws)
  set(zOneValKws LICENSE)
  set(zMutValKws AUTHORS)
  cmake_parse_arguments("" "${zOptKws}" "${zOneValKws}" "${zMutValKws}" ${ARGV})

  project(${_UNPARSED_ARGUMENTS})

  if(DEFINED _AUTHORS)
    set(PROJECT_AUTHORS ${_AUTHORS})
  else()
    set(PROJECT_AUTHORS "${PRODUCT_AUTHORS}")
  endif()

  if(DEFINED _LICENSE)
    set(PROJECT_LICENSE "${_LICENSE}")
  else()
    set(PROJECT_LICENSE "${PRODUCT_LICENSE}")
  endif()

  string(TOLOWER "${PROJECT_NAME}" PROJECT_NAME_LOWER)

  string(TOUPPER "${PROJECT_NAME}" PROJECT_NAME_UPPER)

  if(NOT "${PROJECT_VERSION_MAJOR}")
    set(PROJECT_VERSION_MAJOR 0)
  endif()

  if(NOT "${PROJECT_VERSION_MINOR}")
    set(PROJECT_VERSION_MINOR 0)
  endif()

  if(NOT "${PROJECT_VERSION_PATCH}")
    set(PROJECT_VERSION_PATCH 0)
  endif()

  if(NOT "${PROJECT_VERSION_TWEAK}")
    set(PROJECT_VERSION_TWEAK 0)
  endif()
endmacro()

#.rst:
# .. command:: product_ex
#
#   设定产品属性（product），扩展功能（extend）。
#
#   .. code-block:: cmake
#
#     product_ex(
#       <argument>...
#     )
#
#   参见：
#
#   - :command:`project_ex`
macro(product_ex)
  project_ex(${ARGV})

  set(PRODUCT_AUTHORS         ${PROJECT_AUTHORS})
  set(PRODUCT_BINARY_DIR      "${PROJECT_BINARY_DIR}")
  set(PRODUCT_DESCRIPTION     "${PROJECT_DESCRIPTION}")
  set(PRODUCT_HOMEPAGE_URL    "${PROJECT_HOMEPAGE_URL}")
  set(PRODUCT_LICENSE         "${PROJECT_LICENSE}")
  set(PRODUCT_NAME            "${PROJECT_NAME}")
  set(PRODUCT_NAME_LOWER      "${PROJECT_NAME_LOWER}")
  set(PRODUCT_NAME_UPPER      "${PROJECT_NAME_UPPER}")
  set(PRODUCT_SOURCE_DIR      "${PROJECT_SOURCE_DIR}")
  set(PRODUCT_VERSION         "${PROJECT_VERSION}")
  set(PRODUCT_VERSION_MAJOR   "${PROJECT_VERSION_MAJOR}")
  set(PRODUCT_VERSION_MINOR   "${PROJECT_VERSION_MINOR}")
  set(PRODUCT_VERSION_PATCH   "${PROJECT_VERSION_PATCH}")
  set(PRODUCT_VERSION_TWEAK   "${PROJECT_VERSION_TWEAK}")
endmacro()
