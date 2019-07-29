# ______ _           _ _____  _____
# |  ___(_)         | /  ___||____ |
# | |_   _ _ __   __| \ `--.     / /
# |  _| | | '_ \ / _` |`--. \    \ \ zhengrr
# | |   | | | | | (_| /\__/ /.___/ / 2019-07-29 – 2019-07-29
# \_|   |_|_| |_|\__,_\____/ \____/  Unlicense

cmake_minimum_required(VERSION 3.12)
cmake_policy(VERSION 3.12)

include_guard()

if(NOT COMMAND find_package_handle_standard_args)
  include(FindPackageHandleStandardArgs)
endif()

if(NOT COMMAND add_library_ex)
  include("${CMAKE_CURRENT_LIST_DIR}/rrCMake/AddLibrary.cmake")
endif()

if(NOT COMMAND get_toolset_architecture_address_model_tag)
  include("${CMAKE_CURRENT_LIST_DIR}/rrCMake/LibraryTag.cmake")
endif()

#.rst:
# FindS3
# ------
#
# Find the `S3 <https://github.com/bji/libs3>`_ headers and libraries.
#
# IMPORTED Targets
# ^^^^^^^^^^^^^^^^
#
# This module defines the following :prop_tgt:`IMPORTED` targets:
#
# ``S3::s3``
#   The s3 library, if found.
#
# Result Variables
# ^^^^^^^^^^^^^^^^
#
# This module defines the following variables:
#
# ``S3_FOUND``
#   Found the S3.
#

if(S3_FOUND)
  return()
endif()

#-------------------------------------------------------------------------------
# UNIX-like

if(UNIX)
  # <prefix>/include
  find_path(
    S3_INCLUDE_DIR
    NAMES "libs3.h")
  mark_as_advanced(S3_INCLUDE_DIR)

  # <prefix>/lib
  find_library(
    S3_s3_LIBRARY
    NAMES "s3")
  mark_as_advanced(S3_s3_LIBRARY)

  # package
  find_package_handle_standard_args(
    S3
    DEFAULT_MSG
    S3_s3_LIBRARY
    S3_INCLUDE_DIR)

  if(S3_FOUND)
    # targets
    if(NOT TARGET S3::s3)
      add_library_ex(
        S3::s3              SHARED IMPORTED
        PROPERTIES          IMPORTED_LOCATION "${S3_s3_LIBRARY}"
        INCLUDE_DIRECTORIES INTERFACE         "${S3_INCLUDE_DIR}")
    endif()

  endif()

endif()
