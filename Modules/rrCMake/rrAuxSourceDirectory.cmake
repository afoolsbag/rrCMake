# zhengrr
# 2016-10-08 – 2021-03-11
# Unlicense

cmake_minimum_required(VERSION 3.14)
cmake_policy(VERSION 3.14)

include_guard()  # 3.10

if(NOT COMMAND rr_check_cmake_name OR
   NOT COMMAND rr_check_fext_name)
  include("${CMAKE_CURRENT_LIST_DIR}/rrCheck.cmake")
endif()

#[=======================================================================[.rst:
.. command:: rr_aux_source_directory

  基于 ``aux_source_directory`` 命令，提供更多选项和功能。

  .. code-block:: cmake

    rr_aux_source_directory(
      <directory> <variable>
      [RECURES]
      [MATCHES    <regex>...]
      [CLASHES    <regex>...]
      [EXPLICIT]
      [EXTENSIONS <extension>...]
      [FLAT]
      [PREFIX     <group-prefix>]
      [PROPERTIES {<property-key> <property-value>}...])

  参见：

  - `aux_source_directory <https://cmake.org/cmake/help/latest/command/aux_source_directory.html>`_
  - `file <https://cmake.org/cmake/help/latest/command/file.html>`_
  - `source_group <https://cmake.org/cmake/help/latest/command/source_group.html>`_
  - `set_source_files_properties <https://cmake.org/cmake/help/latest/command/set_source_files_properties.html>`_

#]=======================================================================]
function(rr_aux_source_directory _DIRECTORY _VARIABLE)
  set(zOptKws    EXPLICIT
                 FLAT
                 RECURSE)
  set(zOneValKws PREFIX)
  set(zMutValKws CLASHES
                 EXTENSIONS
                 MATCHES
                 PROPERTIES)
  cmake_parse_arguments(PARSE_ARGV 2 "" "${zOptKws}" "${zOneValKws}" "${zMutValKws}")

  #
  # 参数规整
  #

  if(DEFINED _UNPARSED_ARGUMENTS)
    message(FATAL_ERROR "Unexpected arguments: ${_UNPARSED_ARGUMENTS}.")
  endif()

  # <directory>
  set(pDirectory "${_DIRECTORY}")
  if(NOT IS_ABSOLUTE "${pDirectory}")
    set(pDirectory "${CMAKE_CURRENT_SOURCE_DIR}/${pDirectory}")
  endif()
  if(NOT IS_DIRECTORY "${pDirectory}")
    message(WARNING "The argument isn't a directory: ${_DIRECTORY}.")
  endif()

  # <variable>
  set(xVariable "${_VARIABLE}")
  rr_check_cmake_name("${xVariable}" AUTHOR_WARNING)

  # [RECURES]
  if(_RECURSE)
    set(oRecurse GLOB_RECURSE)
  else()
    set(oRecurse GLOB)
  endif()

  # [MATCHES <regex>...]
  unset(zMatches)
  if(DEFINED _MATCHES)
    set(zMatches "${_MATCHES}")
  endif()

  # [CLASHES <regex>...]
  unset(zClashes)
  if(DEFINED _CLASHES)
    set(zClashes "${_CLASHES}")
  endif()

  # [EXPLICIT]
  set(bExplicit "${_EXPLICIT}")

  # [EXTENSIONS <extension...>]
  set(zExtensions ${_EXTENSIONS})
  foreach(sExt IN LISTS zExtensions)
    rr_check_fext_name("${sExt}" FATAL_ERROR)
  endforeach()

  # [FLAT]
  set(bFlat "${_FLAT}")

  # [PREFIX <group-prefix>]
  if(DEFINED _PREFIX)
    set(sPrefix "${_PREFIX}")
  else()
    set(sPrefix "/")
  endif()

  # [PROPERTIES < <property-key> <property-value> >...]
  unset(zProperties)
  if(DEFINED _PROPERTIES)
    list(LENGTH _PROPERTIES nLen)
    if(0 LESS nLen)
      set(zProperties ${_PROPERTIES})
    else()
      message(AUTHOR_WARNING "Keyword PROPERTIES is used, but without value, ignored.")
    endif()
  endif()

  #
  # 常见扩展名
  #

  if(NOT bExplicit)
    get_cmake_property(zLangs ENABLED_LANGUAGES)

    list(APPEND zExtensions ".in"   # 配置文件输入文件
                            ".dox"  # Doxygen 文档文件
                            ".md")  # Markdown 文档文件

    # C
    if(C IN_LIST zLangs)
      list(APPEND zExtensions ".h"    # 头文件
                              ".c"    # 源文件
                              ".inl") # 内联实现文件
    endif()

    # C++
    if(CXX IN_LIST zLangs)
      list(APPEND zExtensions ".hpp" ".hxx" ".hp" ".hh" ".h++" ".H" ".h"    # 头文件
                              ".cpp" ".cxx" ".cp" ".cc" ".c++" ".C"         # 源文件
                              ".tpp" ".txx" ".tp"       ".t++"      ".inc"  # 模板实现文件
                                                                    ".inl") # 内联实现文件
    endif()
  endif()

  if(zExtensions)
    list(REMOVE_DUPLICATES zExtensions)
  endif()

  #
  # 文件搜集
  #

  set(zResults)
  foreach(sExt IN LISTS zExtensions)
    file(${oRecurse} zFiles CONFIGURE_DEPENDS "${pDirectory}/*${sExt}")
    foreach(pFile IN LISTS zFiles)

      if(DEFINED zMatches OR DEFINED zClashes)
        get_filename_component(sBase "${pFile}" NAME_WLE)
      endif()

      if(DEFINED zMatches)
        set(bPass FALSE)
        foreach(rMatch IN LISTS zMatches)
          if(sBase MATCHES "${rMatch}")
            set(bPass TRUE)
            break()
          endif()
        endforeach()
        if(NOT bPass)
          continue()
        endif()
      endif()

      if(DEFINED zClashes)
        set(bPass TRUE)
        foreach(rClash IN LISTS zClashes)
          if(sBase MATCHES "${rClash}")
            set(bPass FALSE)
            break()
          endif()
        endforeach()
        if(NOT bPass)
          continue()
        endif()
      endif()

      list(APPEND zResults "${pFile}")

    endforeach()
  endforeach()

  if(zResults)
    list(REMOVE_DUPLICATES zResults)
  endif()

  #
  # 收尾
  #

  if(bFlat)
    source_group("${sPrefix}" FILES ${zResults})
  else()
    source_group(TREE "${pDirectory}" PREFIX "${sPrefix}" FILES ${zResults})
  endif()

  if(DEFINED zProperties)
    set_source_files_properties(${zResults} PROPERTIES ${zProperties})
  endif()

  set("${xVariable}" ${zResults} PARENT_SCOPE)

endfunction()

#[=======================================================================[.rst:
.. command:: rr_aux_source_directory_with_convention

  搜集目录中的源文件（aux source directory），遵循惯例（convention）。

  .. code-block:: cmake

    rr_aux_source_directory_with_convention(
      <argument-of-aux_source_directory_ex>...
      [C] [CXX] [MFC] [QT] [CFG]
      [PCH_NAME   <pch-name>}]
      [PCH_HEADER <pch-header>]
      [PCH_SOURCE <pch-source>]
    )

  参见：

  - :command:`aux_source_directory_con`
  - :command:`check_name_with_cmake_rules`

#]=======================================================================]
function(rr_aux_source_directory_with_convention _DIRECTORY _VARIABLE)
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
  rr_check_cmake_name("${xVariable}" AUTHOR_WARNING)

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

  rr_aux_source_directory(
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
