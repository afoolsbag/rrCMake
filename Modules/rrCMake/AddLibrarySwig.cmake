# zhengrr
# 2016-10-08 – 2019-11-18
# Unlicense

cmake_minimum_required(VERSION 3.12)
cmake_policy(VERSION 3.12)

include_guard()  # 3.10

if(NOT COMMAND add_library_con)
  include("${CMAKE_CURRENT_LIST_DIR}/AddLibraryCon.cmake")
endif()
if(NOT COMMAND check_name_with_cmake_rules)
  include("${CMAKE_CURRENT_LIST_DIR}/CheckNameWithCMakeRules.cmake")
endif()
if(NOT COMMAND get_toolset_architecture_address_model_tag)
  include("${CMAKE_CURRENT_LIST_DIR}/GetToolsetArchitectureAddressModelTag.cmake")
endif()
if(NOT COMMAND post_build_copy_link_library_files)
  include("${CMAKE_CURRENT_LIST_DIR}/PostBuildCopyLinkLibraryFiles.cmake")
endif()

#===============================================================================
#.res:
# .. command:: add_library_swig
#
#   添加库目标到项目，扩展 SWIG 功能。
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
  set(zOptKws)
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
  cmake_parse_arguments(PARSE_ARGV 1 "" "${zOptKws}" "${zOneValKws}" "${zMutValKws}")

  #-----------------------------------------------------------------------------
  # 规整化参数

  set(sName "${_NAME}")
  check_name_with_cmake_rules("${sName}" AUTHOR_WARNING)

  if(NOT DEFINED _SWIG_LANGUAGE)
    message(FATAL_ERROR "Missing SWIG_LANGUAGE argument.")
  else()
  set(sSwigLanguage "${_SWIG_LANGUAGE}")
  string(TOLOWER ${sSwigLanguage} sSwigLanguageLower)

  if(NOT DEFINED _SWIG_INTERFACE)
    message(FATAL_ERROR "Missing SWIG_INTERFACE argument.")
  endif()
  set(pSwigInterface "${_SWIG_INTERFACE}")
  if(NOT IS_ABSOLUTE "${pSwigInterface}")
    set(pSwigInterface "${CMAKE_CURRENT_SOURCE_DIR}/${pSwigInterface}")
  endif()
  if(NOT EXISTS "${pSwigInterface}")
    message(FATAL_ERROR "The SWIG interface file isn't exists: ${_SWIG_INTERFACE}.")
  endif()
  get_filename_component(sSwigInterfaceWle "${pSwigInterface}" NAME_WLE)

  if(DEFINED _SWIG_OUTPUT_DIR)
    set(pSwigOutputDir "${_SWIG_OUTPUT_DIR}")
  else()
    file(RELATIVE_PATH pRelPath "${CMAKE_CURRENT_SOURCE_DIR}" "${pSwigInterface}")
    set(pSwigOutputDir "${CMAKE_CURRENT_BINARY_DIR}/${pRelPath}/${sSwigLanguageLower}")
    file(MAKE_DIRECTORY "${pSwigOutputDir}")
  endif()
  if(NOT IS_ABSOLUTE "${pSwigOutputDir}")
    set(pSwigOutputDir "${CMAKE_CURRENT_BINARY_DIR}/${pSwigOutputDir}")
  endif()
  if(NOT IS_DIRECTORY "${pSwigOutputDir}")
    message(FATAL_ERROR "The SWIG output directory isn't a directory: ${_SWIG_OUTPUT_DIR}.")
  endif()

  set(zSwigArguments ${_SWIG_ARGUMENTS})

  unset(zProperties)
  if(DEFINED _PROPERTIES)
    set(zProperties PROPERTIES ${_PROPERTIES})
  endif()

  unset(zCompileDefinitions)
  if(DEFINED _COMPILE_DEFINITIONS)
    set(zCompileDefinitions COMPILE_DEFINITIONS ${_COMPILE_DEFINITIONS})
  endif()

  unset(zCompileFeatures)
  if(DEFINED _COMPILE_FEATURES)
    set(zCompileFeatures COMPILE_FEATURES ${_COMPILE_FEATURES})
  endif()

  unset(zCompileOptions)
  if(DEFINED _COMPILE_OPTIONS)
    set(zCompileOptions COMPILE_OPTIONS ${_COMPILE_OPTIONS})
  endif()

  unset(zIncludeDirectories)
  if(DEFINED _INCLUDE_DIRECTORIES)
    set(zIncludeDirectories INCLUDE_DIRECTORIES ${_INCLUDE_DIRECTORIES})
  endif()

  unset(zLinkDirectories)
  if(DEFINED _LINK_DIRECTORIES)
    set(zLinkDirectories LINK_DIRECTORIES ${_LINK_DIRECTORIES})
  endif()

  unset(zLinkLibraries)
  if(DEFINED _LINK_LIBRARIES)
    set(zLinkLibraries LINK_LIBRARIES ${_LINK_LIBRARIES})
  endif()

  unset(zLinkOptions)
  if(DEFINED _LINK_OPTIONS)
    set(zLinkOptions LINK_OPTIONS ${_LINK_OPTIONS})
  endif()

  unset(zSources)
  if(DEFINED _SOURCES)
    set(zSources SOURCES ${_SOURCES})
  endif()

  set(zArgumentsOfAddLibrary ${_UNPARSED_ARGUMENTS})

  #-----------------------------------------------------------------------------
  # 调用 SWIG 生成
  #
  # 在 CMake 配置时初步生成，并为目标加入前置构建，在每次编译前自动重新生成

  find_package(SWIG REQUIRED)  # CMP0074 3.12

  # C#
  if(sSwigLanguage STREQUAL CSHARP)
    if(NOT "-dllimport" IN_LIST zSwigArguments)
      list(APPEND zSwigArguments "-dllimport" "${sName}$<$<CONFIG:Debug>:d>")
    endif()
  endif()

  # Go
  if(sSwigLanguage STREQUAL GO)
    if(NOT "-intgosize" IN_LIST zSwigArguments)
      math(EXPR nIntGoZize "8 * ${CMAKE_SIZEOF_VOID_P}")
      list(APPEND zSwigArguments "-intgosize" "${nIntGoZize}")
    endif()
  endif()

  # Java
  if(sSwigLanguage STREQUAL JAVA)
    find_package(JNI)
    if(JNI_FOUND)
      if(NOT DEFINED zIncludeDirectories)
        set(zIncludeDirectories INCLUDE_DIRECTORIES)
      endif()
      list(APPEND zIncludeDirectories PRIVATE "${JAVA_INCLUDE_PATH}" "${JAVA_INCLUDE_PATH2}")
    endif()
  endif()

  # JavaScript
  if(sSwigLanguage STREQUAL JAVASCRIPT)
    if(NOT "-node" IN_LIST zSwigArguments)
      list(APPEND zSwigArguments "-node")
    endif()
  endif()

  set(pSwigCxxWrap "${pSwigOutputDir}/${sSwigInterfaceWle}_wrap.cxx")
  execute_process(
    COMMAND "${SWIG_EXECUTABLE}"
            "-c++"                   "-o"      "${pSwigCxxWrap}"
            "-${sSwigLanguageLower}" "-outdir" "${pSwigOutputDir}"
            ${zSwigArguments}
            "${pSwigInterface}"
    RESULTS_VARIABLE nResultCode)
  if(NOT nResultCode EQUAL 0)
    message(FATAL_ERROR "Gennerate SWIG ${sSwigLanguage} files failed: ${nResultCode}")
  endif()

  #-----------------------------------------------------------------------------
  # 引入并配置目标

  if(NOT DEFINED zIncludeDirectories)
    set(zIncludeDirectories INCLUDE_DIRECTORIES)
  endif()
  list(APPEND zIncludeDirectories PRIVATE "${pSwigOutputDir}")

  if(NOT DEFINED zSources)
    set(zSources SOURCES)
  endif()
  list(APPEND zSources PRIVATE "${pSwigInterface}" "${pSwigCxxWrap}")
  source_group("generated" FILES "${pSwigCxxWrap}")

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
            "-c++"                   "-o"      "${pSwigCxxWrap}"
            "-${sSwigLanguageLower}" "-outdir" "${pSwigOutputDir}"
            ${zSwigArguments}
            "${pSwigInterface}")

  post_build_copy_link_library_files("${sName}" INCLUDE_ITSELF RECURSE DESTINATION "${sSwigOutputDir}")

endfunction()
