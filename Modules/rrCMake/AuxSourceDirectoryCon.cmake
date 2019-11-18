# zhengrr
# 2016-10-08 – 2019-11-18
# Unlicense

cmake_minimum_required(VERSION 3.14)
cmake_policy(VERSION 3.14)

include_guard()  # 3.10

if(NOT COMMAND aux_source_directory_ex)
  include("${CMAKE_CURRENT_LIST_DIR}/AuxSourceDirectoryEx.cmake")
endif()

#===============================================================================
#.rst
# .. command:: aux_source_directory_con
#
#   搜集目录中的源文件（aux source directory），遵循惯例（convention）。
#
#   .. code-block:: cmake
#
#     aux_source_directory_con(
#       <arguments...>
#       [C] [CXX] [MFC] [QT] [CFG]
#       [PCH_NAME   <pch-name>}]
#       [PCH_HEADER <pch-header>]
#       [PCH_SOURCE <pch-source>]
#     )
#
#   参见：
#
#   - :command:`aux_source_directory_con`
function(aux_source_directory_con _DIRECTORY _VARIABLE)
  set(zOptKws    C CXX MFC QT CFG)
  set(zMutValKws EXTENSIONS)
  cmake_parse_arguments(PARSE_ARGV 2 "" "${zOptKws}" "" "${zMutValKws}")

  list(INSERT _EXTENSIONS 0 EXTENSIONS)
  if(_C)
    list(APPEND _EXTENSIONS ".h"   ".c"   ".inl")
  endif()
  if(_CXX)
    list(APPEND _EXTENSIONS ".hpp" ".cpp" ".hh"  ".cc"  ".hxx" ".cxx" ".hp"  ".cp"
                            ".HPP" ".CPP" ".H"   ".C"   ".h++" ".c++" ".h"   ".inl")
  endif()
  if(_MFC)
    list(APPEND _EXTENSIONS ".h"   ".cpp"
                            ".rc"  ".rc2" ".bmp" ".cur" ".ico")
  endif()
  if(_QT)
    list(APPEND _EXTENSIONS ".h"   ".cpp" ".ui"
                            ".qrc" ".qml" ".ts")
  endif()
  if(_CFG)
    list(APPEND _EXTENSIONS ".in"  ".dox" ".md")
  endif()
  list(REMOVE_DUPLICATES _EXTENSIONS)

  # aux_source_directory_ex
  aux_source_directory_ex(
    ${_DIRECTORY} ${_VARIABLE} ${_UNPARSED_ARGUMENTS}
    ${_EXPLICIT}
    ${_EXTENSIONS}
  )
  set(${_VARIABLE} ${${_VARIABLE}} PARENT_SCOPE)

  if(_MFC)
    if(NOT DEFINED _PCH_NAME)
      set(_PCH_NAME ${PROJECT_NAME})
    endif()
    if(NOT DEFINED _PCH_HEADER)
      set(_PCH_HEADER "stdafx.h")
    endif()
    if(NOT DEFINED _PCH_SOURCE)
      set(_PCH_SOURCE "stdafx.cpp")
    endif()
  endif()

  if(_PCH_NAME AND _PCH_HEADER AND _PCH_SOURCE)
    set(sPchFile "${CMAKE_CURRENT_BINARY_DIR}/${_PCH_NAME}$<$<CONFIG:Debug>:d>.pch")
    foreach(sFile ${${_VARIABLE}})
      if(NOT sFile MATCHES ".*\\.(c|cpp|cc|cxx|cp|CPP|C|c\\+\\+)$")
        continue()
      endif()
      get_filename_component(sName "${sFile}" NAME)
      if(sName STREQUAL _PCH_SOURCE)
        set_source_files_properties(
          ${sFile}
          PROPERTIES COMPILE_FLAGS  "/Yc\"${_PCH_HEADER}\" /Fp\"${sPchFile}\""
                     OBJECT_OUTPUTS "${sPchFile}")
      else()
        set_source_files_properties(
          ${sFile}
          PROPERTIES COMPILE_FLAGS  "/Yu\"${_PCH_HEADER}\" /FI\"${_PCH_HEADER}\" /Fp\"${sPchFile}\""
                     OBJECT_DEPENDS "${sPchFile}")
      endif()
    endforeach()
  endif()
endfunction()
