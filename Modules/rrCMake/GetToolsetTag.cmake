# zhengrr
# 2018-06-06 – 2019-11-19
# Unlicense

cmake_minimum_required(VERSION 3.10)
cmake_policy(VERSION 3.10)

include_guard()  # 3.10

if(NOT COMMAND check_name_with_cmake_rules)
  include("${CMAKE_CURRENT_LIST_DIR}/CheckNameWithCMakeRules.cmake")
endif()

#===============================================================================
#.rst:
# .. command:: get_toolset_tag
#
#   获取工具集标签（get toolset tag）。
#
#   .. code-block:: cmake
#
#     get_toolset_tag(
#       <variable>
#     )
#
#   参见：
#
#   - :command:`check_name_with_cmake_rules`
#   - `<https://boost.org/doc/libs/master/more/getting_started/windows.html#library-naming>`_
#   - `<https://gitlab.kitware.com/cmake/cmake/blob/master/Modules/FindBoost.cmake>`_
function(get_toolset_tag xVariable)
  check_name_with_cmake_rules("${xVariable}" AUTHOR_WARNING)

  get_cmake_property(zLangs ENABLED_LANGUAGES)
  foreach(sLang IN LISTS zLangs)

    if(CMAKE_${sLang}_COMPILER_ID STREQUAL "Intel")
      if(WIN32)
        set("${xVariable}" "iw" PARENT_SCOPE)
      else()
        set("${xVariable}" "il" PARENT_SCOPE)
      endif()
      return()
    endif()

    if(GHS-MULTI)
      set("${xVariable}" "ghs" PARENT_SCOPE)
      return()
    endif()

    if(MSVC)
      if(80 LESS_EQUAL MSVC_TOOLSET_VERSION)
        set("${xVariable}" "vc${MSVC_TOOLSET_VERSION}" PARENT_SCOPE)
      elseif(1310 LESS_EQUAL MSVC_VERSION)
        set("${xVariable}" "vc71" PARENT_SCOPE)
      elseif(1300 LESS_EQUAL MSVC_VERSION)
        set("${xVariable}" "vc7" PARENT_SCOPE)
      elseif(1200 LESS_EQUAL MSVC_VERSION)
        set("${xVariable}" "vc6" PARENT_SCOPE)
      else()
        set("${xVariable}" "vc" PARENT_SCOPE)
      endif()
      return()
    endif()

    if(BORLAND)
      set("${xVariable}" "bcb" PARENT_SCOPE)
      return()
    endif()

    if(CMAKE_${sLang}_COMPILER_ID STREQUAL "SunPro")
      set("${xVariable}" "sw" PARENT_SCOPE)
      return()
    endif()

    if(CMAKE_${sLang}_COMPILER_ID STREQUAL "XL")
      set("${xVariable}" "xlc" PARENT_SCOPE)
      return()
    endif()

    if(MINGW)
      string(REGEX REPLACE "([0-9]+)\\.([0-9]+)(\\.[0-9]+)?" "\\1\\2" sVer "${CMAKE_${sLang}_COMPILER_VERSION}")
      set("${xVariable}" "mgw${sVer}" PARENT_SCOPE)
      return()
    endif()

    if(UNIX AND CMAKE_${sLang}_COMPILER_ID STREQUAL "GNU")
      string(REGEX REPLACE "([0-9]+)\\.([0-9]+)(\\.[0-9]+)?" "\\1\\2" sVer "${CMAKE_${sLang}_COMPILER_VERSION}")
      if(APPLE)
        set("${xVariable}" "xgcc${sVer}" PARENT_SCOPE)
      else()
        set("${xVariable}" "gcc${sVer}" PARENT_SCOPE)
      endif()
      return()
    endif()

    if(UNIX AND CMAKE_${sLang}_COMPILER_ID STREQUAL "Clang")
      string(REGEX REPLACE "([0-9]+)\\.([0-9]+)(\\.[0-9]+)?" "\\1\\2" sVer "${CMAKE_${sLang}_COMPILER_VERSION}")
      set("${xVariable}" "clang${sVer}" PARENT_SCOPE)
      return()
    endif()

  endforeach()
  set("${xVariable}" "" PARENT_SCOPE)
endfunction()
