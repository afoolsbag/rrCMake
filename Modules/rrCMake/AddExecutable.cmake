# zhengrr
# 2017-12-18 – 2019-08-09
# Unlicense

cmake_minimum_required(VERSION 3.10)
cmake_policy(VERSION 3.10)

include_guard()  # 3.10

if(NOT COMMAND get_toolset_architecture_address_model_tag)
  include("${CMAKE_CURRENT_LIST_DIR}/LibraryTag.cmake")
endif()

if(NOT COMMAND post_build_copy_link_files)
  include("${CMAKE_CURRENT_LIST_DIR}/LinkLibraries.cmake")
endif()

#===============================================================================
#.rst:
# .. command:: add_executable_ex
#
#   添加可执行目标到项目，扩展功能（extend）。
#
#   .. code-block:: cmake
#
#     add_executable_ex(
#       <name> <argument-of-add-executable>...
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
#   - `add_executable <https://cmake.org/cmake/help/latest/command/add_executable.html>`_
#   - `set_target_properties <https://cmake.org/cmake/help/latest/command/set_target_properties.html>`_
#   - `target_compile_definitions <https://cmake.org/cmake/help/latest/command/target_compile_definitions.html>`_
#   - `target_compile_features <https://cmake.org/cmake/help/latest/command/target_compile_features.html>`_
#   - `target_compile_options <https://cmake.org/cmake/help/latest/command/target_compile_options.html>`_
#   - `target_include_directories <https://cmake.org/cmake/help/latest/command/target_include_directories.html>`_
#   - `target_link_directories <https://cmake.org/cmake/help/latest/command/target_link_directories.html>`_
#   - `target_link_libraries <https://cmake.org/cmake/help/latest/command/target_link_libraries.html>`_
#   - `target_link_options <https://cmake.org/cmake/help/latest/command/target_link_options.html>`_
#   - `target_sources <https://cmake.org/cmake/help/latest/command/target_sources.html>`_
function(add_executable_ex _NAME)
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

  # NAME
  set(sName "${_NAME}")

  # ARGUMENTS_OF_ADD_EXECUTABLE
  set(zArgumentsOfAddExecutable ${_UNPARSED_ARGUMENTS})

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

  add_executable("${sName}" ${zArgumentsOfAddExecutable})
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
# .. command:: add_executable_con
#
#   添加库目标到项目，遵循惯例（convention）。
#
#   .. code-block:: cmake
#
#     add_executable_con(
#       <name> <argument-of-add-executable>...
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
#   - `option <https://cmake.org/cmake/help/latest/command/option.html>`_
#   - `install <https://cmake.org/cmake/help/latest/command/install.html>`_
function(add_executable_con _NAME)
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

  # NAME
  set(sName "${_NAME}")

  string(TOUPPER "${sName}" sNameUpper)

  # ARGUMENTS_OF_ADD_EXECUTABLE
  set(zArgumentsOfAddExecutable ${_UNPARSED_ARGUMENTS})

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

  string(TOUPPER "${PROJECT_NAME}" sProjectNameUpper)
  string(REGEX REPLACE "^${sProjectNameUpper}" "" sTrimmedNameUpper "${sNameUpper}")
  string(LENGTH "${sTrimmedNameUpper}" sLen)
  if(0 LESS sLen)
    set(vOptVar ${sProjectNameUpper}_${sTrimmedNameUpper}_EXECUTABLE)
  else()
    set(vOptVar ${sProjectNameUpper}_EXECUTABLE)
  endif()

  option(${vOptVar} "Build ${_NAME} executable." ON)
  if(NOT ${vOptVar})
    return()
  endif()

  #-----------------------------------------------------------------------------
  # 添加目标并配置

  if(NOT DEFINED zProperties)
    set(zProperties PROPERTIES)
  endif()
  # 在 Debug 构建下，循惯例以 d 后缀。
  if(NOT DEBUG_POSTFIX IN_LIST zProperties)
    list(APPEND zProperties DEBUG_POSTFIX "d")
  endif()
  if(NOT OUTPUT_NAME IN_LIST zProperties)
    list(APPEND zProperties OUTPUT_NAME "${sName}")
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
    ${zSources}
  )

  post_build_copy_link_files("${sName}" RECURSE)

  get_toolset_architecture_address_model_tag(sTag)
  install(
    TARGETS     "${sName}"
    DESTINATION "bin/${sTag}$<$<CONFIG:Debug>:d>/")
endfunction()
