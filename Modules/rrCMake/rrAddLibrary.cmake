# zhengrr
# 2016-10-08 – 2021-03-10
# Unlicense

cmake_minimum_required(VERSION 3.17)
cmake_policy(VERSION 3.17)

include_guard()  # 3.10

if(NOT COMMAND rr_check_cmake_name)
  include("${CMAKE_CURRENT_LIST_DIR}/rrCheck.cmake")
endif()
if(NOT COMMAND rr_get_taa_tag)
  include("${CMAKE_CURRENT_LIST_DIR}/rrTag.cmake")
endif()
if(NOT COMMAND rr_post_build_copy_link_library_files)
  include("${CMAKE_CURRENT_LIST_DIR}/rrLinkLibraries.cmake")
endif()

# 模块变量
set(_rrAddLibrary_zKwdNames "COMPILE_DEFINITIONS" "COMPILE_FEATURES" "COMPILE_OPTIONS" "INCLUDE_DIRECTORIES" "LINK_DIRECTORIES" "LINK_LIBRARIES" "LINK_OPTIONS" "PROPERTIES"  "SOURCES")
set(_rrAddLibrary_zVarNames "zCompileDefinitions" "zCompileFeatures" "zCompileOptions" "zIncludeDirectories" "zLinkDirectories" "zLinkLibraries" "zLinkOptions" "zProperties" "zSources")

#[=======================================================================[.rst:
.. command:: rr_add_library

  基于 ``add_library`` 命令，提供更多选项和功能。

  .. code-block:: cmake

    rr_add_library(
      <name> <argument-of-"add_library"-command>...
      [PROPERTIES          {<property-key> <property-value>}...]
      [COMPILE_DEFINITIONS {{INTERFACE|PUBLIC|PRIVATE} <definition>...}...]
      [COMPILE_FEATURES    {{INTERFACE|PUBLIC|PRIVATE} <feature>...}...]
      [COMPILE_OPTIONS     {{INTERFACE|PUBLIC|PRIVATE} <option>...}...]
      [INCLUDE_DIRECTORIES {{INTERFACE|PUBLIC|PRIVATE} <directory>...}...]
      [LINK_DIRECTORIES    {{INTERFACE|PUBLIC|PRIVATE} <directory>...}...]
      [LINK_LIBRARIES      {{INTERFACE|PUBLIC|PRIVATE} <library>...}...]
      [LINK_OPTIONS        {{INTERFACE|PUBLIC|PRIVATE} <option>...}...]
      [SOURCES             {{INTERFACE|PUBLIC|PRIVATE} <source>...}...])

  参见：

  - `add_library <https://cmake.org/cmake/help/latest/command/add_library.html>`_
  - `set_target_properties <https://cmake.org/cmake/help/latest/command/set_target_properties.html>`_
  - `target_compile_definitions <https://cmake.org/cmake/help/latest/command/target_compile_definitions.html>`_
  - `target_compile_features <https://cmake.org/cmake/help/latest/command/target_compile_features.html>`_
  - `target_compile_options <https://cmake.org/cmake/help/latest/command/target_compile_options.html>`_
  - `target_include_directories <https://cmake.org/cmake/help/latest/command/target_include_directories.html>`_
  - `target_link_directories <https://cmake.org/cmake/help/latest/command/target_link_directories.html>`_
  - `target_link_libraries <https://cmake.org/cmake/help/latest/command/target_link_libraries.html>`_
  - `target_link_options <https://cmake.org/cmake/help/latest/command/target_link_options.html>`_
  - `target_sources <https://cmake.org/cmake/help/latest/command/target_sources.html>`_

#]=======================================================================]
function(rr_add_library sName)
  set(zOptKws)
  set(zOneValKws)
  set(zMutValKws ${_rrAddLibrary_zKwdNames})
  cmake_parse_arguments(PARSE_ARGV 1 "" "${zOptKws}" "${zOneValKws}" "${zMutValKws}")

  rr_check_cmake_name("${sName}" AUTHOR_WARNING)
  foreach(sKwdName xVarName IN ZIP_LISTS _rrAddLibrary_zKwdNames _rrAddLibrary_zVarNames)  # 3.17
    unset("${xVarName}")
    if(DEFINED "_${sKwdName}")
      if("${_${sKwdName}}" STREQUAL "")
        message(AUTHOR_WARNING "Keyword ${sKwdName} is used, but without value, ignored.")
      else()
        set("${xVarName}" ${_${sKwdName}})
      endif()
    endif()
  endforeach()

  add_library("${sName}" ${_UNPARSED_ARGUMENTS})
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

#[=======================================================================[.rst:
.. command:: rr_add_library_with_convention

  类似 ``rr_add_library`` 命令，并依据惯例进行更多配置：

  - 默认置否的构建开关
  - 在类 Unix 系统上，库文件以 lib 前缀；在 Windows 系统上，静态库文件以 lib 前缀
  - 在调试模式下，库文件以 d 后缀
  - 构建完成后，复制已知依赖到库文件目录
  - 安装时，将库文件复制到形似 {bin|lib}/<tag>[d] 的目录中

  .. code-block:: cmake

    rr_add_library_with_convention(
      <name> <argument-of-"add_library"-command>...
      [PROPERTIES          {<property-key> <property-value>}...]
      [COMPILE_DEFINITIONS {{INTERFACE|PUBLIC|PRIVATE} <definition>...}...]
      [COMPILE_FEATURES    {{INTERFACE|PUBLIC|PRIVATE} <feature>...}...]
      [COMPILE_OPTIONS     {{INTERFACE|PUBLIC|PRIVATE} <option>...}...]
      [INCLUDE_DIRECTORIES {{INTERFACE|PUBLIC|PRIVATE} <directory>...}...]
      [LINK_DIRECTORIES    {{INTERFACE|PUBLIC|PRIVATE} <directory>...}...]
      [LINK_LIBRARIES      {{INTERFACE|PUBLIC|PRIVATE} <library>...}...]
      [LINK_OPTIONS        {{INTERFACE|PUBLIC|PRIVATE} <option>...}...]
      [SOURCES             {{INTERFACE|PUBLIC|PRIVATE} <source>...}...])

  参见：

  - :command:`rr_add_library`
  - `option <https://cmake.org/cmake/help/latest/command/option.html>`_
  - `install <https://cmake.org/cmake/help/latest/command/install.html>`_

#]=======================================================================]
function(rr_add_library_with_convention sName)
  set(zOptKws)
  set(zOneValKws)
  set(zMutValKws ${_rrAddLibrary_zKwdNames})
  cmake_parse_arguments(PARSE_ARGV 1 "" "${zOptKws}" "${zOneValKws}" "${zMutValKws}")

  rr_check_cmake_name("${sName}" AUTHOR_WARNING)
  foreach(sKwdName xVarName IN ZIP_LISTS _rrAddLibrary_zKwdNames _rrAddLibrary_zVarNames)  # 3.17
    unset("${xVarName}")
    if(DEFINED "_${sKwdName}")
      if("${_${sKwdName}}" STREQUAL "")
        message(AUTHOR_WARNING "Keyword ${sKwdName} is used, but without value, ignored.")
      else()
        set("${xVarName}" ${_${sKwdName}})
      endif()
    endif()
  endforeach()

  # 默认置否的构建开关
  if(MODULE IN_LIST _UNPARSED_ARGUMENTS)
    set(sType MODULE)
  elseif(SHARED IN_LIST _UNPARSED_ARGUMENTS)
    set(sType SHARED)
  elseif(STATIC IN_LIST _UNPARSED_ARGUMENTS)
    set(sType STATIC)
  elseif(BUILD_SHARED_LIBS)
    set(sType SHARED)
  else()
    set(sType STATIC)
  endif()
  string(TOUPPER "${sType}" sTypeUpper)
  string(TOLOWER "${sType}" sTypeLower)

  string(TOUPPER "${sName}" sNameUpper)
  string(TOUPPER "${PROJECT_NAME}" sProjectNameUpper)
  string(REGEX REPLACE "^${sProjectNameUpper}_?" "" sTrimmedNameUpper "${sNameUpper}")
  string(LENGTH "${sTrimmedNameUpper}" nLen)
  if(0 LESS nLen)
    set(xOptVar ${sProjectNameUpper}_${sTrimmedNameUpper}_${sTypeUpper}_LIBRARY)
  else()
    set(xOptVar ${sProjectNameUpper}_${sTypeUpper}_LIBRARY)
  endif()

  option(${xOptVar} "Build ${sName} ${sTypeLower} library." ON)
  if(NOT ${xOptVar})
    return()
  endif()

  # 在类 Unix 系统上，库文件以 lib 前缀；在 Windows 系统上，静态库文件以 lib 前缀
  if(NOT PREFIX IN_LIST zProperties AND (UNIX OR sType STREQUAL STATIC))
    list(APPEND zProperties PREFIX "lib")
  endif()

  # 在调试模式下，库文件以 d 后缀
  if(NOT DEBUG_POSTFIX IN_LIST zProperties)
    list(APPEND zProperties DEBUG_POSTFIX "d")
  endif()

  foreach(xVarName sKwdName IN ZIP_LISTS _rrAddLibrary_zVarNames _rrAddLibrary_zKwdNames)  # 3.17
    if(DEFINED "${xVarName}")
      list(PREPEND "{xVarName}" "sKwdName")  # 3.15
    endif()
  endforeach()
  rr_add_library(
    "${sName}" ${_UNPARSED_ARGUMENTS}
    ${zProperties}
    ${zCompileDefinitions}
    ${zCompileFeatures}
    ${zCompileOptions}
    ${zIncludeDirectories}
    ${zLinkDirectories}
    ${zLinkLibraries}
    ${zLinkOptions}
    ${zSources})

  # 构建完成后，复制已知依赖到库文件目录
  rr_post_build_copy_link_library_files("${sName}" INCLUDE_ITSELF RECURSE)

  # 安装时，将库文件复制到形似 {bin|lib}/<tag>[d] 的目录中
  rr_get_taa_tag(sTag)
  install(
    TARGETS             "${sName}"
    ARCHIVE DESTINATION "lib/${sTag}$<$<CONFIG:Debug>:d>/"
    LIBRARY DESTINATION "lib/${sTag}$<$<CONFIG:Debug>:d>/"
    RUNTIME DESTINATION "bin/${sTag}$<$<CONFIG:Debug>:d>/")
endfunction()

#[=======================================================================[.rst:
.. command:: rr_add_library_with_convention_and_swig

  类似 ``rr_add_library_with_convention`` 命令，并引入 SWIG 支持。

  .. code-block:: cmake

    rr_add_library_with_convention_and_swig(
      <name> <argument-of-"add_library"-command>...
      {SWIG_LANGUAGE       {CSHARP|D|GO|GUILE|JAVA|JAVASCRIPT|LUA|OCTAVE|PERL5|PHP7|PYTHON|R|RUBY|SCILAB|TCL8|XML}}
      {SWIG_INTERFACE      <path-to-interface.swg>}
      [SWIG_OUTPUT_DIR     <path-to-output-diractory>]
      [SWIG_ARGUMENTS      <arguments>...]
      [PROPERTIES          {<property-key> <property-value>}...]
      [COMPILE_DEFINITIONS {{INTERFACE|PUBLIC|PRIVATE} <definition>...}...]
      [COMPILE_FEATURES    {{INTERFACE|PUBLIC|PRIVATE} <feature>...}...]
      [COMPILE_OPTIONS     {{INTERFACE|PUBLIC|PRIVATE} <option>...}...]
      [INCLUDE_DIRECTORIES {{INTERFACE|PUBLIC|PRIVATE} <directory>...}...]
      [LINK_DIRECTORIES    {{INTERFACE|PUBLIC|PRIVATE} <directory>...}...]
      [LINK_LIBRARIES      {{INTERFACE|PUBLIC|PRIVATE} <library>...}...]
      [LINK_OPTIONS        {{INTERFACE|PUBLIC|PRIVATE} <option>...}...]
      [SOURCES             {{INTERFACE|PUBLIC|PRIVATE} <source>...}...])

  参见：

  - :command:`rr_add_library_with_convention`

#]=======================================================================]
function(rr_add_library_with_convention_and_swig sName)
  set(zOptKws)
  set(zOneValKws SWIG_INTERFACE
                 SWIG_LANGUAGE
                 SWIG_OUTPUT_DIR)
  set(zMutValKws SWIG_ARGUMENTS
                 ${_rrAddLibrary_zKwdNames})
  cmake_parse_arguments(PARSE_ARGV 1 "" "${zOptKws}" "${zOneValKws}" "${zMutValKws}")

  # <name>
  # -> sName
  rr_check_cmake_name("${sName}" AUTHOR_WARNING)

  # <argument-of-"add_library"-command>...
  # -> zArgumentsOfAddLibraryCommand
  set(zArgumentsOfAddLibraryCommand ${_UNPARSED_ARGUMENTS})

  # SWIG_LANGUAGE
  # -> sSwigLanguage
  # -> sSwigLanguageLower
  if(NOT DEFINED _SWIG_LANGUAGE)
    message(FATAL_ERROR "Missing SWIG_LANGUAGE argument.")
  endif()
  set(sSwigLanguage "${_SWIG_LANGUAGE}")
  string(TOLOWER "${sSwigLanguage}" sSwigLanguageLower)

  # SWIG_INTERFACE
  # -> pSwigInterface
  # -> sSwigInterfaceWle
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

  # SWIG_OUTPUT_DIR
  # -> pSwigOutputDir
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

  # SWIG_ARGUMENTS
  # -> zSwigArguments
  set(zSwigArguments ${_SWIG_ARGUMENTS})

  # PROPERTIES          -> zProperties
  # COMPILE_DEFINITIONS -> zCompileDefinitions
  # COMPILE_FEATURES    -> zCompileFeatures
  # COMPILE_OPTIONS     -> zCompileOptions
  # INCLUDE_DIRECTORIES -> zIncludeDirectories
  # LINK_DIRECTORIES    -> zLinkDirectories
  # LINK_LIBRARIES      -> zLinkLibraries
  # LINK_OPTIONS        -> zLinkOptions
  # SOURCES             -> zSources
  foreach(sKwdName xVarName IN ZIP_LISTS _rrAddLibrary_zKwdNames _rrAddLibrary_zVarNames)  # 3.17
    unset("${xVarName}")
    if(DEFINED "_${sKwdName}")
      if("${_${sKwdName}}" STREQUAL "")
        message(AUTHOR_WARNING "Keyword ${sKwdName} is used, but without value, ignored.")
      else()
        set("${xVarName}" ${_${sKwdName}})
      endif()
    endif()
  endforeach()

  # 引入 SWIG 支持：
  # 在 CMake 配置时生成，并为目标加入前置构建，在每次编译前自动重新生成

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
      list(APPEND zIncludeDirectories PRIVATE "${JAVA_INCLUDE_PATH}" "${JAVA_INCLUDE_PATH2}")
    endif()
  endif()

  # JavaScript
  if(sSwigLanguage STREQUAL JAVASCRIPT)
    if(NOT "-node" IN_LIST zSwigArguments)
      list(APPEND zSwigArguments "-node")
    endif()
  endif()

  # 配置时生成
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

  # INCLUDE_DIRECTORIES
  list(APPEND zIncludeDirectories PRIVATE "${pSwigOutputDir}")

  # SOURCES
  list(APPEND zSources PRIVATE "${pSwigInterface}" "${pSwigCxxWrap}")
  source_group("generated" FILES "${pSwigCxxWrap}")

  foreach(xVarName sKwdName IN ZIP_LISTS _rrAddLibrary_zVarNames _rrAddLibrary_zKwdNames)  # 3.17
    if(DEFINED "${xVarName}")
      list(PREPEND "{xVarName}" "sKwdName")  # 3.15
    endif()
  endforeach()
  rr_add_library_with_convention(
    "${sName}" ${zArgumentsOfAddLibraryCommand}
    ${zProperties}
    ${zCompileDefinitions}
    ${zCompileFeatures}
    ${zCompileOptions}
    ${zIncludeDirectories}
    ${zLinkDirectories}
    ${zLinkLibraries}
    ${zLinkOptions}
    ${zSources})

  # 构建前生成
  add_custom_command(
    TARGET "${sName}" PRE_BUILD
    COMMAND "${SWIG_EXECUTABLE}"
            "-c++"                   "-o"      "${pSwigCxxWrap}"
            "-${sSwigLanguageLower}" "-outdir" "${pSwigOutputDir}"
            ${zSwigArguments}
            "${pSwigInterface}")

  rr_post_build_copy_link_library_files("${sName}" INCLUDE_ITSELF RECURSE DESTINATION "${pSwigOutputDir}")
endfunction()
