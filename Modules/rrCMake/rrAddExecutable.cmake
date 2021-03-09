# zhengrr
# 2017-12-18 – 2021-03-02
# Unlicense

cmake_minimum_required(VERSION 3.10)
cmake_policy(VERSION 3.10)

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

#[=======================================================================[.rst:
.. command:: rr_add_executable

  基于 ``add_executeble`` 命令，提供更多选项和功能。

  .. code-block:: cmake

    rr_add_executable(
      <name> <argument-of-"add_executable"-command>...
      [PROPERTIES          {<property-key> <property-value>}...]
      [COMPILE_DEFINITIONS {<INTERFACE|PUBLIC|PRIVATE> <definition>...}...]
      [COMPILE_FEATURES    {<INTERFACE|PUBLIC|PRIVATE> <feature>...}...]
      [COMPILE_OPTIONS     {<INTERFACE|PUBLIC|PRIVATE> <option>...}...]
      [INCLUDE_DIRECTORIES {<INTERFACE|PUBLIC|PRIVATE> <directory>...}...]
      [LINK_DIRECTORIES    {<INTERFACE|PUBLIC|PRIVATE> <directory>...}...]
      [LINK_LIBRARIES      {<INTERFACE|PUBLIC|PRIVATE> <library>...}...]
      [LINK_OPTIONS        {<INTERFACE|PUBLIC|PRIVATE> <option>...}...]
      [SOURCES             {<INTERFACE|PUBLIC|PRIVATE> <source>...}...])

  参见：

  - `add_executable <https://cmake.org/cmake/help/latest/command/add_executable.html>`_
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
function(rr_add_executable sName)
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

  rr_check_cmake_name("${sName}" AUTHOR_WARNING)
  foreach(sMutValKw IN LISTS zMutValKws)
    if(DEFINED "_${sMutValKw}")
      list(LENGTH "_${sMutValKw}" nLen)
      if(nLen EQUAL 0)
        message(AUTHOR_WARNING "Keyword ${sMutValKw} is used, but without value, ignored.")
        unset("_${sMutValKw}")
      endif()
    endif()
  endforeach()

  add_executable("${sName}" ${_UNPARSED_ARGUMENTS})
  if(DEFINED _PROPERTIES)
    set_target_properties("${sName}" PROPERTIES ${_PROPERTIES})
  endif()
  if(DEFINED _COMPILE_DEFINITIONS)
    target_compile_definitions("${sName}" ${_COMPILE_DEFINITIONS})
  endif()
  if(DEFINED _COMPILE_FEATURES)
    target_compile_features("${sName}" ${_COMPILE_FEATURES})
  endif()
  if(DEFINED _COMPILE_OPTIONS)
    target_compile_options("${sName}" ${_COMPILE_OPTIONS})
  endif()
  if(DEFINED _INCLUDE_DIRECTORIES)
    target_include_directories("${sName}" ${_INCLUDE_DIRECTORIES})
  endif()
  if(DEFINED _LINK_DIRECTORIES)
    target_link_directories("${sName}" ${_LINK_DIRECTORIES})
  endif()
  if(DEFINED _LINK_LIBRARIES)
    target_link_libraries("${sName}" ${_LINK_LIBRARIES})
  endif()
  if(DEFINED _LINK_OPTIONS)
    target_link_options("${sName}" ${_LINK_OPTIONS})
  endif()
  if(DEFINED _SOURCES)
    target_sources("${sName}" ${_SOURCES})
  endif()
endfunction()

#[=======================================================================[.rst:
.. command:: rr_add_executable_with_convention

  类似 ``rr_add_executable`` 命令，另依据惯例进行更多配置：

  - 默认置否的构建开关
  - 在调试模式下，可执行文件以 d 后缀
  - 构建完成后，复制已知依赖到可执行文件目录
  - 安装时，将可执行文件复制到形似 bin/<tag>[d] 的目录中

  参见：

  - :command:`rr_add_executable`
  - `option <https://cmake.org/cmake/help/latest/command/option.html>`_
  - `install <https://cmake.org/cmake/help/latest/command/install.html>`_

#]=======================================================================]
function(rr_add_executable_with_convention sName)
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

  rr_check_cmake_name("${sName}" AUTHOR_WARNING)
  foreach(sMutValKw IN LISTS zMutValKws)
    if(DEFINED "_${sMutValKw}")
      list(LENGTH "_${sMutValKw}" nLen)
      if(nLen EQUAL 0)
        message(AUTHOR_WARNING "Keyword ${sMutValKw} is used, but without value, ignored.")
        unset("_${sMutValKw}")
      endif()
    endif()
  endforeach()

  # 默认置否的构建开关
  string(TOUPPER "${sName}" sNameUpper)
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

  # 在调试模式下，可执行文件以 d 后缀
  if(NOT DEBUG_POSTFIX IN_LIST _PROPERTIES)
    list(APPEND _PROPERTIES DEBUG_POSTFIX "d")
  endif()

  add_executable("${sName}" ${_UNPARSED_ARGUMENTS})
  if(DEFINED _PROPERTIES)
    set_target_properties("${sName}" PROPERTIES ${_PROPERTIES})
  endif()
  if(DEFINED _COMPILE_DEFINITIONS)
    target_compile_definitions("${sName}" ${_COMPILE_DEFINITIONS})
  endif()
  if(DEFINED _COMPILE_FEATURES)
    target_compile_features("${sName}" ${_COMPILE_FEATURES})
  endif()
  if(DEFINED _COMPILE_OPTIONS)
    target_compile_options("${sName}" ${_COMPILE_OPTIONS})
  endif()
  if(DEFINED _INCLUDE_DIRECTORIES)
    target_include_directories("${sName}" ${_INCLUDE_DIRECTORIES})
  endif()
  if(DEFINED _LINK_DIRECTORIES)
    target_link_directories("${sName}" ${_LINK_DIRECTORIES})
  endif()
  if(DEFINED _LINK_LIBRARIES)
    target_link_libraries("${sName}" ${_LINK_LIBRARIES})
  endif()
  if(DEFINED _LINK_OPTIONS)
    target_link_options("${sName}" ${_LINK_OPTIONS})
  endif()
  if(DEFINED _SOURCES)
    target_sources("${sName}" ${_SOURCES})
  endif()

  # 构建完成后，复制已知依赖到可执行文件目录
  rr_post_build_copy_link_library_files("${sName}" INCLUDE_ITSELF RECURSE)

  # 安装时，将可执行文件复制到形似 bin/<tag>[d] 的目录中
  rr_get_taa_tag(sTag)
  install(
    TARGETS             "${sName}"
    RUNTIME DESTINATION "bin/${sTag}$<$<CONFIG:Debug>:d>/")
endfunction()
