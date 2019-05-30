# ______ _           _ _____ _   _____ _____              __ _
# |  ___(_)         | |  _  | | |  ___/  __ \            / _(_)
# | |_   _ _ __   __| | | | | |_|___ \| /  \/ ___  _ __ | |_ _  __ _
# |  _| | | '_ \ / _` | | | | __|   \ \ |    / _ \| '_ \|  _| |/ _` |
# | |   | | | | | (_| \ \/' / |_/\__/ / \__/\ (_) | | | | | | | (_| |
# \_|   |_|_| |_|\__,_|\_/\_\\__\____/ \____/\___/|_| |_|_| |_|\__, |
# zhengrr                                                       __/ |
# 2016-10-21 – 2019-05-29                                      |___/
# Unlicense

cmake_minimum_required(VERSION 3.12)
cmake_policy(VERSION 3.12)

include_guard()

if(NOT COMMAND find_package_handle_standard_args)
  include(FindPackageHandleStandardArgs)
endif()

if(NOT COMMAND get_address_model_tag)
  include("${CMAKE_CURRENT_LIST_DIR}/rrCMake/LibraryTag.cmake")
endif()

#.rst:
# FindQt5Config
# -------------
#
# Find the `Qt5 <https://qt.io/>`_ CMake packages config.
#
# Result Variables
# ^^^^^^^^^^^^^^^^
#
# This module defines the following variables:
#
# ``Qt5Config_FOUND``
#   Found the Qt5 CMake packages config.
#
# ``Qt5Config_PREFIX_PATH``
#   The directory containing the Qt5 CMake packages config.
#
# Cache variables
# ^^^^^^^^^^^^^^^
#
# The following cache variables may also be set:
#
# ``Qt5_ROOT``
#   The root directory of the Qt5 installation (may also be set as an environment variable)::
#
#     v Qt5_ROOT
#       > bin
#       > doc
#       > include
#       v lib
#         v cmake
#           v Qt5
#               Qt5Config.cmake
#               ...
#           > Qt5AxBase
#           > ...
#           libEGL.lib
#           ...
#       > mkspecs
#       > ...

if(Qt5Config_FOUND)
  return()
endif()

# hints
get_address_model_tag(sTag)
set(zHints "${Qt5_${sTag}_ROOT}" "$ENV{Qt5_${sTag}_ROOT}" "$ENV{QTDIR${sTag}}"
           "${Qt5_ROOT}"         "$ENV{Qt5_ROOT}"         "$ENV{QTDIR}")

# prefix
find_path(Qt5Config_PREFIX_PATH
  NAMES "lib/cmake/Qt5/Qt5Config.cmake"
  HINTS ${zHints}
  NO_DEFAULT_PATH)
mark_as_advanced(Qt5Config_PREFIX_PATH)

# package
find_package_handle_standard_args(
  Qt5Config
  DEFAULT_MSG
  Qt5Config_PREFIX_PATH)

if(Qt5Config_FOUND)
  # append
  if(NOT Qt5Config_PREFIX_PATH IN_LIST CMAKE_PREFIX_PATH)
    list(APPEND CMAKE_PREFIX_PATH "${Qt5Config_PREFIX_PATH}")
  endif()
  mark_as_advanced(FORCE Qt5_ROOT)

else()
  # hints
  set(Qt5_ROOT "${Qt5_ROOT}" CACHE PATH "The root directory of the Qt5 installation.")
  mark_as_advanced(CLEAR Qt5_ROOT)

endif()
