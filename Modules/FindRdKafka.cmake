# ______ _           _______    _ _   __       __ _
# |  ___(_)         | | ___ \  | | | / /      / _| |
# | |_   _ _ __   __| | |_/ /__| | |/ /  __ _| |_| | ____ _
# |  _| | | '_ \ / _` |    // _` |    \ / _` |  _| |/ / _` | zhengrr
# | |   | | | | | (_| | |\ \ (_| | |\  \ (_| | | |   < (_| | 2019-06-03 – 2019-09-16
# \_|   |_|_| |_|\__,_\_| \_\__,_\_| \_/\__,_|_| |_|\_\__,_| Unlicense

cmake_minimum_required(VERSION 3.12)
cmake_policy(VERSION 3.12)

include_guard()  # 3.10

if(NOT COMMAND find_package_handle_standard_args)
  include(FindPackageHandleStandardArgs)
endif()

if(NOT COMMAND get_toolset_architecture_address_model_tag)
  include("${CMAKE_CURRENT_LIST_DIR}/rrCMake/LibraryTag.cmake")
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
# Cache variables
# ^^^^^^^^^^^^^^^
#
# The following cache variables may also be set:
#
# ``RdKafka_ROOT``
#   The root directory of the RdKafka installation (may also be set as an environment variable)::
#
#     v RdKafka_ROOT
#       v vc141x32
#         > bin
#         > include
#         > lib
#         > share
#       > vc141x64
#       > ...
#       > bin
#       > include
#       > lib
#       > share

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
    RdKafka_INCLUDE_DIR
    RdKafka_rdkafka_LIBRARY
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

#-------------------------------------------------------------------------------
# Windows

if(WIN32)
  get_toolset_architecture_address_model_tag(sTag)

  # <prefix>/[s]bin
  find_file(
    RdKafka_rdkafka_LIBRARY_DEBUG_DLL
    NAMES "rdkafka.dll"
    HINTS "${RdKafka_ROOT}/${sTag}d/bin"
          "$ENV{RdKafka_ROOT}/${sTag}d/bin"
          "${RdKafka_ROOT}/${sTag}/bin"
          "$ENV{RdKafka_ROOT}/${sTag}/bin"
          "${RdKafka_ROOT}/bin"
          "$ENV{RdKafka_ROOT}/bin"
    NO_DEFAULT_PATH)
  mark_as_advanced(RdKafka_rdkafka_LIBRARY_DEBUG_DLL)
  find_file(
    RdKafka_rdkafka_LIBRARY_RELEASE_DLL
    NAMES "rdkafka.dll"
    HINTS "${RdKafka_ROOT}/${sTag}/bin"
          "$ENV{RdKafka_ROOT}/${sTag}/bin"
          "${RdKafka_ROOT}/bin"
          "$ENV{RdKafka_ROOT}/bin"
    NO_DEFAULT_PATH)
  mark_as_advanced(RdKafka_rdkafka_LIBRARY_RELEASE_DLL)

  find_file(
    RdKafka_rdkafka++_LIBRARY_DEBUG_DLL
    NAMES "rdkafka++.dll"
    HINTS "${RdKafka_ROOT}/${sTag}d/bin"
          "$ENV{RdKafka_ROOT}/${sTag}d/bin"
          "${RdKafka_ROOT}/${sTag}/bin"
          "$ENV{RdKafka_ROOT}/${sTag}/bin"
          "${RdKafka_ROOT}/bin"
          "$ENV{RdKafka_ROOT}/bin"
    NO_DEFAULT_PATH)
  mark_as_advanced(RdKafka_rdkafka++_LIBRARY_DEBUG_DLL)
  find_file(
    RdKafka_rdkafka++_LIBRARY_RELEASE_DLL
    NAMES "rdkafka++.dll"
    HINTS "${RdKafka_ROOT}/${sTag}/bin"
          "$ENV{RdKafka_ROOT}/${sTag}/bin"
          "${RdKafka_ROOT}/bin"
          "$ENV{RdKafka_ROOT}/bin"
    NO_DEFAULT_PATH)
  mark_as_advanced(RdKafka_rdkafka++_LIBRARY_RELEASE_DLL)

  # <prefix>/include
  find_path(
    RdKafka_INCLUDE_DIR
    NAMES "librdkafka/rdkafka.h"
          "librdkafka/rdkafkacpp.h"
    HINTS "${RdKafka_ROOT}/${sTag}d/include"
          "$ENV{RdKafka_ROOT}/${sTag}d/include"
          "${RdKafka_ROOT}/${sTag}/include"
          "$ENV{RdKafka_ROOT}/${sTag}/include"
          "${RdKafka_ROOT}/include"
          "$ENV{RdKafka_ROOT}/include"
    NO_DEFAULT_PATH)
  mark_as_advanced(RdKafka_INCLUDE_DIR)

  # <prefix>/lib
  find_library(
    RdKafka_rdkafka_LIBRARY_DEBUG
    NAMES "rdkafka"
    HINTS "${RdKafka_ROOT}/${sTag}d/lib"
          "$ENV{RdKafka_ROOT}/${sTag}d/lib"
          "${RdKafka_ROOT}/${sTag}/lib"
          "$ENV{RdKafka_ROOT}/${sTag}/lib"
          "${RdKafka_ROOT}/lib"
          "$ENV{RdKafka_ROOT}/lib"
    NO_DEFAULT_PATH)
  mark_as_advanced(RdKafka_rdkafka_LIBRARY_DEBUG)
  find_library(
    RdKafka_rdkafka_LIBRARY_RELEASE
    NAMES "rdkafka"
    HINTS "${RdKafka_ROOT}/${sTag}/lib"
          "$ENV{RdKafka_ROOT}/${sTag}/lib"
          "${RdKafka_ROOT}/lib"
          "$ENV{RdKafka_ROOT}/lib"
    NO_DEFAULT_PATH)
  mark_as_advanced(RdKafka_rdkafka_LIBRARY_RELEASE)

  find_library(
    RdKafka_rdkafka++_LIBRARY_DEBUG
    NAMES "rdkafka++"
    HINTS "${RdKafka_ROOT}/${sTag}d/lib"
          "$ENV{RdKafka_ROOT}/${sTag}d/lib"
          "${RdKafka_ROOT}/${sTag}/lib"
          "$ENV{RdKafka_ROOT}/${sTag}/lib"
          "${RdKafka_ROOT}/lib"
          "$ENV{RdKafka_ROOT}/lib"
    NO_DEFAULT_PATH)
  mark_as_advanced(RdKafka_rdkafka++_LIBRARY_DEBUG)
  find_library(
    RdKafka_rdkafka++_LIBRARY_RELEASE
    NAMES "rdkafka++"
    HINTS "${RdKafka_ROOT}/${sTag}/lib"
          "$ENV{RdKafka_ROOT}/${sTag}/lib"
          "${RdKafka_ROOT}/lib"
          "$ENV{RdKafka_ROOT}/lib"
    NO_DEFAULT_PATH)
  mark_as_advanced(RdKafka_rdkafka++_LIBRARY_RELEASE)

  # package
  find_package_handle_standard_args(
    RdKafka
    DEFAULT_MSG
    RdKafka_rdkafka_LIBRARY_DEBUG_DLL
    RdKafka_rdkafka_LIBRARY_RELEASE_DLL
    RdKafka_rdkafka++_LIBRARY_DEBUG_DLL
    RdKafka_rdkafka++_LIBRARY_RELEASE_DLL
    RdKafka_INCLUDE_DIR
    RdKafka_rdkafka_LIBRARY_DEBUG
    RdKafka_rdkafka_LIBRARY_RELEASE
    RdKafka_rdkafka++_LIBRARY_DEBUG
    RdKafka_rdkafka++_LIBRARY_RELEASE)

  # targets
  if(RdKafka_FOUND)
    if(NOT TARGET RdKafka::rdkafka)
      add_library_ex(
        RdKafka::rdkafka    SHARED IMPORTED
        PROPERTIES          IMPORTED_IMPLIB_DEBUG     "${RdKafka_rdkafka_LIBRARY_DEBUG}"
                            IMPORTED_LOCATION_DEBUG   "${RdKafka_rdkafka_LIBRARY_DEBUG_DLL}"
                            IMPORTED_IMPLIB_RELEASE   "${RdKafka_rdkafka_LIBRARY_RELEASE}"
                            IMPORTED_LOCATION_RELEASE "${RdKafka_rdkafka_LIBRARY_RELEASE_DLL}"
        INCLUDE_DIRECTORIES INTERFACE                 "${RdKafka_INCLUDE_DIR}")
    endif()

    if(NOT TARGET RdKafka::rdkafka++)
      add_library_ex(
        RdKafka::rdkafka++  SHARED IMPORTED
        PROPERTIES          IMPORTED_IMPLIB_DEBUG     "${RdKafka_rdkafka++_LIBRARY_DEBUG}"
                            IMPORTED_LOCATION_DEBUG   "${RdKafka_rdkafka++_LIBRARY_DEBUG_DLL}"
                            IMPORTED_IMPLIB_RELEASE   "${RdKafka_rdkafka++_LIBRARY_RELEASE}"
                            IMPORTED_LOCATION_RELEASE "${RdKafka_rdkafka++_LIBRARY_RELEASE_DLL}"
        INCLUDE_DIRECTORIES INTERFACE                 "${RdKafka_INCLUDE_DIR}"
        LINK_LIBRARIES      INTERFACE                 RdKafka::rdkafka)
    endif()

  endif()

endif()
