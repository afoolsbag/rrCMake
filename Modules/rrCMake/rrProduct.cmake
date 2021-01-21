# zhengrr
# 2016-10-08 – 2021-01-21
# Unlicense

cmake_minimum_required(VERSION 3.10)
cmake_policy(VERSION 3.10)

include_guard()  # 3.10

if(NOT COMMAND rr_project OR NOT COMMAND rr_project_extra)
  include("${CMAKE_CURRENT_LIST_DIR}/rrProject.cmake")
endif()

#[=======================================================================[.rst:
.. command:: _rrproduct_set_product_variables

  内部命令：设置产品变量。

  .. code-block:: cmake

    _rrproduct_set_product_variables()

  参见：

  - :command:`rr_project`
  - `PROJECT_BINARY_DIR <https://cmake.org/cmake/help/latest/variable/PROJECT_BINARY_DIR.html>`_
  - `PROJECT_DESCRIPTION <https://cmake.org/cmake/help/latest/variable/PROJECT_DESCRIPTION.html>`_
  - `PROJECT_HOMEPAGE_URL <https://cmake.org/cmake/help/latest/variable/PROJECT_HOMEPAGE_URL.html>`_
  - `PROJECT_NAME <https://cmake.org/cmake/help/latest/variable/PROJECT_NAME.html>`_
  - `PROJECT_SOURCE_DIR <https://cmake.org/cmake/help/latest/variable/PROJECT_SOURCE_DIR.html>`_
  - `PROJECT_VERSION <https://cmake.org/cmake/help/latest/variable/PROJECT_VERSION.html>`_
  - `PROJECT_VERSION_MAJOR <https://cmake.org/cmake/help/latest/variable/PROJECT_VERSION_MAJOR.html>`_
  - `PROJECT_VERSION_MINOR <https://cmake.org/cmake/help/latest/variable/PROJECT_VERSION_MINOR.html>`_
  - `PROJECT_VERSION_PATCH <https://cmake.org/cmake/help/latest/variable/PROJECT_VERSION_PATCH.html>`_
  - `PROJECT_VERSION_TWEAK <https://cmake.org/cmake/help/latest/variable/PROJECT_VERSION_TWEAK.html>`_

#]=======================================================================]
macro(_rrproduct_set_product_variables)
  #
  # 前置断言
  #

  if(NOT ${ARGC} EQUAL 0)
    message(FATAL_ERROR "Incorrect number of arguments: ${ARGV} (${ARGC}).")
  endif()

  #
  # 业务逻辑
  #

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

#[=======================================================================[.rst:
.. command:: rr_product

  基于 ``rr_project`` 命令，设定产品（product）属性。

  .. code-block:: cmake

    rr_product(
      <argument-of-"rr_project"-command>...)

  参见：

  - :command:`rr_project`

#]=======================================================================]
macro(rr_product)
  rr_project(${ARGV})
  _rrproduct_set_product_variables()
endmacro()

#[=======================================================================[.rst:
.. command:: rr_product_extra

  为避免
  
  ::

    CMake Warning (dev) in CMakeLists.txt:
      No project() command is present.  The top-level CMakeLists.txt file must
      contain a literal, direct call to the project() command.  Add a line of
      code such as

        project(ProjectName)

      near the top of the file, but after cmake_minimum_required().

      CMake is pretending there is a "project(Project)" command on the first
      line.
    This warning is for project developers.  Use -Wno-dev to suppress it.

  开发者警告，提供 ``rr_product`` 命令的缀加版。

  .. code-block:: cmake

    project(
      ...)
    rr_product_extra(
      <argument-of-"rr_project_extra"-command>...)

  参见：

  - :command:`rr_product`
  - :command:`rr_project_extra`

#]=======================================================================]
macro(rr_product_extra)
  rr_project_extra(${ARGV})
  _rrproduct_set_product_variables()
endmacro()
