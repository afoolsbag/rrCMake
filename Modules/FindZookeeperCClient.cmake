# ______ _           _  ______            _                             _____  _____ _ _            _   
# |  ___(_)         | ||___  /           | |                           /  __ \/  __ \ (_)          | |  
# | |_   _ _ __   __| |   / /  ___   ___ | | _____  ___ _ __   ___ _ __| /  \/| /  \/ |_  ___ _ __ | |_ 
# |  _| | | '_ \ / _` |  / /  / _ \ / _ \| |/ / _ \/ _ \ '_ \ / _ \ '__| |    | |   | | |/ _ \ '_ \| __|
# | |   | | | | | (_| |./ /__| (_) | (_) |   <  __/  __/ |_) |  __/ |  | \__/\| \__/\ | |  __/ | | | |_ 
# \_|   |_|_| |_|\__,_|\_____/\___/ \___/|_|\_\___|\___| .__/ \___|_|   \____/ \____/_|_|\___|_| |_|\__|
# zhengrr                                              | |                                              
# 2018-12-29 – 2019-07-08                              |_|                                              
# Unlicense

cmake_minimum_required(VERSION 3.12)
cmake_policy(VERSION 3.12)

include_guard()

if(NOT COMMAND find_package_handle_standard_args)
  include(FindPackageHandleStandardArgs)
endif()

if(NOT COMMAND add_executable_ex)
  include("${CMAKE_CURRENT_LIST_DIR}/rrCMake/AddExecutable.cmake")
endif()

if(NOT COMMAND add_library_ex)
  include("${CMAKE_CURRENT_LIST_DIR}/rrCMake/AddLibrary.cmake")
endif()

if(NOT COMMAND get_toolset_architecture_address_model_tag)
  include("${CMAKE_CURRENT_LIST_DIR}/rrCMake/LibraryTag.cmake")
endif()

#.rst:
# FindZookeeperCClient
# --------------------
#
# Find the `Apache Zookeeper <https://zookeeper.apache.org/>`_ C Client headers, libraries and executables.
#
# IMPORTED Targets
# ^^^^^^^^^^^^^^^^
#
# This module defines the following :prop_tgt:`IMPORTED` targets:
#
# ``ZookeeperCClient::cli``
#   The cli executable, if found.
#
# ``ZookeeperCClient::hashtable``
#   The hashtable library, if found.
#
# ``ZookeeperCClient::zookeeper``
#   The zookeeper library, if found.
#
# Result Variables
# ^^^^^^^^^^^^^^^^
#
# This module defines the following variables:
#
# ``ZookeeperCClient_FOUND``
#   Found the Apache Zookeeper C Client.
#
# Cache variables
# ^^^^^^^^^^^^^^^
#
# The following cache variables may also be set:
#
# ``ZookeeperCClient_ROOT``
#   The root directory of the Apache Zookeeper C Client installation (may also be set as an environment variable)::
#
#     v ZookeeperCClient_ROOT
#       v bin
#           cli.exe
#       v include
#         v zookeeper
#             zookeeper.h
#             ...
#       v lib
#         > vc141x32d
#         > ...
#           hashtable.lib
#           zookeeper.lib

if(ZookeeperCClient_FOUND)
  return()
endif()

#-------------------------------------------------------------------------------
# UNIX-like

if(UNIX)

  # <prefix>/[s]bin
  find_program(
    ZookeeperCClient_cli_EXECUTABLE
    NAMES         "cli_mt")
  mark_as_advanced(ZookeeperCClient_cli_EXECUTABLE)

  # <prefix>/include
  find_path(
    ZookeeperCClient_INCLUDE_DIR
    NAMES         "zookeeper/zookeeper.h")
  mark_as_advanced(ZookeeperCClient_INCLUDE_DIR)

  # <prefix>/lib
  find_library(
    ZookeeperCClient_zookeeper_LIBRARY
    NAMES         "zookeeper_mt")
  mark_as_advanced(ZookeeperCClient_zookeeper_LIBRARY)

  # package
  find_package_handle_standard_args(
    ZookeeperCClient
    DEFAULT_MSG
    ZookeeperCClient_zookeeper_LIBRARY
    ZookeeperCClient_INCLUDE_DIR)

  if(ZookeeperCClient_FOUND)
    # targets
    if(NOT TARGET ZookeeperCClient::cli)
      add_executable_ex(
        ZookeeperCClient::cli IMPORTED
        PROPERTIES            IMPORTED_LOCATION "${ZookeeperCClient_cli_EXECUTABLE}")
    endif()

    if(NOT TARGET ZookeeperCClient::zookeeper)
      add_library_ex(
        ZookeeperCClient::zookeeper SHARED IMPORTED
        PROPERTIES                  IMPORTED_LOCATION "${ZookeeperCClient_zookeeper_LIBRARY}"
        INCLUDE_DIRECTORIES         INTERFACE         "${ZookeeperCClient_INCLUDE_DIR}")
    endif()

  endif()

endif()

#-------------------------------------------------------------------------------
# Windows

if(WIN32)

  # <prefix>/[s]bin
  find_program(
    ZookeeperCClient_cli_EXECUTABLE
    NAMES         "cli")
  mark_as_advanced(ZookeeperCClient_cli_EXECUTABLE)

  # <prefix>/include
  find_path(
    ZookeeperCClient_INCLUDE_DIR
    NAMES         "zookeeper/zookeeper.h")
  mark_as_advanced(ZookeeperCClient_INCLUDE_DIR)

  # <prefix>/lib
  get_toolset_architecture_address_model_tag(sTag)

  find_library(
    ZookeeperCClient_hashtable_LIBRARY_DEBUG
    NAMES         "hashtable"
    PATH_SUFFIXES "${sTag}d" "${sTag}")
  mark_as_advanced(ZookeeperCClient_hashtable_LIBRARY_DEBUG)
  find_library(
    ZookeeperCClient_hashtable_LIBRARY_RELEASE
    NAMES         "hashtable"
    PATH_SUFFIXES "${sTag}")
  mark_as_advanced(ZookeeperCClient_hashtable_LIBRARY_RELEASE)

  find_library(
    ZookeeperCClient_zookeeper_LIBRARY_DEBUG
    NAMES         "zookeeper"
    PATH_SUFFIXES "${sTag}d" "${sTag}")
  mark_as_advanced(ZookeeperCClient_zookeeper_LIBRARY_DEBUG)
  find_library(
    ZookeeperCClient_zookeeper_LIBRARY_RELEASE
    NAMES         "zookeeper"
    PATH_SUFFIXES "${sTag}")
  mark_as_advanced(ZookeeperCClient_zookeeper_LIBRARY_RELEASE)

  # package
  find_package_handle_standard_args(
    ZookeeperCClient
    DEFAULT_MSG
    ZookeeperCClient_zookeeper_LIBRARY_RELEASE
    ZookeeperCClient_INCLUDE_DIR
    ZookeeperCClient_hashtable_LIBRARY_DEBUG
    ZookeeperCClient_hashtable_LIBRARY_RELEASE
    ZookeeperCClient_zookeeper_LIBRARY_DEBUG)

  if(ZookeeperCClient_FOUND)
    # targets
    if(NOT TARGET ZookeeperCClient::cli)
      add_executable_ex(
        ZookeeperCClient::cli IMPORTED
        PROPERTIES            IMPORTED_LOCATION "${ZookeeperCClient_cli_EXECUTABLE}")
    endif()

    if(NOT TARGET ZookeeperCClient::hashtable)
      add_library_ex(
        ZookeeperCClient::hashtable STATIC IMPORTED
        PROPERTIES                  IMPORTED_LOCATION_DEBUG   "${ZookeeperCClient_hashtable_LIBRARY_DEBUG}"
                                    IMPORTED_LOCATION_RELEASE "${ZookeeperCClient_hashtable_LIBRARY_RELEASE}"
        INCLUDE_DIRECTORIES         INTERFACE                 "${ZookeeperCClient_INCLUDE_DIR}")
    endif()

    if(NOT TARGET ZookeeperCClient::zookeeper)
      add_library_ex(
        ZookeeperCClient::zookeeper STATIC IMPORTED
        PROPERTIES                  IMPORTED_LOCATION_DEBUG   "${ZookeeperCClient_zookeeper_LIBRARY_DEBUG}"
                                    IMPORTED_LOCATION_RELEASE "${ZookeeperCClient_zookeeper_LIBRARY_RELEASE}"
        COMPILE_DEFINITIONS         INTERFACE                 "USE_STATIC_LIB"
        INCLUDE_DIRECTORIES         INTERFACE                 "${ZookeeperCClient_INCLUDE_DIR}"
        LINK_LIBRARIES              INTERFACE                 WS2_32
                                                              ZookeeperCClient::hashtable)
    endif()

    mark_as_advanced(FORCE ZookeeperCClient_ROOT)

  else()
    # hints
    set(ZookeeperCClient_ROOT "${ZookeeperCClient_ROOT}" CACHE PATH "The root directory of the Apache Zookeeper C Client installation.")
    mark_as_advanced(CLEAR ZookeeperCClient_ROOT)

  endif()

endif()
