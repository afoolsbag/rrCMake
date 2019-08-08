# zhengrr
# 2016-10-08 – 2019-08-08
# Unlicense

cmake_minimum_required(VERSION 3.12)
cmake_policy(VERSION 3.12)

include_guard()  # 3.10

if(NOT COMMAND get_toolset_architecture_address_model_tag)
  include("${CMAKE_CURRENT_LIST_DIR}/LibraryTag.cmake")
endif()

if(NOT COMMAND post_build_copy_link_libraries)
  include("${CMAKE_CURRENT_LIST_DIR}/LinkLibraries.cmake")
endif()

#===============================================================================
#.res:
# .. command:: add_library_ex
#
#   添加库目标到项目（add library），扩展功能（extend）。
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
  set(zMutValKws PROPERTIES
                 COMPILE_DEFINITIONS
                 COMPILE_FEATURES
                 COMPILE_OPTIONS
                 INCLUDE_DIRECTORIES
                 LINK_DIRECTORIES
                 LINK_LIBRARIES
                 LINK_OPTIONS
                 SOURCES)
  cmake_parse_arguments(PARSE_ARGV 1 "" "" "" "${zMutValKws}")

  #-----------------------------------------------------------------------------
  # 规整化参数

  # NAME
  set(sName "${_NAME}")

  # ARGUMENTS_OF_ADD_LIBRARY
  set(zArgumentsOfAddLibrary ${_UNPARSED_ARGUMENTS})

  # PROPERTIES
  unset(zProperties)
  if(DEFINED _PROPERTIES)
    list(LENGTH _PROPERTIES sLen)
    if(sLen EQUAL 0)
      message(WARNING "Keyword PROPERTIES is used, but without value.")
    endif()
    set(zProperties PROPERTIES ${_PROPERTIES})
  endif()

  # COMPILE_DEFINITIONS
  unset(zCompileDefinitions)
  if(DEFINED _COMPILE_DEFINITIONS)
    list(LENGTH _COMPILE_DEFINITIONS sLen)
    if(sLen EQUAL 0)
      message(WARNING "Keyword COMPILE_DEFINITIONS is used, but without value.")
    endif()
    set(zCompileDefinitions ${_COMPILE_DEFINITIONS})
  endif()

  # COMPILE_FEATURES
  unset(zCompileFeatures)
  if(DEFINED _COMPILE_FEATURES)
    list(LENGTH _COMPILE_FEATURES sLen)
    if(sLen EQUAL 0)
      message(WARNING "Keyword COMPILE_FEATURES is used, but without value.")
    endif()
    set(zCompileFeatures ${_COMPILE_FEATURES})
  endif()

  # COMPILE_OPTIONS
  unset(zCompileOptions)
  if(DEFINED _COMPILE_OPTIONS)
    list(LENGTH _COMPILE_OPTIONS sLen)
    if(sLen EQUAL 0)
      message(WARNING "Keyword COMPILE_OPTIONS is used, but without value.")
    endif()
    set(zCompileOptions ${_COMPILE_OPTIONS})
  endif()

  # INCLUDE_DIRECTORIES
  unset(zIncludeDirectories)
  if(DEFINED _INCLUDE_DIRECTORIES)
    list(LENGTH _INCLUDE_DIRECTORIES sLen)
    if(sLen EQUAL 0)
      message(WARNING "Keyword INCLUDE_DIRECTORIES is used, but without value.")
    endif()
    set(zIncludeDirectories ${_INCLUDE_DIRECTORIES})
  endif()

  # LINK_DIRECTORIES
  unset(zLinkDirectories)
  if(DEFINED _LINK_DIRECTORIES)
    list(LENGTH _LINK_DIRECTORIES sLen)
    if(sLen EQUAL 0)
      message(WARNING "Keyword LINK_DIRECTORIES is used, but without value.")
    endif()
    set(zLinkDirectories ${_LINK_DIRECTORIES})
  endif()

  # LINK_LIBRARIES
  unset(zLinkLibraries)
  if(DEFINED _LINK_LIBRARIES)
    list(LENGTH _LINK_LIBRARIES sLen)
    if(sLen EQUAL 0)
      message(WARNING "Keyword LINK_LIBRARIES is used, but without value.")
    endif()
    set(zLinkLibraries ${_LINK_LIBRARIES})
  endif()

  # LINK_OPTIONS
  unset(zLinkOptions)
  if(DEFINED _LINK_OPTIONS)
    list(LENGTH _LINK_OPTIONS sLen)
    if(sLen EQUAL 0)
      message(WARNING "Keyword LINK_OPTIONS is used, but without value.")
    endif()
    set(zLinkOptions ${_LINK_OPTIONS})
  endif()

  # SOURCES
  unset(zSources)
  if(DEFINED _SOURCES)
    list(LENGTH _SOURCES sLen)
    if(sLen EQUAL 0)
      message(WARNING "Keyword SOURCES is used, but without value.")
    endif()
    set(zSources ${_SOURCES})
  endif()

  #-----------------------------------------------------------------------------
  # 添加目标并配置

  add_library("${sName}" ${zArgumentsOfAddLibrary})
  if(DEFINED zProperties)
    set_target_properties("${sName}" ${zProperties})
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

#===============================================================================
#.res:
# .. command:: add_library_con
#
#   添加库目标到项目（add library），遵循惯例（convention）。
#
#   .. code-block:: cmake
#
#     add_library_con(
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
#   - :command:`add_library_ex`
#   - `option <https://cmake.org/cmake/help/latest/command/option.html>`_
#   - `install <https://cmake.org/cmake/help/latest/command/install.html>`_
function(add_library_con _NAME)
  set(zMutValKws PROPERTIES
                 COMPILE_DEFINITIONS
                 COMPILE_FEATURES
                 COMPILE_OPTIONS
                 INCLUDE_DIRECTORIES
                 LINK_DIRECTORIES
                 LINK_LIBRARIES
                 LINK_OPTIONS
                 SOURCES)
  cmake_parse_arguments(PARSE_ARGV 1 "" "" "" "${zMutValKws}")

  #-----------------------------------------------------------------------------
  # 规整化参数

  # NAME
  set(sName "${_NAME}")

  string(TOUPPER "${sName}" sNameUpper)

  # ARGUMENTS_OF_ADD_LIBRARY
  set(zArgumentsOfAddLibrary ${_UNPARSED_ARGUMENTS})

  # PROPERTIES
  unset(zProperties)
  if(DEFINED _PROPERTIES)
    set(zProperties PROPERTIES ${_PROPERTIES})
  endif()

  # COMPILE_DEFINITIONS
  unset(zCompileDefinitions)
  if(DEFINED _COMPILE_DEFINITIONS)
    set(zCompileDefinitions COMPILE_DEFINITIONS ${_COMPILE_DEFINITIONS})
  endif()

  # COMPILE_FEATURES
  unset(zCompileFeatures)
  if(DEFINED _COMPILE_FEATURES)
    set(zCompileFeatures COMPILE_FEATURES ${_COMPILE_FEATURES})
  endif()

  # COMPILE_OPTIONS
  unset(zCompileOptions)
  if(DEFINED _COMPILE_OPTIONS)
    set(zCompileOptions COMPILE_OPTIONS ${_COMPILE_OPTIONS})
  endif()

  # INCLUDE_DIRECTORIES
  unset(zIncludeDirectories)
  if(DEFINED _INCLUDE_DIRECTORIES)
    set(zIncludeDirectories INCLUDE_DIRECTORIES ${_INCLUDE_DIRECTORIES})
  endif()

  # LINK_DIRECTORIES
  unset(zLinkDirectories)
  if(DEFINED _LINK_DIRECTORIES)
    set(zLinkDirectories LINK_DIRECTORIES ${_LINK_DIRECTORIES})
  endif()

  # LINK_LIBRARIES
  unset(zLinkLibraries)
  if(DEFINED _LINK_LIBRARIES)
    set(zLinkLibraries LINK_LIBRARIES ${_LINK_LIBRARIES})
  endif()

  # LINK_OPTIONS
  unset(zLinkOptions)
  if(DEFINED _LINK_OPTIONS)
    set(zLinkOptions LINK_OPTIONS ${_LINK_OPTIONS})
  endif()

  # SOURCES
  unset(zSources)
  if(DEFINED _SOURCES)
    set(zSources SOURCES ${_SOURCES})
  endif()

  #-----------------------------------------------------------------------------
  # 启停配置

  if(MODULE IN_LIST zArgumentsOfAddLibrary)
    set(sType MODULE)
  elseif(SHARED IN_LIST zArgumentsOfAddLibrary)
    set(sType SHARED)
  elseif(STATIC IN_LIST zArgumentsOfAddLibrary)
    set(sType STATIC)
  elseif(BUILD_SHARED_LIBS)
    set(sType SHARED)
  else()
    set(sType STATIC)
  endif()

  string(TOUPPER "${sType}" sTypeUpper)
  string(TOLOWER "${sType}" sTypeLower)
  string(TOUPPER "${PROJECT_NAME}" sProjectNameUpper)
  string(REGEX REPLACE "^${sProjectNameUpper}" "" sTrimmedNameUpper "${sNameUpper}")
  string(LENGTH "${sTrimmedNameUpper}" sLen)
  if(0 LESS sLen)
    set(vOptVar ${sProjectNameUpper}_${sTrimmedNameUpper}_${sTypeUpper}_LIBRARY)
  else()
    set(vOptVar ${sProjectNameUpper}_${sTypeUpper}_LIBRARY)
  endif()

  option(${vOptVar} "Build ${sName} ${sTypeLower} library." ON)
  if(NOT ${vOptVar})
    return()
  endif()

  #-----------------------------------------------------------------------------
  # 添加目标并配置

  if(NOT DEFINED zProperties)
    set(zProperties PROPERTIES)
  endif()
  if(NOT DEBUG_POSTFIX IN_LIST zProperties)
    list(APPEND zProperties DEBUG_POSTFIX "d")
  endif()
  if(NOT OUTPUT_NAME IN_LIST zProperties)
    list(APPEND zProperties OUTPUT_NAME "${sName}")
  endif()
  if(NOT PREFIX IN_LIST zProperties AND sType STREQUAL STATIC)
    list(APPEND zProperties PREFIX "lib")
  endif()

  add_library_ex(
    "${sName}" ${zArgumentsOfAddLibrary}
    ${zProperties}
    ${zCompileDefinitions}
    ${zCompileFeatures}
    ${zCompileOptions}
    ${zIncludeDirectories}
    ${zLinkDirectories}
    ${zLinkLibraries}
    ${zLinkOptions}
    ${zSources})

  post_build_copy_link_libraries("${sName}" RECURSE)

  get_toolset_architecture_address_model_tag(sTag)
  install(
    TARGETS             ${sName}
    ARCHIVE DESTINATION "lib/${sTag}$<$<CONFIG:Debug>:d>/"
    LIBRARY DESTINATION "lib/${sTag}$<$<CONFIG:Debug>:d>/"
    RUNTIME DESTINATION "bin/${sTag}$<$<CONFIG:Debug>:d>/")
endfunction()

#===============================================================================
#.res:
# .. command:: add_library_swig
#
#   添加库目标到项目（add library），扩展 SWIG 功能。
#
#   .. code-block:: cmake
#
#     add_library_swig(
#       <name> <argument-of-add-library>...
#       <SWIG_LANGUAGE        <CSHARP|D|GO|GUILE|JAVA|JAVASCRIPT|LUA|OCTAVE|PERL5|PHP7|PYTHON|R|RUBY|SCILAB|TCL8|XML> >
#       <SWIG_INTERFACE       <path-to-interface.swg>>
#       [SWIG_OUTPUT_DIR      <path-to-output-diractory>]
#       [SWIG_ARGUMENTS       <arguments>...]
#       [PROPERTIES           < <property-key> <property-value> >...]
#       [COMPILE_DEFINITIONS  < <INTERFACE|PUBLIC|PRIVATE> <definition>... >...]
#       [COMPILE_FEATURES     < <INTERFACE|PUBLIC|PRIVATE> <feature>... >...]
#       [COMPILE_OPTIONS      < <INTERFACE|PUBLIC|PRIVATE> <option>... >...]
#       [INCLUDE_DIRECTORIES  < <INTERFACE|PUBLIC|PRIVATE> <directory>... >...]
#       [LINK_DIRECTORIES     < <INTERFACE|PUBLIC|PRIVATE> <directory>... >...]
#       [LINK_LIBRARIES       < <INTERFACE|PUBLIC|PRIVATE> <library>... >...]
#       [LINK_OPTIONS         < <INTERFACE|PUBLIC|PRIVATE> <option>... >...]
#       [SOURCES              < <INTERFACE|PUBLIC|PRIVATE> <source>... >...]
#     )
#
#   参见：
#
#   - :command:`add_library_con`
function(add_library_swig _NAME)
  set(zOneValKws SWIG_LANGUAGE
                 SWIG_INTERFACE
                 SWIG_OUTPUT_DIR)
  set(zMutValKws SWIG_ARGUMENTS
                 PROPERTIES
                 COMPILE_DEFINITIONS
                 COMPILE_FEATURES
                 COMPILE_OPTIONS
                 INCLUDE_DIRECTORIES
                 LINK_DIRECTORIES
                 LINK_LIBRARIES
                 LINK_OPTIONS
                 SOURCES)
  cmake_parse_arguments(PARSE_ARGV 1 "" "" "${zOneValKws}" "${zMutValKws}")

  #-----------------------------------------------------------------------------
  # 规整化参数

  # NAME
  set(sName "${_NAME}")

  # ARGUMENTS_OF_ADD_LIBRARY
  set(zArgumentsOfAddLibrary ${_UNPARSED_ARGUMENTS})

  # SWIG_LANGUAGE
  if(DEFINED _SWIG_LANGUAGE)
    set(sSwigLanguage "${_SWIG_LANGUAGE}")
  else()
    message(FATAL_ERROR "Missing SWIG_LANGUAGE argument")
  endif()

  string(TOLOWER ${sSwigLanguage} sSwigLanguageLower)

  # SWIG_INTERFACE
  if(DEFINED _SWIG_INTERFACE)
    set(sSwigInterface "${_SWIG_INTERFACE}")
  else()
    message(FATAL_ERROR "Missing SWIG_INTERFACE argument")
  endif()

  if(NOT IS_ABSOLUTE "${sSwigInterface}")
    set(sSwigInterface "${CMAKE_CURRENT_SOURCE_DIR}/${sSwigInterface}")
  endif()

  if(NOT EXISTS "${sSwigInterface}")
    message(FATAL_ERROR "The SWIG interface file isn't exists: ${_SWIG_INTERFACE}.")
  endif()

  get_filename_component(sSwigInterfaceWle "${sSwigInterface}" NAME_WLE)

  # SWIG_OUTPUT_DIR
  if(DEFINED _SWIG_OUTPUT_DIR)
    set(sSwigOutputDir "${_SWIG_OUTPUT_DIR}")
  else()
    file(RELATIVE_PATH sRelPath "${CMAKE_CURRENT_SOURCE_DIR}" "${sSwigInterface}")
    set(sSwigOutputDir "${CMAKE_CURRENT_BINARY_DIR}/${sRelPath}/${sSwigLanguageLower}")
    file(MAKE_DIRECTORY "${sSwigOutputDir}")
  endif()

  if(NOT IS_ABSOLUTE "${sSwigOutputDir}")
    set(sSwigOutputDir "${CMAKE_CURRENT_BINARY_DIR}/${sSwigOutputDir}")
  endif()

  if(NOT IS_DIRECTORY "${sSwigOutputDir}")
    message(WARNING "The SWIG output directory isn't a directory: ${_SWIG_OUTPUT_DIR}.")
  endif()

  # SWIG_ARGUMENTS
  set(zSwigArguments ${SWIG_ARGUMENTS})

  # PROPERTIES
  unset(zProperties)
  if(DEFINED _PROPERTIES)
    set(zProperties PROPERTIES ${_PROPERTIES})
  endif()

  # COMPILE_DEFINITIONS
  unset(zCompileDefinitions)
  if(DEFINED _COMPILE_DEFINITIONS)
    set(zCompileDefinitions COMPILE_DEFINITIONS ${_COMPILE_DEFINITIONS})
  endif()

  # COMPILE_FEATURES
  unset(zCompileFeatures)
  if(DEFINED _COMPILE_FEATURES)
    set(zCompileFeatures COMPILE_FEATURES ${_COMPILE_FEATURES})
  endif()

  # COMPILE_OPTIONS
  unset(zCompileOptions)
  if(DEFINED _COMPILE_OPTIONS)
    set(zCompileOptions COMPILE_OPTIONS ${_COMPILE_OPTIONS})
  endif()

  # INCLUDE_DIRECTORIES
  unset(zIncludeDirectories)
  if(DEFINED _INCLUDE_DIRECTORIES)
    set(zIncludeDirectories INCLUDE_DIRECTORIES ${_INCLUDE_DIRECTORIES})
  endif()

  # LINK_DIRECTORIES
  unset(zLinkDirectories)
  if(DEFINED _LINK_DIRECTORIES)
    set(zLinkDirectories LINK_DIRECTORIES ${_LINK_DIRECTORIES})
  endif()

  # LINK_LIBRARIES
  unset(zLinkLibraries)
  if(DEFINED _LINK_LIBRARIES)
    set(zLinkLibraries LINK_LIBRARIES ${_LINK_LIBRARIES})
  endif()

  # LINK_OPTIONS
  unset(zLinkOptions)
  if(DEFINED _LINK_OPTIONS)
    set(zLinkOptions LINK_OPTIONS ${_LINK_OPTIONS})
  endif()

  # SOURCES
  unset(zSources)
  if(DEFINED _SOURCES)
    set(zSources SOURCES ${_SOURCES})
  endif()

  #-----------------------------------------------------------------------------
  # 调用 SWIG 生成
  #
  # 在 CMake 配置时初步生成，并为目标加入前置构建，在每次编译前自动重新生成

  find_package(SWIG REQUIRED)  # CMP0074 3.12

  if(sSwigLanguage STREQUAL CSHARP)
    if(NOT "-dllimport" IN_LIST zSwigArguments)
      list(APPEND zSwigArguments "-dllimport" "${sName}$<$<CONFIG:Debug>:d>")
    endif()
  endif()

  if(sSwigLanguage STREQUAL GO)
    if(NOT "-intgosize" IN_LIST zSwigArguments)
      math(EXPR sIntGoZize "8 * ${CMAKE_SIZEOF_VOID_P}")
      list(APPEND zSwigArguments "-intgosize" "${sIntGoZize}")
    endif()
  endif()

  if(sSwigLanguage STREQUAL JAVASCRIPT)
    if(NOT "-node" IN_LIST zSwigArguments)
      list(APPEND zSwigArguments "-node")
    endif()
  endif()

  set(sSwigCxxWrap "${sSwigOutputDir}/${sSwigInterfaceWle}_wrap.cxx")
  execute_process(
    COMMAND "${SWIG_EXECUTABLE}"
            "-c++"                   "-o"      "${sSwigCxxWrap}"
            "-${sSwigLanguageLower}" "-outdir" "${sSwigOutputDir}"
            ${zSwigArguments}
            "${sSwigInterface}"
    RESULTS_VARIABLE sResultCode)
  if(NOT sResultCode EQUAL 0)
    message(FATAL_ERROR "Gennerate SWIG ${sSwigLanguage} files failed: ${sResultCode}")
  endif()

  #-----------------------------------------------------------------------------
  # 添加目标并配置

  if(NOT DEFINED zIncludeDirectories)
    set(zIncludeDirectories INCLUDE_DIRECTORIES)
  endif()
  list(APPEND zIncludeDirectories PRIVATE "${sSwigOutputDir}")

  if(NOT DEFINED zSources)
    set(zSources SOURCES)
  endif()
  list(APPEND zSources PRIVATE "${sSwigInterface}" "${sSwigCxxWrap}")
  source_group("generated" FILES "${sSwigCxxWrap}")

  # add_library_con
  add_library_con(
    "${sName}" ${zArgumentsOfAddLibrary}
    ${zProperties}
    ${zCompileDefinitions}
    ${zCompileFeatures}
    ${zCompileOptions}
    ${zIncludeDirectories}
    ${zLinkDirectories}
    ${zLinkLibraries}
    ${zLinkOptions}
    ${zSources})

  add_custom_command(
    TARGET "${sName}" PRE_BUILD
    COMMAND "${SWIG_EXECUTABLE}"
            "-c++"                   "-o"      "${sSwigCxxWrap}"
            "-${sSwigLanguageLower}" "-outdir" "${sSwigOutputDir}"
            ${zSwigArguments}
            "${sSwigInterface}")

endfunction()
