# zhengrr
# 2017-12-18 – 2019-11-20
# Unlicense

cmake_minimum_required(VERSION 3.10)
cmake_policy(VERSION 3.10)

include_guard()  # 3.10

if(NOT COMMAND add_executable_ex)
  include("${CMAKE_CURRENT_LIST_DIR}/AddExecutableEx.cmake")
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
# .. command:: add_executable_con
#
#   添加库目标到项目，遵循惯例（convention）。
#
#   .. code-block:: cmake
#
#     add_executable_con(
#       <name> <argument-of-add_executable>...
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
#   - :command:`add_executable_ex`
#   - :command:`check_name_with_cmake_rules`
#   - :command:`get_toolset_architecture_address_model_tag`
#   - :command:`post_build_copy_link_library_files`
#   - `option <https://cmake.org/cmake/help/latest/command/option.html>`_
#   - `install <https://cmake.org/cmake/help/latest/command/install.html>`_
#
function(add_executable_con _NAME)
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

  # <argument-of-add_executable>...
  set(zArgumentsOfAddExecutable ${_UNPARSED_ARGUMENTS})

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

  string(TOUPPER "${PROJECT_NAME}" sProjectNameUpper)
  string(REGEX REPLACE "^${sProjectNameUpper}_?" "" sTrimmedNameUpper "${sNameUpper}")
  string(LENGTH "${sTrimmedNameUpper}" nLen)
  if(0 LESS nLen)
    set(xOptVar ${sProjectNameUpper}_${sTrimmedNameUpper}_EXECUTABLE)
  else()
    set(xOptVar ${sProjectNameUpper}_EXECUTABLE)
  endif()

  option(${xOptVar} "Build ${sName} executable." ON)
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
  if(NOT DEBUG_POSTFIX IN_LIST ozProperties)
    list(APPEND ozProperties DEBUG_POSTFIX "d")
  endif()
  # 以原始名而非修饰名作为输出文件名
  if(NOT OUTPUT_NAME IN_LIST ozProperties)
    list(APPEND ozProperties OUTPUT_NAME "${sName}")
  endif()

  add_executable_ex(
    "${sName}" ${zArgumentsOfAddExecutable}
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
    RUNTIME DESTINATION "bin/${sTag}$<$<CONFIG:Debug>:d>/")

endfunction()
