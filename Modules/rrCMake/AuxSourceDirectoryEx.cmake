# zhengrr
# 2016-10-08 – 2019-11-20
# Unlicense

cmake_minimum_required(VERSION 3.14)
cmake_policy(VERSION 3.14)

include_guard()  # 3.10

if(NOT COMMAND check_name_with_cmake_rules)
  include("${CMAKE_CURRENT_LIST_DIR}/CheckNameWithCMakeRules.cmake")
endif()
if(NOT COMMAND check_name_with_fext_rules)
  include("${CMAKE_CURRENT_LIST_DIR}/CheckNameWithFExtRules.cmake")
endif()

#.rst
# .. command:: aux_source_directory_ex
#
#   搜集目录中的源文件（auxiliary source directory），扩展功能（extend）。
#
#   .. code-block:: cmake
#
#     aux_source_directory_ex(
#       <directory> <variable>
#       [RECURES]
#       [MATCHES    <regex>...]
#       [CLASHES    <regex>...]
#       [EXPLICIT]
#       [EXTENSIONS <extension...>]
#       [FLAT]
#       [PREFIX     <group-prefix>]
#       [PROPERTIES < <property-key> <property-value> >...]
#     )
#
#   参见：
#
#   - :command:`check_name_with_cmake_rules`
#   - :command:`check_name_with_fext_rules`
#   - `aux_source_directory <https://cmake.org/cmake/help/latest/command/aux_source_directory.html>`_
#   - `file <https://cmake.org/cmake/help/latest/command/file.html>`_
#   - `source_group <https://cmake.org/cmake/help/latest/command/source_group.html>`_
#   - `set_source_files_properties <https://cmake.org/cmake/help/latest/command/set_source_files_properties.html>`_
#
function(aux_source_directory_ex _DIRECTORY _VARIABLE)
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
  check_name_with_cmake_rules("${xVariable}" AUTHOR_WARNING)

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
    check_name_with_fext_rules("${sExt}" FATAL_ERROR)
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
