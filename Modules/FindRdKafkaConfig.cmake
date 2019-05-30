# ______ _           _______    _ _   __       __ _         _____              __ _
# |  ___(_)         | | ___ \  | | | / /      / _| |       /  __ \            / _(_)
# | |_   _ _ __   __| | |_/ /__| | |/ /  __ _| |_| | ____ _| /  \/ ___  _ __ | |_ _  __ _
# |  _| | | '_ \ / _` |    // _` |    \ / _` |  _| |/ / _` | |    / _ \| '_ \|  _| |/ _` |
# | |   | | | | | (_| | |\ \ (_| | |\  \ (_| | | |   < (_| | \__/\ (_) | | | | | | | (_| |
# \_|   |_|_| |_|\__,_\_| \_\__,_\_| \_/\__,_|_| |_|\_\__,_|\____/\___/|_| |_|_| |_|\__, |
# zhengrr                                                                            __/ |
# 2019-05-29 – 2019-05-29                                                           |___/
# Unlicense

cmake_minimum_required(VERSION 3.12)
cmake_policy(VERSION 3.12)

include_guard()

if(NOT COMMAND find_package_handle_standard_args)
  include(FindPackageHandleStandardArgs)
endif()

if(NOT COMMAND get_toolset_architecture_address_model_tag)
  include("${CMAKE_CURRENT_LIST_DIR}/rrCMake/LibraryTag.cmake")
endif()

#.rst:
# FindRdKafkaConfig
# -----------------
#
# Find the `librdkafka <https://github.com/edenhill/librdkafka>`_ CMake package config.
#
# Result Variables
# ^^^^^^^^^^^^^^^^
#
# This module defines the following variables:
#
# ``RdKafkaConfig_FOUND``
#   Found the librdkafka CMake package config.
#
# Cache variables
# ^^^^^^^^^^^^^^^
#
# The following cache variables may also be set:
#
# ``RdKafka_ROOT``
#   The root directory of the libkafka installation (may also be set as an environment variable)::
#
#     v RdKafka_ROOT
#       v vc141x32
#         > bin
#         > include
#         v lib
#           v cmake
#             v RdKafka
#                 RdKafkaConfig.cmake
#                 ...
#           > pkgconfig
#             ...
#         > share
#       > vc141x64
#       > ...
#       > bin
#       > include
#       > lib
#       > share
if(RdKafkaConfig_FOUND)
  return()
endif()

# hints
set(zHints "${RdKafka_ROOT}" "$ENV{RdKafka_ROOT}")

# suffixs
get_toolset_architecture_address_model_tag(sTag)
set(zSuffixs "${sTag}" "")

# prefix
find_path(
  RdKafkaConfig_PREFIX_PATH
  NAMES         "lib/cmake/RdKafka/RdKafkaConfig.cmake"
  HINTS         ${zHints}
  PATH_SUFFIXES ${zSuffixs}
  NO_DEFAULT_PATH)
mark_as_advanced(RdKafkaConfig_PREFIX_PATH)

# package
find_package_handle_standard_args(
  RdKafkaConfig
  DEFAULT_MSG
  RdKafkaConfig_PREFIX_PATH)

if(RdKafkaConfig_FOUND)
  # append
  if(NOT RdKafkaConfig_PREFIX_PATH IN_LIST CMAKE_PREFIX_PATH)
    list(APPEND CMAKE_PREFIX_PATH "${RdKafkaConfig_PREFIX_PATH}")
  endif()
  mark_as_advanced(FORCE RdKafka_ROOT)

else()
  # hints
  set(RdKafka_ROOT "${RdKafka_ROOT}" CACHE PATH "The root directory of the RdKafka installation.")
  mark_as_advanced(CLEAR RdKafka_ROOT)

endif()
