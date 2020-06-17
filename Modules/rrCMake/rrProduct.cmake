# zhengrr
# 2016-10-08 – 2020-06-17
# Unlicense

cmake_minimum_required(VERSION 3.10)
cmake_policy(VERSION 3.10)

include_guard()  # 3.10

if(NOT COMMAND rr_project OR NOT COMMAND rr_project_extra)
  include("${CMAKE_CURRENT_LIST_DIR}/rrProject.cmake")
endif()

#.rst:
# .. command:: rr_product
#
#   基于 ``rr_project`` 命令，设定产品（product）属性。
#
#   .. code-block:: cmake
#
#     rr_product(
#       <argument_of_"rr_preject"_command>...)
#
#   参见：
#
#   - :command:`rr_project`
#
macro(rr_product)
  rr_project(${ARGV})
  set(PRODUCT_AUTHORS       ${PROJECT_AUTHORS})
  set(PRODUCT_BINARY_DIR    "${PROJECT_BINARY_DIR}")
  set(PRODUCT_DESCRIPTION   "${PROJECT_DESCRIPTION}")
  set(PRODUCT_HOMEPAGE_URL  "${PROJECT_HOMEPAGE_URL}")
  set(PRODUCT_LICENSE       "${PROJECT_LICENSE}")
  set(PRODUCT_NAME          "${PROJECT_NAME}")
  set(PRODUCT_NAME_LOWER    "${PROJECT_NAME_LOWER}")
  set(PRODUCT_NAME_UPPER    "${PROJECT_NAME_UPPER}")
  set(PRODUCT_SOURCE_DIR    "${PROJECT_SOURCE_DIR}")
  set(PRODUCT_VERSION       "${PROJECT_VERSION}")
  set(PRODUCT_VERSION_MAJOR "${PROJECT_VERSION_MAJOR}")
  set(PRODUCT_VERSION_MINOR "${PROJECT_VERSION_MINOR}")
  set(PRODUCT_VERSION_PATCH "${PROJECT_VERSION_PATCH}")
  set(PRODUCT_VERSION_TWEAK "${PROJECT_VERSION_TWEAK}")
endmacro()

#.rst:
# .. command:: rr_product_extra
#
#   为避免“No project() command is present. ......”开发者警告，提供 ``rr_product`` 命令的附加版命令。
#
#   .. code-block:: cmake
#
#     project(
#       <argument_of_"preject"_command>...)
#     rr_product_extra(
#       [TIME_AS_VERSION]
#       [AUTHORS <author>...]
#       [LICENSE <license>])
#
#   参见：
#
#   - :command:`rr_product`
#
macro(rr_product_extra)
  rr_project_extra(${ARGV})
  set(PRODUCT_AUTHORS       ${PROJECT_AUTHORS})
  set(PRODUCT_BINARY_DIR    "${PROJECT_BINARY_DIR}")
  set(PRODUCT_DESCRIPTION   "${PROJECT_DESCRIPTION}")
  set(PRODUCT_HOMEPAGE_URL  "${PROJECT_HOMEPAGE_URL}")
  set(PRODUCT_LICENSE       "${PROJECT_LICENSE}")
  set(PRODUCT_NAME          "${PROJECT_NAME}")
  set(PRODUCT_NAME_LOWER    "${PROJECT_NAME_LOWER}")
  set(PRODUCT_NAME_UPPER    "${PROJECT_NAME_UPPER}")
  set(PRODUCT_SOURCE_DIR    "${PROJECT_SOURCE_DIR}")
  set(PRODUCT_VERSION       "${PROJECT_VERSION}")
  set(PRODUCT_VERSION_MAJOR "${PROJECT_VERSION_MAJOR}")
  set(PRODUCT_VERSION_MINOR "${PROJECT_VERSION_MINOR}")
  set(PRODUCT_VERSION_PATCH "${PROJECT_VERSION_PATCH}")
  set(PRODUCT_VERSION_TWEAK "${PROJECT_VERSION_TWEAK}")
endmacro()
