# ______ _           _  ___                  _____
# |  ___(_)         | |/ _ \                /  __ \
# | |_   _ _ __   __| / /_\ \_   ___ __ ___ | /  \/_ __  _ __
# |  _| | | '_ \ / _` |  _  \ \ / / '__/ _ \| |   | '_ \| '_ \
# | |   | | | | | (_| | | | |\ V /| | | (_) | \__/\ |_) | |_) |
# \_|   |_|_| |_|\__,_\_| |_/ \_/ |_|  \___/ \____/ .__/| .__/
# zhengrr                                         | |   | |
# 2018-04-02 – 2019-09-16                         |_|   |_|
# Unlicense

cmake_minimum_required(VERSION 3.12)
cmake_policy(VERSION 3.12)

include_guard()  # 3.10

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
# FindAvroCpp
# -----------
#
# Find the `Apache Avro <https://avro.apache.org/>`_ C++ headers, libraries and executables.
#
# IMPORTED Targets
# ^^^^^^^^^^^^^^^^
#
# This module defines the following :prop_tgt:`IMPORTED` targets:
#
# ``AvroCpp::avrocpp``
#   The avrocpp library, if found.
#
# ``AvroCpp::avrogencpp``
#   The avrogencpp executable, if found.
#
# Result Variables
# ^^^^^^^^^^^^^^^^
#
# This module defines the following variables:
#
# ``AvroCpp_FOUND``
#   Found the Avro C++.
#
# Cache variables
# ^^^^^^^^^^^^^^^
#
# The following cache variables may also be set:
#
# ``AvroCpp_ROOT``
#   The root directory of the Avro C++ installation (may also be set as an environment variable)::
#
#     v AvroCpp_ROOT
#       v vc141x32
#         v bin
#             avrogencpp.exe
#             boost_program_options-vc141-mt-x32-1_70.dll
#             boost_regex-vc141-mt-x32-1_70.dll
#             concrt140.dll
#             msvcp140.dll
#             vcruntime140.dll
#         v include
#           v avro
#               AvroSerialize.hh
#               ...
#         v lib
#             avrocpp.dll
#             avrocpp.lib
#             avrocpp_s.lib
#             boost_bzip2-vc141-mt-x32-1_70.dll
#             boost_iostreams-vc141-mt-x32-1_70.dll
#             boost_zlib-vc141-mt-x32-1_70.dll
#       > vc141x32d
#       > vc141x64
#       > vc141x64d
#       > ...

if(AvroCpp_FOUND)
  return()
endif()

#-------------------------------------------------------------------------------
# UNIX-like

if(UNIX)
endif()

#-------------------------------------------------------------------------------
# Windows

find_package(
  Boost 1.38 REQUIRED
  COMPONENTS filesystem iostreams program_options regex system)

if(WIN32)
  get_toolset_architecture_address_model_tag(sTag)

  # <prefix>/[s]bin
  find_program(
    AvroCpp_avrogencpp_EXECUTABLE
    NAMES "avrogencpp"
    HINTS "${AvroCpp_ROOT}/${sTag}d/bin"
          "$ENV{AvroCpp_ROOT}/${sTag}d/bin"
          "${AvroCpp_ROOT}/${sTag}/bin"
          "$ENV{AvroCpp_ROOT}/${sTag}/bin"
          "${AvroCpp_ROOT}/bin"
          "$ENV{AvroCpp_ROOT}/bin"
    NO_DEFAULT_PATH)
  mark_as_advanced(AvroCpp_avrogencpp_EXECUTABLE)

  # <prefix>/include
  find_path(
    AvroCpp_INCLUDE_DIR
    NAMES "avro/AvroSerialize.hh"
    HINTS "${AvroCpp_ROOT}/${sTag}d/include"
          "$ENV{AvroCpp_ROOT}/${sTag}d/include"
          "${AvroCpp_ROOT}/${sTag}/include"
          "$ENV{AvroCpp_ROOT}/${sTag}/include"
          "${AvroCpp_ROOT}/include"
          "$ENV{AvroCpp_ROOT}/include"
    NO_DEFAULT_PATH)
  mark_as_advanced(AvroCpp_INCLUDE_DIR)

  # <prefix>/lib
  find_library(
    AvroCpp_avrocpp_LIBRARY_DEBUG
    NAMES "avrocpp"
    HINTS "${AvroCpp_ROOT}/${sTag}d/lib"
          "$ENV{AvroCpp_ROOT}/${sTag}d/lib"
          "${AvroCpp_ROOT}/${sTag}/lib"
          "$ENV{AvroCpp_ROOT}/${sTag}/lib"
          "${AvroCpp_ROOT}/lib"
          "$ENV{AvroCpp_ROOT}/lib"
    NO_DEFAULT_PATH)
  mark_as_advanced(AvroCpp_avrocpp_LIBRARY_DEBUG)
  find_file(
    AvroCpp_avrocpp_LIBRARY_DEBUG_DLL
    NAMES "avrocpp.dll"
    HINTS "${AvroCpp_ROOT}/${sTag}d/lib"
          "$ENV{AvroCpp_ROOT}/${sTag}d/lib"
          "${AvroCpp_ROOT}/${sTag}/lib"
          "$ENV{AvroCpp_ROOT}/${sTag}/lib"
          "${AvroCpp_ROOT}/lib"
          "$ENV{AvroCpp_ROOT}/lib"
    NO_DEFAULT_PATH)
  mark_as_advanced(AvroCpp_avrocpp_LIBRARY_DEBUG_DLL)
  find_library(
    AvroCpp_avrocpp_LIBRARY_RELEASE
    NAMES "avrocpp"
    HINTS "${AvroCpp_ROOT}/${sTag}/lib"
          "$ENV{AvroCpp_ROOT}/${sTag}/lib"
          "${AvroCpp_ROOT}/lib"
          "$ENV{AvroCpp_ROOT}/lib"
    NO_DEFAULT_PATH)
  mark_as_advanced(AvroCpp_avrocpp_LIBRARY_RELEASE)
  find_file(
    AvroCpp_avrocpp_LIBRARY_RELEASE_DLL
    NAMES "avrocpp.dll"
    HINTS "${AvroCpp_ROOT}/${sTag}/lib"
          "$ENV{AvroCpp_ROOT}/${sTag}/lib"
          "${AvroCpp_ROOT}/lib"
          "$ENV{AvroCpp_ROOT}/lib"
    NO_DEFAULT_PATH)
  mark_as_advanced(AvroCpp_avrocpp_LIBRARY_RELEASE_DLL)

  find_library(
    AvroCpp_avrocpp_s_LIBRARY_DEBUG
    NAMES "avrocpp_s"
    HINTS "${AvroCpp_ROOT}/${sTag}d/lib"
          "$ENV{AvroCpp_ROOT}/${sTag}d/lib"
          "${AvroCpp_ROOT}/${sTag}/lib"
          "$ENV{AvroCpp_ROOT}/${sTag}/lib"
          "${AvroCpp_ROOT}/lib"
          "$ENV{AvroCpp_ROOT}/lib"
    NO_DEFAULT_PATH)
  mark_as_advanced(AvroCpp_avrocpp_s_LIBRARY_DEBUG)
  find_library(
    AvroCpp_avrocpp_s_LIBRARY_RELEASE
    NAMES "avrocpp_s"
    HINTS "${AvroCpp_ROOT}/${sTag}/lib"
          "$ENV{AvroCpp_ROOT}/${sTag}/lib"
          "${AvroCpp_ROOT}/lib"
          "$ENV{AvroCpp_ROOT}/lib"
    NO_DEFAULT_PATH)
  mark_as_advanced(AvroCpp_avrocpp_s_LIBRARY_RELEASE)

  # package
  find_package_handle_standard_args(
    AvroCpp
    DEFAULT_MSG
    AvroCpp_avrocpp_LIBRARY_RELEASE
    AvroCpp_avrogencpp_EXECUTABLE
    AvroCpp_INCLUDE_DIR
    AvroCpp_avrocpp_LIBRARY_DEBUG
    AvroCpp_avrocpp_LIBRARY_DEBUG_DLL
    AvroCpp_avrocpp_LIBRARY_RELEASE_DLL
    AvroCpp_avrocpp_s_LIBRARY_DEBUG
    AvroCpp_avrocpp_s_LIBRARY_RELEASE)

  if(AvroCpp_FOUND)
    # targets
    if(NOT TARGET AvroCpp::avrogencpp)
      add_executable_ex(
        AvroCpp::avrogencpp IMPORTED
        PROPERTIES          IMPORTED_LOCATION "${AvroCpp_avrogencpp_EXECUTABLE}")
    endif()

    if(NOT TARGET AvroCpp::avrocpp)
      add_library_ex(
        AvroCpp::avrocpp SHARED IMPORTED
        PROPERTIES          IMPORTED_IMPLIB_DEBUG     "${AvroCpp_avrocpp_LIBRARY_DEBUG}"
                            IMPORTED_LOCATION_DEBUG   "${AvroCpp_avrocpp_LIBRARY_DEBUG_DLL}"
                            IMPORTED_IMPLIB_RELEASE   "${AvroCpp_avrocpp_LIBRARY_RELEASE}"
                            IMPORTED_LOCATION_RELEASE "${AvroCpp_avrocpp_LIBRARY_RELEASE_DLL}"
        INCLUDE_DIRECTORIES INTERFACE                 "${AvroCpp_INCLUDE_DIR}"
        LINK_LIBRARIES      INTERFACE                 Boost::boost)
    endif()

    if(NOT TARGET AvroCpp::avrocpp_s)
      add_library_ex(
        AvroCpp::avrocpp_s STATIC IMPORTED
        PROPERTIES          IMPORTED_LOCATION_DEBUG   "${AvroCpp_avrocpp_s_LIBRARY_DEBUG}"
                            IMPORTED_LOCATION_RELEASE "${AvroCpp_avrocpp_s_LIBRARY_RELEASE}"
        INCLUDE_DIRECTORIES INTERFACE                 "${AvroCpp_INCLUDE_DIR}")
    endif()

    mark_as_advanced(FORCE AvroCpp_ROOT)

  else()
    # hints
    set(AvroCpp_ROOT "${AvroCpp_ROOT}" CACHE PATH "The root directory of the Avro C++ installation.")
    mark_as_advanced(CLEAR AvroCpp_ROOT)

  endif()

endif()
