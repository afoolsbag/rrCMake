# zhengrr
# 2016-10-08 – 2019-11-20
# Unlicense

cmake_minimum_required(VERSION 3.10)
cmake_policy(VERSION 3.10)

include_guard()  # 3.10

if(NOT COMMAND project_ex)
  include("${CMAKE_CURRENT_LIST_DIR}/ProjectEx.cmake")
endif()

#.rst:
# .. command:: product_ex
#
#   设定产品属性（product），扩展功能（extend）。
#
#   .. code-block:: cmake
#
#     product_ex(
#       <argument-of-preject_ex>...
#     )
#
#   参见：
#
#   - :command:`project_ex`
#
macro(product_ex)
  project_ex(${ARGV})
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
