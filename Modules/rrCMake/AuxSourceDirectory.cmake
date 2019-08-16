# zhengrr
# 2016-10-08 – 2019-08-16
# Unlicense

cmake_minimum_required(VERSION 3.14)
cmake_policy(VERSION 3.14)

include_guard()  # 3.10

if(NOT COMMAND check_name_with_fext_rules)
  include("${CMAKE_CURRENT_LIST_DIR}/CheckName.cmake")
endif()

#===============================================================================
#.rst
# .. command:: aux_source_directory_ex
#
#   搜集目录中的源文件（auxiliary source directory），扩展功能（extend）。
#
#   .. code-block:: cmake
#
#     aux_source_directory_ex(
#       <directory> <variable>
#
#       [RECURES]
#
#       [MATCHES    <regex>...]
#       [CLASHES    <regex>...]
#
#       [EXPLICIT]
#       [EXTENSIONS <extensions...>]
#
#       [FLAT]
#       [PREFIX     <group-prefix>]
#
#       [PROPERTIES <property-key> <property-value> ...]
#     )
#
#   参见：
#
#   - `aux_source_directory <https://cmake.org/cmake/help/latest/command/aux_source_directory.html>`_
#   - `file <https://cmake.org/cmake/help/latest/command/file.html>`_
#   - `source_group <https://cmake.org/cmake/help/latest/command/source_group.html>`_
#   - `set_source_files_properties <https://cmake.org/cmake/help/latest/command/set_source_files_properties.html>`_
function(aux_source_directory_ex _DIRECTORY _VARIABLE)
  set(zOptKws    RECURSE
                 EXPLICIT
                 FLAT)
  set(zOneValKws PREFIX)
  set(zMutValKws MATCHES
                 CLASHES
                 EXTENSIONS
                 PROPERTIES)
  cmake_parse_arguments(PARSE_ARGV 2 "" "${zOptKws}" "${zOneValKws}" "${zMutValKws}")

  #-----------------------------------------------------------------------------
  # 规整化参数

  # UNPARSED_ARGUMENTS 
  if(DEFINED _UNPARSED_ARGUMENTS)
    message(FATAL_ERROR "Unexpected arguments: ${_UNPARSED_ARGUMENTS}.")
  endif()

  # DIRECTORY
  set(pDirectory "${_DIRECTORY}")

  if(NOT IS_ABSOLUTE "${pDirectory}")
    set(pDirectory "${CMAKE_CURRENT_SOURCE_DIR}/${pDirectory}")
  endif()

  if(NOT IS_DIRECTORY "${pDirectory}")
    message(WARNING "The directory isn't a directory: ${_DIRECTORY}.")
  endif()

  # VARIABLE
  set(vVariable "${_VARIABLE}")

  # RECURSE
  if(_RECURSE)
    set(oRecurse GLOB_RECURSE)
  else()
    set(oRecurse GLOB)
  endif()

  # MATCHES
  unset(zMatches)
  if(DEFINED _MATCHES)
    set(zMatches "${_MATCHES}")
  endif()

  # CLASHES
  unset(zClashes)
  if(DEFINED _CLASHES)
    set(zClashes "${_CLASHES}")
  endif()

  # EXPLICIT
  set(bExplicit "${_EXPLICIT}")

  # EXTENSIONS
  set(zExtensions ${_EXTENSIONS})

  foreach(sExt IN LISTS zExtensions)
    check_name_with_fext_rules("${sExt}" FATAL_ERROR)
  endforeach()

  # FLAT
  set(bFlat "${_FLAT}")

  # PREFIX
  if(DEFINED _PREFIX)
    set(sPrefix "${_PREFIX}")
  else()
    set(sPrefix "/")
  endif()

  # PROPERTIES
  unset(zProperties)
  if(DEFINED _PROPERTIES)
    list(LENGTH _PROPERTIES sLen)
    if(sLen EQUAL 0)
      message(WARNING "Keyword PROPERTIES is used, but without value.")
    endif()
    set(zProperties PROPERTIES ${_PROPERTIES})
  endif()

  #-----------------------------------------------------------------------------
  # 扩展名

  if(NOT bExplicit)
    get_property(zLangs GLOBAL PROPERTY ENABLED_LANGUAGES)

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
                              ".tpp"                                ".inc"  # 模板实现文件
                                                                    ".inl") # 内联实现文件
    endif()
  endif()

  if(zExtensions)
    list(REMOVE_DUPLICATES zExtensions)
  endif()

  #-----------------------------------------------------------------------------
  # 文件搜集

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

  #-----------------------------------------------------------------------------
  # 收尾

  if(bFlat)
    source_group("${sPrefix}" FILES ${zResults})
  else()
    source_group(TREE "${pDirectory}" PREFIX "${sPrefix}" FILES ${zResults})
  endif()

  if(DEFINED zProperties)
    set_source_files_properties(${zResults} PROPERTIES ${zProperties})
  endif()

  set("${vVariable}" ${zResults} PARENT_SCOPE)
endfunction()

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
