# ______ _           _______    _ _   __       __ _
# |  ___(_)         | | ___ \  | | | / /      / _| |
# | |_   _ _ __   __| | |_/ /__| | |/ /  __ _| |_| | ____ _
# |  _| | | '_ \ / _` |    // _` |    \ / _` |  _| |/ / _` | zhengrr
# | |   | | | | | (_| | |\ \ (_| | |\  \ (_| | | |   < (_| | 2019-06-03 – 2019-07-30
# \_|   |_|_| |_|\__,_\_| \_\__,_\_| \_/\__,_|_| |_|\_\__,_| Unlicense

cmake_minimum_required(VERSION 3.12)
cmake_policy(VERSION 3.12)

include_guard()

if(NOT COMMAND find_package_handle_standard_args)
  include(FindPackageHandleStandardArgs)
endif()

if(NOT COMMAND add_library_ex)
  include("${CMAKE_CURRENT_LIST_DIR}/rrCMake/AddLibrary.cmake")
endif()

#.rst:
# FindRdKafka
# -----------
#
# Find the `RdKafka <https://github.com/edenhill/librdkafka>`_ headers and libraries.
#
# IMPORTED Targets
# ^^^^^^^^^^^^^^^^
#
# This module defines the following :prop_tgt:`IMPORTED` targets:
#
# ``RdKafka::rdkafka``
#   The rdkafka library, if found.
#
# ``RdKafka::rdkafka++``
#   The rdkafka++ library, if found.
#
# Result Variables
# ^^^^^^^^^^^^^^^^
#
# This module defines the following variables:
#
# ``RdKafka_FOUND``
#   Found the RdKafka.
#

if(RdKafka_FOUND)
  return()
endif()

#-------------------------------------------------------------------------------
# UNIX-like

if(UNIX)
  # <prefix>/include
  find_path(
    RdKafka_INCLUDE_DIR
    NAMES "librdkafka/rdkafka.h"
          "librdkafka/rdkafkacpp.h")
  mark_as_advanced(RdKafka_INCLUDE_DIR)

  # <prefix>/lib
  find_library(
    RdKafka_rdkafka_LIBRARY
    NAMES "rdkafka")
  mark_as_advanced(RdKafka_rdkafka_LIBRARY)

  find_library(
    RdKafka_rdkafka++_LIBRARY
    NAMES "rdkafka++")
  mark_as_advanced(RdKafka_rdkafka++_LIBRARY)

  # package
  find_package_handle_standard_args(
    RdKafka
    DEFAULT_MSG
    RdKafka_rdkafka_LIBRARY
    RdKafka_INCLUDE_DIR
    RdKafka_rdkafka++_LIBRARY)

  # targets
  if(RdKafka_FOUND)
    if(NOT TARGET RdKafka::rdkafka)
      add_library_ex(
        RdKafka::rdkafka    SHARED IMPORTED
        PROPERTIES          IMPORTED_LOCATION "${RdKafka_rdkafka_LIBRARY}"
        INCLUDE_DIRECTORIES INTERFACE         "${RdKafka_INCLUDE_DIR}")
    endif()

    if(NOT TARGET RdKafka::rdkafka++)
      add_library_ex(
        RdKafka::rdkafka++  SHARED IMPORTED
        PROPERTIES          IMPORTED_LOCATION "${RdKafka_rdkafka++_LIBRARY}"
        INCLUDE_DIRECTORIES INTERFACE         "${RdKafka_INCLUDE_DIR}"
        LINK_LIBRARIES      INTERFACE         RdKafka::rdkafka++)
    endif()

  endif()

endif()
