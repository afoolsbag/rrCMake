# ______ _           _____________
# |  ___(_)         | |  ___|  ___|
# | |_   _ _ __   __| | |_  | |_ _ __ ___  _ __   ___  __ _
# |  _| | | '_ \ / _` |  _| |  _| '_ ` _ \| '_ \ / _ \/ _` |
# | |   | | | | | (_| | |   | | | | | | | | |_) |  __/ (_| |
# \_|   |_|_| |_|\__,_\_|   \_| |_| |_| |_| .__/ \___|\__, |
# zhengrr                                 | |          __/ |
# 2019-08-19 – 2019-08-19                 |_|         |___/
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

#.rst:
# FindFFmpeg
# ------
#
# Find the `FFmpeg <https://ffmpeg.org/>`_ headers and libraries.
#
# IMPORTED Targets
# ^^^^^^^^^^^^^^^^
#
# This module defines the following :prop_tgt:`IMPORTED` targets:
#
# ``FFmpeg::avcodec``
#   The avcodec library, if found.
#
# ``FFmpeg::avdevice``
#   The avdevice library, if found.
#
# ``FFmpeg::libavfilter``
#   The libavfilter library, if found.
#
# ``FFmpeg::avformat``
#   The avformat library, if found.
#
# ``FFmpeg::avutil``
#   The avutil library, if found.
#
# ``FFmpeg::postproc``
#   The postproc library, if found.
#
# ``FFmpeg::swresample``
#   The swresample library, if found.
#
# ``FFmpeg::swscale``
#   The swscale library, if found.
#
# Result Variables
# ^^^^^^^^^^^^^^^^
#
# This module defines the following variables:
#
# ``FFmpeg_FOUND``
#   Found the FFmpeg.
#
# Cache variables
# ^^^^^^^^^^^^^^^
#
# The following cache variables may also be set:
#
# ``FFmpeg_ROOT``
#   The root directory of the FFmpeg installation (may also be set as an environment variable)::
#
#     v FFmpeg_ROOT
#       > bin
#       > doc
#       > examples
#       > include
#       > lib
#       > presets

if(FFmpeg_FOUND)
  return()
endif()

#-------------------------------------------------------------------------------
# UNIX-like

if(UNIX)
# <prefix>/include
find_path(
    FFmpeg_avcodec_INCLUDE_DIR
    NAMES "libavcodec/avcodec.h")
  mark_as_advanced(FFmpeg_avcodec_INCLUDE_DIR)

  find_path(
    FFmpeg_avdevice_INCLUDE_DIR
    NAMES "libavdevice/avdevice.h")
  mark_as_advanced(FFmpeg_avdevice_INCLUDE_DIR)
  
  find_path(
    FFmpeg_avfilter_INCLUDE_DIR
    NAMES "libavfilter/avfilter.h")
  mark_as_advanced(FFmpeg_avfilter_INCLUDE_DIR)
  
  find_path(
    FFmpeg_avformat_INCLUDE_DIR
    NAMES "libavformat/avformat.h")
  mark_as_advanced(FFmpeg_avformat_INCLUDE_DIR)
  
  find_path(
    FFmpeg_avutil_INCLUDE_DIR
    NAMES "libavutil/avutil.h")
  mark_as_advanced(FFmpeg_avutil_INCLUDE_DIR)
  
  find_path(
    FFmpeg_postproc_INCLUDE_DIR
    NAMES "libpostproc/postprocess.h")
  mark_as_advanced(FFmpeg_postproc_INCLUDE_DIR)
  
  find_path(
    FFmpeg_swresample_INCLUDE_DIR
    NAMES "libswresample/swresample.h")
  mark_as_advanced(FFmpeg_swresample_INCLUDE_DIR)
  
  find_path(
    FFmpeg_swscale_INCLUDE_DIR
    NAMES "libswscale/swscale.h")
  mark_as_advanced(FFmpeg_swscale_INCLUDE_DIR)

  # <prefix>/lib
  find_library(
    FFmpeg_avcodec_LIBRARY
    NAMES "avcodec")
  mark_as_advanced(FFmpeg_avcodec_LIBRARY)

  find_library(
    FFmpeg_avdevice_LIBRARY
    NAMES "avdevice")
  mark_as_advanced(FFmpeg_avdevice_LIBRARY)

  find_library(
    FFmpeg_avfilter_LIBRARY
    NAMES "avfilter")
  mark_as_advanced(FFmpeg_avfilter_LIBRARY)
  
  find_library(
    FFmpeg_avformat_LIBRARY
    NAMES "avformat")
  mark_as_advanced(FFmpeg_avformat_LIBRARY)
  
  find_library(
    FFmpeg_avutil_LIBRARY
    NAMES "avutil")
  mark_as_advanced(FFmpeg_avutil_LIBRARY)
  
  find_library(
    FFmpeg_postproc_LIBRARY
    NAMES "postproc")
  mark_as_advanced(FFmpeg_postproc_LIBRARY)
  
  find_library(
    FFmpeg_swresample_LIBRARY
    NAMES "swresample")
  mark_as_advanced(FFmpeg_swresample_LIBRARY)
  
  find_library(
    FFmpeg_swscale_LIBRARY
    NAMES "swscale")
  mark_as_advanced(FFmpeg_swscale_LIBRARY)

  # package
  find_package_handle_standard_args(
    FFmpeg
    DEFAULT_MSG
    FFmpeg_avcodec_LIBRARY
    FFmpeg_avcodec_INCLUDE_DIR
    FFmpeg_avdevice_INCLUDE_DIR
    FFmpeg_avfilter_INCLUDE_DIR
    FFmpeg_avformat_INCLUDE_DIR
    FFmpeg_avutil_INCLUDE_DIR
    FFmpeg_postproc_INCLUDE_DIR
    FFmpeg_swresample_INCLUDE_DIR
    FFmpeg_swscale_INCLUDE_DIR
    FFmpeg_avdevice_LIBRARY
    FFmpeg_avfilter_LIBRARY
    FFmpeg_avformat_LIBRARY
    FFmpeg_avutil_LIBRARY
    FFmpeg_postproc_LIBRARY
    FFmpeg_swresample_LIBRARY
    FFmpeg_swscale_LIBRARY)

  if(FFmpeg_FOUND)
    # targets
    if(NOT TARGET FFmpeg::avcodec)
      add_library_ex(
        FFmpeg::avcodec SHARED IMPORTED
        PROPERTIES          IMPORTED_LOCATION "${FFmpeg_avcodec_LIBRARY}"
        INCLUDE_DIRECTORIES INTERFACE         "${FFmpeg_avcodec_INCLUDE_DIR}"
        LINK_LIBRARIES      INTERFACE         FFmpeg::avutil)
    endif()

    if(NOT TARGET FFmpeg::avdevice)
      add_library_ex(
        FFmpeg::avdevice SHARED IMPORTED
        PROPERTIES          IMPORTED_LOCATION "${FFmpeg_avdevice_LIBRARY}"
        INCLUDE_DIRECTORIES INTERFACE         "${FFmpeg_avdevice_INCLUDE_DIR}"
        LINK_LIBRARIES      INTERFACE         FFmpeg::avformat)
    endif()

    if(NOT TARGET FFmpeg::avfilter)
      add_library_ex(
        FFmpeg::avfilter SHARED IMPORTED
        PROPERTIES          IMPORTED_LOCATION "${FFmpeg_avfilter_LIBRARY}"
        INCLUDE_DIRECTORIES INTERFACE         "${FFmpeg_avfilter_INCLUDE_DIR}"
        LINK_LIBRARIES      INTERFACE         FFmpeg::avutil)
    endif()

    if(NOT TARGET FFmpeg::avformat)
      add_library_ex(
        FFmpeg::avformat SHARED IMPORTED
        PROPERTIES          IMPORTED_LOCATION "${FFmpeg_avformat_LIBRARY}"
        INCLUDE_DIRECTORIES INTERFACE         "${FFmpeg_avformat_INCLUDE_DIR}"
        LINK_LIBRARIES      INTERFACE         FFmpeg::avcodec)
    endif()

    if(NOT TARGET FFmpeg::avutil)
      add_library_ex(
        FFmpeg::avutil SHARED IMPORTED
        PROPERTIES          IMPORTED_LOCATION "${FFmpeg_avutil_LIBRARY}"
        INCLUDE_DIRECTORIES INTERFACE         "${FFmpeg_avutil_INCLUDE_DIR}")
    endif()

    if(NOT TARGET FFmpeg::postproc)
      add_library_ex(
        FFmpeg::postproc SHARED IMPORTED
        PROPERTIES          IMPORTED_LOCATION "${FFmpeg_postproc_LIBRARY}"
        INCLUDE_DIRECTORIES INTERFACE         "${FFmpeg_postproc_INCLUDE_DIR}")
    endif()

    if(NOT TARGET FFmpeg::swresample)
      add_library_ex(
        FFmpeg::swresample SHARED IMPORTED
        PROPERTIES          IMPORTED_LOCATION "${FFmpeg_swresample_LIBRARY}"
        INCLUDE_DIRECTORIES INTERFACE         "${FFmpeg_swresample_INCLUDE_DIR}"
        LINK_LIBRARIES      INTERFACE         FFmpeg::avutil)
    endif()

    if(NOT TARGET FFmpeg::swscale)
      add_library_ex(
        FFmpeg::swscale SHARED IMPORTED
        PROPERTIES          IMPORTED_LOCATION "${FFmpeg_swscale_LIBRARY}"
        INCLUDE_DIRECTORIES INTERFACE         "${FFmpeg_swscale_INCLUDE_DIR}"
        LINK_LIBRARIES      INTERFACE         FFmpeg::avutil)
    endif()

    mark_as_advanced(FORCE FFmpeg_ROOT)

  else()
    # hints
    set(FFmpeg_ROOT "${FFmpeg_ROOT}" CACHE PATH "The root directory of the FFmpeg installation.")
    mark_as_advanced(CLEAR FFmpeg_ROOT)

  endif()

endif()

#-------------------------------------------------------------------------------
# Windows

if(WIN32)
  # <prefix>/[s]bin
  find_path(
    FFmpeg_avcodec_LIBRARY_DLL
    NAMES         "avcodec-58.dll"
    PATH_SUFFIXES "bin")
  mark_as_advanced(FFmpeg_avcodec_LIBRARY_DLL)

  find_path(
    FFmpeg_avdevice_LIBRARY_DLL
    NAMES         "avdevice-58.dll"
    PATH_SUFFIXES "bin")
  mark_as_advanced(FFmpeg_avdevice_LIBRARY_DLL)
  
  find_path(
    FFmpeg_avfilter_LIBRARY_DLL
    NAMES         "avfilter-7.dll"
    PATH_SUFFIXES "bin")
  mark_as_advanced(FFmpeg_avfilter_LIBRARY_DLL)
  
  find_path(
    FFmpeg_avformat_LIBRARY_DLL
    NAMES         "avformat-58.dll"
    PATH_SUFFIXES "bin")
  mark_as_advanced(FFmpeg_avformat_LIBRARY_DLL)
  
  find_path(
    FFmpeg_avutil_LIBRARY_DLL
    NAMES         "avutil-56.dll"
    PATH_SUFFIXES "bin")
  mark_as_advanced(FFmpeg_avutil_LIBRARY_DLL)
  
  find_path(
    FFmpeg_postproc_LIBRARY_DLL
    NAMES         "postproc-55.dll"
    PATH_SUFFIXES "bin")
  mark_as_advanced(FFmpeg_postproc_LIBRARY_DLL)
  
  find_path(
    FFmpeg_swresample_LIBRARY_DLL
    NAMES         "swresample-3.dll"
    PATH_SUFFIXES "bin")
  mark_as_advanced(FFmpeg_swresample_LIBRARY_DLL)
  
  find_path(
    FFmpeg_swscale_LIBRARY_DLL
    NAMES         "swscale-5.dll"
    PATH_SUFFIXES "bin")
  mark_as_advanced(FFmpeg_swscale_LIBRARY_DLL)

  # <prefix>/include
  find_path(
    FFmpeg_avcodec_INCLUDE_DIR
    NAMES "libavcodec/avcodec.h")
  mark_as_advanced(FFmpeg_avcodec_INCLUDE_DIR)

  find_path(
    FFmpeg_avdevice_INCLUDE_DIR
    NAMES "libavdevice/avdevice.h")
  mark_as_advanced(FFmpeg_avdevice_INCLUDE_DIR)
  
  find_path(
    FFmpeg_avfilter_INCLUDE_DIR
    NAMES "libavfilter/avfilter.h")
  mark_as_advanced(FFmpeg_avfilter_INCLUDE_DIR)
  
  find_path(
    FFmpeg_avformat_INCLUDE_DIR
    NAMES "libavformat/avformat.h")
  mark_as_advanced(FFmpeg_avformat_INCLUDE_DIR)
  
  find_path(
    FFmpeg_avutil_INCLUDE_DIR
    NAMES "libavutil/avutil.h")
  mark_as_advanced(FFmpeg_avutil_INCLUDE_DIR)
  
  find_path(
    FFmpeg_postproc_INCLUDE_DIR
    NAMES "libpostproc/postprocess.h")
  mark_as_advanced(FFmpeg_postproc_INCLUDE_DIR)
  
  find_path(
    FFmpeg_swresample_INCLUDE_DIR
    NAMES "libswresample/swresample.h")
  mark_as_advanced(FFmpeg_swresample_INCLUDE_DIR)
  
  find_path(
    FFmpeg_swscale_INCLUDE_DIR
    NAMES "libswscale/swscale.h")
  mark_as_advanced(FFmpeg_swscale_INCLUDE_DIR)

  # <prefix>/lib
  find_library(
    FFmpeg_avcodec_LIBRARY
    NAMES "avcodec")
  mark_as_advanced(FFmpeg_avcodec_LIBRARY)

  find_library(
    FFmpeg_avdevice_LIBRARY
    NAMES "avdevice")
  mark_as_advanced(FFmpeg_avdevice_LIBRARY)

  find_library(
    FFmpeg_avfilter_LIBRARY
    NAMES "avfilter")
  mark_as_advanced(FFmpeg_avfilter_LIBRARY)
  
  find_library(
    FFmpeg_avformat_LIBRARY
    NAMES "avformat")
  mark_as_advanced(FFmpeg_avformat_LIBRARY)
  
  find_library(
    FFmpeg_avutil_LIBRARY
    NAMES "avutil")
  mark_as_advanced(FFmpeg_avutil_LIBRARY)
  
  find_library(
    FFmpeg_postproc_LIBRARY
    NAMES "postproc")
  mark_as_advanced(FFmpeg_postproc_LIBRARY)
  
  find_library(
    FFmpeg_swresample_LIBRARY
    NAMES "swresample")
  mark_as_advanced(FFmpeg_swresample_LIBRARY)
  
  find_library(
    FFmpeg_swscale_LIBRARY
    NAMES "swscale")
  mark_as_advanced(FFmpeg_swscale_LIBRARY)

  # package
  find_package_handle_standard_args(
    FFmpeg
    DEFAULT_MSG
    FFmpeg_avcodec_LIBRARY
    FFmpeg_avcodec_LIBRARY_DLL
    FFmpeg_avdevice_LIBRARY_DLL
    FFmpeg_avfilter_LIBRARY_DLL
    FFmpeg_avformat_LIBRARY_DLL
    FFmpeg_avutil_LIBRARY_DLL
    FFmpeg_postproc_LIBRARY_DLL
    FFmpeg_swresample_LIBRARY_DLL
    FFmpeg_swscale_LIBRARY_DLL
    FFmpeg_avcodec_INCLUDE_DIR
    FFmpeg_avdevice_INCLUDE_DIR
    FFmpeg_avfilter_INCLUDE_DIR
    FFmpeg_avformat_INCLUDE_DIR
    FFmpeg_avutil_INCLUDE_DIR
    FFmpeg_postproc_INCLUDE_DIR
    FFmpeg_swresample_INCLUDE_DIR
    FFmpeg_swscale_INCLUDE_DIR
    FFmpeg_avdevice_LIBRARY
    FFmpeg_avfilter_LIBRARY
    FFmpeg_avformat_LIBRARY
    FFmpeg_avutil_LIBRARY
    FFmpeg_postproc_LIBRARY
    FFmpeg_swresample_LIBRARY
    FFmpeg_swscale_LIBRARY)

  if(FFmpeg_FOUND)
    # targets
    if(NOT TARGET FFmpeg::avcodec)
      add_library_ex(
        FFmpeg::avcodec SHARED IMPORTED
        PROPERTIES          IMPORTED_IMPLIB   "${FFmpeg_avcodec_LIBRARY}"
                            IMPORTED_LOCATION "${FFmpeg_avcodec_LIBRARY_DLL}"
        INCLUDE_DIRECTORIES INTERFACE         "${FFmpeg_avcodec_INCLUDE_DIR}"
        LINK_LIBRARIES      INTERFACE         FFmpeg::avutil)
    endif()

    if(NOT TARGET FFmpeg::avdevice)
      add_library_ex(
        FFmpeg::avdevice SHARED IMPORTED
        PROPERTIES          IMPORTED_IMPLIB   "${FFmpeg_avdevice_LIBRARY}"
                            IMPORTED_LOCATION "${FFmpeg_avdevice_LIBRARY_DLL}"
        INCLUDE_DIRECTORIES INTERFACE         "${FFmpeg_avdevice_INCLUDE_DIR}"
        LINK_LIBRARIES      INTERFACE         FFmpeg::avformat)
    endif()

    if(NOT TARGET FFmpeg::avfilter)
      add_library_ex(
        FFmpeg::avfilter SHARED IMPORTED
        PROPERTIES          IMPORTED_IMPLIB   "${FFmpeg_avfilter_LIBRARY}"
                            IMPORTED_LOCATION "${FFmpeg_avfilter_LIBRARY_DLL}"
        INCLUDE_DIRECTORIES INTERFACE         "${FFmpeg_avfilter_INCLUDE_DIR}"
        LINK_LIBRARIES      INTERFACE         FFmpeg::avutil)
    endif()

    if(NOT TARGET FFmpeg::avformat)
      add_library_ex(
        FFmpeg::avformat SHARED IMPORTED
        PROPERTIES          IMPORTED_IMPLIB   "${FFmpeg_avformat_LIBRARY}"
                            IMPORTED_LOCATION "${FFmpeg_avformat_LIBRARY_DLL}"
        INCLUDE_DIRECTORIES INTERFACE         "${FFmpeg_avformat_INCLUDE_DIR}"
        LINK_LIBRARIES      INTERFACE         FFmpeg::avcodec)
    endif()

    if(NOT TARGET FFmpeg::avutil)
      add_library_ex(
        FFmpeg::avutil SHARED IMPORTED
        PROPERTIES          IMPORTED_IMPLIB   "${FFmpeg_avutil_LIBRARY}"
                            IMPORTED_LOCATION "${FFmpeg_avutil_LIBRARY_DLL}"
        INCLUDE_DIRECTORIES INTERFACE         "${FFmpeg_avutil_INCLUDE_DIR}")
    endif()

    if(NOT TARGET FFmpeg::postproc)
      add_library_ex(
        FFmpeg::postproc SHARED IMPORTED
        PROPERTIES          IMPORTED_IMPLIB   "${FFmpeg_postproc_LIBRARY}"
                            IMPORTED_LOCATION "${FFmpeg_postproc_LIBRARY_DLL}"
        INCLUDE_DIRECTORIES INTERFACE         "${FFmpeg_postproc_INCLUDE_DIR}")
    endif()

    if(NOT TARGET FFmpeg::swresample)
      add_library_ex(
        FFmpeg::swresample SHARED IMPORTED
        PROPERTIES          IMPORTED_IMPLIB   "${FFmpeg_swresample_LIBRARY}"
                            IMPORTED_LOCATION "${FFmpeg_swresample_LIBRARY_DLL}"
        INCLUDE_DIRECTORIES INTERFACE         "${FFmpeg_swresample_INCLUDE_DIR}"
        LINK_LIBRARIES      INTERFACE         FFmpeg::avutil)
    endif()

    if(NOT TARGET FFmpeg::swscale)
      add_library_ex(
        FFmpeg::swscale SHARED IMPORTED
        PROPERTIES          IMPORTED_IMPLIB   "${FFmpeg_swscale_LIBRARY}"
                            IMPORTED_LOCATION "${FFmpeg_swscale_LIBRARY_DLL}"
        INCLUDE_DIRECTORIES INTERFACE         "${FFmpeg_swscale_INCLUDE_DIR}"
        LINK_LIBRARIES      INTERFACE         FFmpeg::avutil)
    endif()

    mark_as_advanced(FORCE FFmpeg_ROOT)

  else()
    # hints
    set(FFmpeg_ROOT "${FFmpeg_ROOT}" CACHE PATH "The root directory of the FFmpeg installation.")
    mark_as_advanced(CLEAR FFmpeg_ROOT)

  endif()

endif()
