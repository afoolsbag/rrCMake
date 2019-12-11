# zhengrr
# 2016-10-08 – 2019-12-11
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

#.rst
# .. command:: aux_source_directory_con
#
#   搜集目录中的源文件（aux source directory），遵循惯例（convention）。
#
#   .. code-block:: cmake
#
#     aux_source_directory_con(
#       <argument-of-aux_source_directory_ex>...
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
#
function(aux_source_directory_con _DIRECTORY _VARIABLE)
  set(zOptKws    C
                 CFG
                 CXX
                 MFC
                 QT)
  set(zOneValKws)
  set(zMutValKws EXTENSIONS)
  cmake_parse_arguments(PARSE_ARGV 2 "" "${zOptKws}" "${zOneValKws}" "${zMutValKws}")

  #
  # 参数规整
  #

  # aux_source_directory_ex: <directory>
  set(pDirectory "${_DIRECTORY}")

  # aux_source_directory_ex: <variable>
  set(xVariable "${_VARIABLE}")
  check_name_with_cmake_rules("${xVariable}" AUTHOR_WARNING)

  # aux_source_directory_ex: [EXTENSIONS <extension...>] [other-arguments...]
  set(zExtensions ${_EXTENSIONS})

  # <argument-of-aux_source_directory_ex>...
  set(zArgumentsOfAuxSourceDirectoryEx ${_UNPARSED_ARGUMENTS})

  # [C] [CXX] [MFC] [QT] [CFG]
  set(bC   "${_C}")
  set(bCxx "${_CXX}")
  set(bMfc "${_MFC}")
  set(bQt  "${_QT}")
  set(bCfg "${_CFG}")

  # [PCH_NAME <pch-name>]
  unset(sPchName)
  if(DEFINED _PCH_NAME)
    set(sPchName ${_PCH_NAME})
  elseif(bMfc)
    set(sPchName ${PROJECT_NAME})
  endif()

  # [PCH_HEADER <pch-header>]
  unset(sPchHeader)
  if(DEFINED _PCH_HEADER)
    set(sPchHeader ${_PCH_HEADER})
  elseif(bMfc)
    set(sPchHeader "stdafx.h")
  endif()

  # [PCH_SOURCE <pch-source>]
  unset(sPchSource)
  if(DEFINED _PCH_SOURCE)
    set(sPchSource ${_PCH_HEADER})
  elseif(bMfc)
    set(sPchSource "stdafx.cpp")
  endif()

  #
  # 扩展名
  #

  if(bC)
    list(INSERT zExtensions 0 ".h"   ".c"   ".inl")
  endif()

  if(bCxx)
    list(INSERT zExtensions 0 ".hpp" ".hxx" ".hp"  ".hh"  ".h++" ".H"   ".h"
                              ".cpp" ".cxx" ".cp"  ".cc"  ".c++" ".C"
                              ".tpp" ".txx" ".tp"         ".t++"        ".inc"
                                                                        ".inl")
  endif()

  if(bMfc)
    list(INSERT zExtensions 0 ".h"   ".cpp"
                              ".rc"  ".rc2" ".bmp" ".cur" ".ico")
  endif()

  if(bQt)
    list(INSERT zExtensions 0 ".h"   ".cpp" ".ui"
                              ".qrc" ".qml" ".ts")
  endif()

  if(bCfg)
    list(INSERT zExtensions 0 ".in"  ".dox" ".md")
  endif()

  #
  # 搜集源文件
  #

  aux_source_directory_ex(
    "${pDirectory}" zSrcFiles
    ${zArgumentsOfAuxSourceDirectoryEx}
    EXTENSIONS      ${zExtensions})

  #
  # 预编译头
  #

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

  #
  # 收尾
  #

  set("${xVariable}" ${zSrcFiles} PARENT_SCOPE)

endfunction()
