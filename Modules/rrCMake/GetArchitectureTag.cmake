# zhengrr
# 2018-06-06 – 2019-11-18
# Unlicense

cmake_minimum_required(VERSION 3.10)
cmake_policy(VERSION 3.10)

include_guard()  # 3.10

#===============================================================================
#.rst:
# .. command:: get_architecture_tag
#
#   获取架构标签（get architecture tag）。
#
#   .. code-block:: cmake
#
#     get_architecture_tag(
#       <variable>
#     )
#
#   参见：
#
#   - `<https://boost.org/doc/libs/master/more/getting_started/windows.html#library-naming>`_
#   - `<https://gitlab.kitware.com/cmake/cmake/blob/master/Modules/FindBoost.cmake>`_
function(get_architecture_tag xVariable)
  get_cmake_property(zLangs ENABLED_LANGUAGES)
  foreach(sLang IN LISTS zLangs)

    if(CMAKE_${sLang}_COMPILER_ARCHITECTURE_ID STREQUAL "IA64")
      set("${xVariable}" "i" PARENT_SCOPE)
      return()
    endif()

    if(CMAKE_${sLang}_COMPILER_ARCHITECTURE_ID STREQUAL "X86" OR
       CMAKE_${sLang}_COMPILER_ARCHITECTURE_ID STREQUAL "x64")
      set("${xVariable}" "x" PARENT_SCOPE)
      return()
    endif()

    if(CMAKE_${sLang}_COMPILER_ARCHITECTURE_ID MATCHES "^ARM")
      set("${xVariable}" "a" PARENT_SCOPE)
      return()
    endif()

    if(CMAKE_${sLang}_COMPILER_ARCHITECTURE_ID STREQUAL "MIPS")
      set("${xVariable}" "m" PARENT_SCOPE)
      return()
    endif()

  endforeach()
  set("${xVariable}" "" PARENT_SCOPE)
endfunction()
