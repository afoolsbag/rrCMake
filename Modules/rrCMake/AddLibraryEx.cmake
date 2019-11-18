# zhengrr
# 2016-10-08 – 2019-11-18
# Unlicense

cmake_minimum_required(VERSION 3.12)
cmake_policy(VERSION 3.12)

include_guard()  # 3.10

if(NOT COMMAND check_name_with_cmake_rules)
  include("${CMAKE_CURRENT_LIST_DIR}/CheckNameWithCMakeRules.cmake")
endif()

#===============================================================================
#.res:
# .. command:: add_library_ex
#
#   添加库目标到项目，扩展功能（extend）。
#
#   .. code-block:: cmake
#
#     add_library_ex(
#       <name> <argument-of-add-library>...
#       [PROPERTIES          < <property-key> <property-value> >...]
#       [COMPILE_DEFINITIONS < <INTERFACE|PUBLIC|PRIVATE> <definition>... >...]
#       [COMPILE_FEATURES    < <INTERFACE|PUBLIC|PRIVATE> <feature>... >...]
#       [COMPILE_OPTIONS     < <INTERFACE|PUBLIC|PRIVATE> <option>... >...]
#       [INCLUDE_DIRECTORIES < <INTERFACE|PUBLIC|PRIVATE> <directory>... >...]
#       [LINK_DIRECTORIES    < <INTERFACE|PUBLIC|PRIVATE> <directory>... >...]
#       [LINK_LIBRARIES      < <INTERFACE|PUBLIC|PRIVATE> <library>... >...]
#       [LINK_OPTIONS        < <INTERFACE|PUBLIC|PRIVATE> <option>... >...]
#       [SOURCES             < <INTERFACE|PUBLIC|PRIVATE> <source>... >...]
#     )
#
#   参见：
#
#   - `add_library <https://cmake.org/cmake/help/latest/command/add_library.html>`_
#   - `set_target_properties <https://cmake.org/cmake/help/latest/command/set_target_properties.html>`_
#   - `target_compile_definitions <https://cmake.org/cmake/help/latest/command/target_compile_definitions.html>`_
#   - `target_compile_features <https://cmake.org/cmake/help/latest/command/target_compile_features.html>`_
#   - `target_compile_options <https://cmake.org/cmake/help/latest/command/target_compile_options.html>`_
#   - `target_include_directories <https://cmake.org/cmake/help/latest/command/target_include_directories.html>`_
#   - `target_link_directories <https://cmake.org/cmake/help/latest/command/target_link_directories.html>`_
#   - `target_link_libraries <https://cmake.org/cmake/help/latest/command/target_link_libraries.html>`_
#   - `target_link_options <https://cmake.org/cmake/help/latest/command/target_link_options.html>`_
#   - `target_sources <https://cmake.org/cmake/help/latest/command/target_sources.html>`_
function(add_library_ex _NAME)
  set(zOptKws)
  set(zOneValKws)
  set(zMutValKws PROPERTIES
                 COMPILE_DEFINITIONS
                 COMPILE_FEATURES
                 COMPILE_OPTIONS
                 INCLUDE_DIRECTORIES
                 LINK_DIRECTORIES
                 LINK_LIBRARIES
                 LINK_OPTIONS
                 SOURCES)
  cmake_parse_arguments(PARSE_ARGV 1 "" "${zOptKws}" "${zOneValKws}" "${zMutValKws}")

  #-----------------------------------------------------------------------------
  # 规整化参数

  set(sName "${_NAME}")
  check_name_with_cmake_rules("${sName}" AUTHOR_WARNING)

  unset(zProperties)
  if(DEFINED _PROPERTIES)
    list(LENGTH _PROPERTIES nLen)
    if(0 LESS nLen)
      set(zProperties ${_PROPERTIES})
    else()
      message(AUTHOR_WARNING "Keyword PROPERTIES is used, but without value, ignored.")
    endif()
  endif()

  unset(zCompileDefinitions)
  if(DEFINED _COMPILE_DEFINITIONS)
    list(LENGTH _COMPILE_DEFINITIONS nLen)
    if(0 LESS nLen)
      set(zCompileDefinitions ${_COMPILE_DEFINITIONS})
    else()
      message(AUTHOR_WARNING "Keyword COMPILE_DEFINITIONS is used, but without value, ignored.")
    endif()
  endif()

  unset(zCompileFeatures)
  if(DEFINED _COMPILE_FEATURES)
    list(LENGTH _COMPILE_FEATURES nLen)
    if(0 LESS nLen)
      set(zCompileFeatures ${_COMPILE_FEATURES})
    else()
      message(AUTHOR_WARNING "Keyword COMPILE_FEATURES is used, but without value, ignored.")
    endif()
  endif()

  unset(zCompileOptions)
  if(DEFINED _COMPILE_OPTIONS)
    list(LENGTH _COMPILE_OPTIONS nLen)
    if(0 LESS nLen)
      set(zCompileOptions ${_COMPILE_OPTIONS})
    else()
      message(AUTHOR_WARNING "Keyword COMPILE_OPTIONS is used, but without value, ignored.")
    endif()
  endif()

  unset(zIncludeDirectories)
  if(DEFINED _INCLUDE_DIRECTORIES)
    list(LENGTH _INCLUDE_DIRECTORIES nLen)
    if(0 LESS nLen)
      set(zIncludeDirectories ${_INCLUDE_DIRECTORIES})
    else()
      message(AUTHOR_WARNING "Keyword INCLUDE_DIRECTORIES is used, but without value, ignored.")
    endif()
  endif()

  unset(zLinkDirectories)
  if(DEFINED _LINK_DIRECTORIES)
    list(LENGTH _LINK_DIRECTORIES nLen)
    if(0 LESS nLen)
      set(zLinkDirectories ${_LINK_DIRECTORIES})
    else()
      message(AUTHOR_WARNING "Keyword LINK_DIRECTORIES is used, but without value, ignored.")
    endif()
  endif()

  unset(zLinkLibraries)
  if(DEFINED _LINK_LIBRARIES)
    list(LENGTH _LINK_LIBRARIES nLen)
    if(0 LESS nLen)
      set(zLinkLibraries ${_LINK_LIBRARIES})
    else()
      message(AUTHOR_WARNING "Keyword LINK_LIBRARIES is used, but without value, ignored.")
    endif()
  endif()

  unset(zLinkOptions)
  if(DEFINED _LINK_OPTIONS)
    list(LENGTH _LINK_OPTIONS nLen)
    if(0 LESS nLen)
      set(zLinkOptions ${_LINK_OPTIONS})
    else()
      message(AUTHOR_WARNING "Keyword LINK_OPTIONS is used, but without value, ignored.")
    endif()
  endif()

  unset(zSources)
  if(DEFINED _SOURCES)
    list(LENGTH _SOURCES nLen)
    if(0 LESS nLen)
      set(zSources ${_SOURCES})
    else()
      message(AUTHOR_WARNING "Keyword SOURCES is used, but without value, ignored.")
    endif()
  endif()

  set(zArgumentsOfAddLibrary ${_UNPARSED_ARGUMENTS})

  #-----------------------------------------------------------------------------
  # 基础功能

  add_library("${sName}" ${zArgumentsOfAddLibrary})

  #-----------------------------------------------------------------------------
  # 扩展功能

  if(DEFINED zProperties)
    set_target_properties("${sName}" PROPERTIES ${zProperties})
  endif()
  if(DEFINED zCompileDefinitions)
    target_compile_definitions("${sName}" ${zCompileDefinitions})
  endif()
  if(DEFINED zCompileFeatures)
    target_compile_features("${sName}" ${zCompileFeatures})
  endif()
  if(DEFINED zCompileOptions)
    target_compile_options("${sName}" ${zCompileOptions})
  endif()
  if(DEFINED zIncludeDirectories)
    target_include_directories("${sName}" ${zIncludeDirectories})
  endif()
  if(DEFINED zLinkDirectories)
    target_link_directories("${sName}" ${zLinkDirectories})
  endif()
  if(DEFINED zLinkLibraries)
    target_link_libraries("${sName}" ${zLinkLibraries})
  endif()
  if(DEFINED zLinkOptions)
    target_link_options("${sName}" ${zLinkOptions})
  endif()
  if(DEFINED zSources)
    target_sources("${sName}" ${zSources})
  endif()

endfunction()
