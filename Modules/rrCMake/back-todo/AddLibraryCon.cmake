# zhengrr
# 2016-10-08 – 2019-11-20
# Unlicense

cmake_minimum_required(VERSION 3.12)
cmake_policy(VERSION 3.12)

include_guard()  # 3.10

if(NOT COMMAND add_library_ex)
  include("${CMAKE_CURRENT_LIST_DIR}/AddLibraryEx.cmake")
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

#.res:
# .. command:: add_library_con
#
#   添加库目标到项目，遵循惯例（convention）。
#
#   .. code-block:: cmake
#
#     add_library_con(
#       <name> <argument-of-add_library>...
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
#   - :command:`check_name_with_cmake_rules`
#   - :command:`get_toolset_architecture_address_model_tag`
#   - :command:`post_build_copy_link_library_files`
#   - `option <https://cmake.org/cmake/help/latest/command/option.html>`_
#   - `install <https://cmake.org/cmake/help/latest/command/install.html>`_
#
function(add_library_con _NAME)
  set(zOptKws)
  set(zOneValKws)
  set(zMutValKws COMPILE_DEFINITIONS
                 COMPILE_FEATURES
                 COMPILE_OPTIONS
                 INCLUDE_DIRECTORIES
                 LINK_DIRECTORIES
                 LINK_LIBRARIES
                 LINK_OPTIONS
                 PROPERTIES
                 SOURCES)
  cmake_parse_arguments(PARSE_ARGV 1 "" "${zOptKws}" "${zOneValKws}" "${zMutValKws}")

  #
  # 参数规整
  #

  # <name>
  set(sName "${_NAME}")
  check_name_with_cmake_rules("${sName}" AUTHOR_WARNING)
  string(TOUPPER "${sName}" sNameUpper)

  # <argument-of-add_library>...
  set(zArgumentsOfAddLibrary ${_UNPARSED_ARGUMENTS})

  # [PROPERTIES < <property-key> <property-value> >...]
  unset(zProperties)
  if(DEFINED _PROPERTIES)
    set(zProperties PROPERTIES ${_PROPERTIES})
  endif()

  # [COMPILE_DEFINITIONS < <INTERFACE|PUBLIC|PRIVATE> <definition>... >...]
  unset(zCompileDefinitions)
  if(DEFINED _COMPILE_DEFINITIONS)
    set(zCompileDefinitions COMPILE_DEFINITIONS ${_COMPILE_DEFINITIONS})
  endif()

  # [COMPILE_FEATURES < <INTERFACE|PUBLIC|PRIVATE> <feature>... >...]
  unset(zCompileFeatures)
  if(DEFINED _COMPILE_FEATURES)
    set(zCompileFeatures COMPILE_FEATURES ${_COMPILE_FEATURES})
  endif()

  # [COMPILE_OPTIONS < <INTERFACE|PUBLIC|PRIVATE> <option>... >...]
  unset(zCompileOptions)
  if(DEFINED _COMPILE_OPTIONS)
    set(zCompileOptions COMPILE_OPTIONS ${_COMPILE_OPTIONS})
  endif()

  # [INCLUDE_DIRECTORIES < <INTERFACE|PUBLIC|PRIVATE> <directory>... >...]
  unset(zIncludeDirectories)
  if(DEFINED _INCLUDE_DIRECTORIES)
    set(zIncludeDirectories INCLUDE_DIRECTORIES ${_INCLUDE_DIRECTORIES})
  endif()

  # [LINK_DIRECTORIES < <INTERFACE|PUBLIC|PRIVATE> <directory>... >...]
  unset(zLinkDirectories)
  if(DEFINED _LINK_DIRECTORIES)
    set(zLinkDirectories LINK_DIRECTORIES ${_LINK_DIRECTORIES})
  endif()

  # [LINK_LIBRARIES < <INTERFACE|PUBLIC|PRIVATE> <library>... >...]
  unset(zLinkLibraries)
  if(DEFINED _LINK_LIBRARIES)
    set(zLinkLibraries LINK_LIBRARIES ${_LINK_LIBRARIES})
  endif()

  # [LINK_OPTIONS < <INTERFACE|PUBLIC|PRIVATE> <option>... >...]
  unset(zLinkOptions)
  if(DEFINED _LINK_OPTIONS)
    set(zLinkOptions LINK_OPTIONS ${_LINK_OPTIONS})
  endif()

  # [SOURCES < <INTERFACE|PUBLIC|PRIVATE> <source>... >...]
  unset(zSources)
  if(DEFINED _SOURCES)
    set(zSources SOURCES ${_SOURCES})
  endif()

  #
  # 启停选项
  #

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

  #
  # 业务逻辑
  #

  if(NOT DEFINED zProperties)
    set(zProperties PROPERTIES)
  endif()
  # 在 Debug 构建下，循惯例以 d 后缀
  if(NOT DEBUG_POSTFIX IN_LIST zProperties)
    list(APPEND zProperties DEBUG_POSTFIX "d")
  endif()
  # 以原始名而非修饰名作为输出文件名
  if(NOT OUTPUT_NAME IN_LIST zProperties)
    list(APPEND zProperties OUTPUT_NAME "${sName}")
  endif()
  # 在 Unix-like 系统上，库循惯例以 lib 前缀；在 Windows 系统上，静态库循 Boost 风格以 lib 前缀
  if(NOT PREFIX IN_LIST zProperties AND (UNIX OR sType STREQUAL STATIC))
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

  post_build_copy_link_library_files("${sName}" INCLUDE_ITSELF RECURSE)

  get_toolset_architecture_address_model_tag(sTag)
  install(
    TARGETS             "${sName}"
    ARCHIVE DESTINATION "lib/${sTag}$<$<CONFIG:Debug>:d>/"
    LIBRARY DESTINATION "lib/${sTag}$<$<CONFIG:Debug>:d>/"
    RUNTIME DESTINATION "bin/${sTag}$<$<CONFIG:Debug>:d>/")

endfunction()
