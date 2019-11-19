# zhengrr
# 2016-10-08 – 2019-11-19
# Unlicense

cmake_minimum_required(VERSION 3.14)
cmake_policy(VERSION 3.14)

include_guard()  # 3.10

if(NOT COMMAND aux_source_directory_ex)
  include("${CMAKE_CURRENT_LIST_DIR}/AuxSourceDirectoryEx.cmake")
endif()
if(NOT COMMAND check_name_with_cmake_rules)
  include("${CMAKE_CURRENT_LIST_DIR}/CheckNameWithCMakeRules.cmake")
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
#       <argument-of-aux-source-directory-ex...>
#       [C] [CXX] [MFC] [QT] [CFG]
#       [PCH_NAME   <pch-name>}]
#       [PCH_HEADER <pch-header>]
#       [PCH_SOURCE <pch-source>]
#     )
#
#   参见：
#
#   - :command:`aux_source_directory_con`
#   - :command:`check_name_with_cmake_rules`
function(aux_source_directory_con _DIRECTORY _VARIABLE)
  set(zOptKws    C CXX MFC QT CFG)
  set(zOneValKws)
  set(zMutValKws EXTENSIONS)
  cmake_parse_arguments(PARSE_ARGV 2 "" "${zOptKws}" "${zOneValKws}" "${zMutValKws}")

  #-----------------------------------------------------------------------------
  # 规整化参数

  # DIRECTORY
  set(pDirectory "${_DIRECTORY}")

  # VARIABLE
  set(xVariable "${_VARIABLE}")
  check_name_with_cmake_rules("${xVariable}" AUTHOR_WARNING)

  # EXTENSIONS
  set(zExtensions ${_EXTENSIONS})

  # C / CXX / MFC / QT / CFG
  set(bC   "${_C}")
  set(bCxx "${_CXX}")
  set(bMfc "${_MFC}")
  set(bQt  "${_QT}")
  set(bCfg "${_CFG}")

  # PCH_NAME / PCH_HEADER / PCH_SOURCE
  if(bMfc)

    if(DEFINED _PCH_NAME)
      set(sPchName ${_PCH_NAME})
    else()
      set(sPchName ${PROJECT_NAME})
    endif()

    if(DEFINED _PCH_HEADER)
      set(sPchHeader ${_PCH_HEADER})
    else()
      set(sPchHeader "stdafx.h")
    endif()

    if(DEFINED _PCH_SOURCE)
      set(sPchSource ${_PCH_HEADER})
    else()
      set(sPchSource "stdafx.cpp")
    endif()

  endif()

  # UNPARSED_ARGUMENTS
  set(zArgumentsOfAuxSourceDirectoryEx ${_UNPARSED_ARGUMENTS})

  #-----------------------------------------------------------------------------
  # 惯例

  # 扩展名
  if(bC)
    list(APPEND zExtensions ".h"   ".c"   ".inl")
  endif()
  if(bCxx)
    list(APPEND zExtensions ".hpp" ".hxx" ".hp"  ".hh"  ".h++" ".H"   ".h"
                            ".cpp" ".cxx" ".cp"  ".cc"  ".c++" ".C"
                            ".tpp" ".txx" ".tp"         ".t++"        ".inc"
                                                                      ".inl")
  endif()
  if(bMfc)
    list(APPEND zExtensions ".h"   ".cpp"
                            ".rc"  ".rc2" ".bmp" ".cur" ".ico")
  endif()
  if(bQt)
    list(APPEND zExtensions ".h"   ".cpp" ".ui"
                            ".qrc" ".qml" ".ts")
  endif()
  if(bCfg)
    list(APPEND zExtensions ".in"  ".dox" ".md")
  endif()
  list(REMOVE_DUPLICATES zExtensions)

  # 搜集源文件
  aux_source_directory_ex(
    "${pDirectory}" zSrcFiles
    ${zArgumentsOfAuxSourceDirectoryEx}
    EXTENSIONS      ${zExtensions})

  # 预编译头
  if(sPchName AND sPchHeader AND sPchSource)
    set(pPchFile "${CMAKE_CURRENT_BINARY_DIR}/${sPchName}$<$<CONFIG:Debug>:d>.pch")
    foreach(pFile ${zSrcFiles})
      if(NOT pFile MATCHES [[.*\.(c|cpp|cc|cxx|cp|CPP|C|c\+\+)$]])
        continue()
      endif()
      get_filename_component(sName "${pFile}" NAME)
      if(sName STREQUAL sPchSource)
        set_source_files_properties(
          "${pFile}"
          PROPERTIES COMPILE_FLAGS  "/Yc\"${sPchHeader}\" /Fp\"${pPchFile}\""
                     OBJECT_OUTPUTS "${pPchFile}")
      else()
        set_source_files_properties(
          "${pFile}"
          PROPERTIES COMPILE_FLAGS  "/Yu\"${sPchHeader}\" /FI\"${sPchHeader}\" /Fp\"${pPchFile}\""
                     OBJECT_DEPENDS "${pPchFile}")
      endif()
    endforeach()
  endif()

  # 返回结果
  set("${xVariable}" ${zSrcFiles} PARENT_SCOPE)

endfunction()
