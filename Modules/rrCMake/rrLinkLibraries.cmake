# zhengrr
# 2019-04-15 – 2021-01-21
# Unlicense

cmake_minimum_required(VERSION 3.10)
cmake_policy(VERSION 3.10)

include_guard()  # 3.10

if(NOT COMMAND rr_check_cmake_name OR
   NOT COMMAND rr_check_no_argn OR
   NOT COMMAND rr_check_target)
  include("${CMAKE_CURRENT_LIST_DIR}/rrCheck.cmake")
endif()

#[=======================================================================[.rst:
.. command:: _rrlinklibraries_get_via_properties

  通过（目标）的属性来获取（其链接的库）。

  .. code-block:: cmake

    _rrlinklibraries_get_via_properties(<variable> <target>)

  参见：

  - `INTERFACE_LINK_LIBRARIES <https://cmake.org/cmake/help/latest/prop_tgt/INTERFACE_LINK_LIBRARIES.html>`_
  - `LINK_LIBRARIES <https://cmake.org/cmake/help/latest/prop_tgt/LINK_LIBRARIES.html>`_

#]=======================================================================]
function(_rrlinklibraries_get_via_properties xVariable tTarget)
  #
  # 前置断言
  #

  rr_check_no_argn("${ARGN}" FATAL_ERROR)
  rr_check_cmake_name("${xVariable}" AUTHOR_WARNING)
  rr_check_target("${tTarget}" FATAL_ERROR)

  #
  # 业务逻辑
  #

  get_target_property(sType "${tTarget}" TYPE)
  if(sType STREQUAL "INTERFACE_LIBRARY")
    get_target_property(zItems "${tTarget}" INTERFACE_LINK_LIBRARIES)
    set("${xVariable}" ${zItems} PARENT_SCOPE)
  else()
    get_target_property(zItems1 "${tTarget}" INTERFACE_LINK_LIBRARIES)
    get_target_property(zItems2 "${tTarget}" LINK_LIBRARIES)
    set("${xVariable}" ${zItems1} ${zItems2} PARENT_SCOPE)
  endif()
endfunction()

#[=======================================================================[.rst:
.. command:: rr_get_link_libraries

  获取链接库。

  .. code-block:: cmake

    rr_get_link_libraries(<variable> <target> [INCLUDE_ITSELF] [RECURSE])

  参见：

  - `INTERFACE_LINK_LIBRARIES <https://cmake.org/cmake/help/latest/prop_tgt/INTERFACE_LINK_LIBRARIES.html>`_
  - `LINK_LIBRARIES <https://cmake.org/cmake/help/latest/prop_tgt/LINK_LIBRARIES.html>`_

#]=======================================================================]
function(rr_get_link_libraries xVariable tTarget)
  set(zOptKws    INCLUDE_ITSELF
                 RECURSE)
  set(zOneValKws)
  set(zMutValKws)
  cmake_parse_arguments(PARSE_ARGV 2 "" "${zOptKws}" "${zOneValKws}" "${zMutValKws}")

  #
  # 前置断言
  #

  rr_check_no_argn("${_UNPARSED_ARGUMENTS}" FATAL_ERROR)
  rr_check_cmake_name("${xVariable}" AUTHOR_WARNING)
  rr_check_target("${tTarget}" FATAL_ERROR)

  #
  # 业务逻辑
  #

  # 查找直接链接库
  _rrlinklibraries_get_via_properties(zItems "${tTarget}")

  if(_INCLUDE_ITSELF)
    list(APPEND zItems "${tTarget}")
  endif()

  list(REMOVE_DUPLICATES zItems)

  # 查找间接链接库
  if(_RECURSE)
    set(zTodos ${zItems})
    set(zDones)

    list(LENGTH zTodos nLen)
    while(NOT nLen EQUAL 0)

      foreach(sTodo IN LISTS zTodos)
        if(TARGET "${sTodo}")
          _rrlinklibraries_get_via_properties(zTemps "${sTodo}")
          list(APPEND zTodos ${zTemps})
        endif()
        list(APPEND zDones "${sTodo}")
      endforeach()

      list(REMOVE_DUPLICATES zTodos)
      list(REMOVE_ITEM zTodos ${zDones})

      list(LENGTH zTodos nLen)
    endwhile()

    set(zItems ${zDones})
  endif()

  # 返回结果
  set("${xVariable}" ${zItems} PARENT_SCOPE)
endfunction()

#[=======================================================================[.rst:
.. command:: rr_get_link_library_files

  获取链接文件。

  .. code-block:: cmake

    rr_get_link_library_files(<variable> <target> [INCLUDE_ITSELF] [RECURSE])

  参见：

  - `cmake-generator-expressions(7) <https://cmake.org/cmake/help/latest/manual/cmake-generator-expressions.7.html>`_

#]=======================================================================]
function(rr_get_link_library_files xVariable tTarget)
  set(zOptKws    INCLUDE_ITSELF
                 RECURSE)
  set(zOneValKws)
  set(zMutValKws)
  cmake_parse_arguments(PARSE_ARGV 2 "" "${zOptKws}" "${zOneValKws}" "${zMutValKws}")

  #
  # 前置断言
  #

  rr_check_no_argn("${_UNPARSED_ARGUMENTS}" FATAL_ERROR)
  rr_check_cmake_name("${xVariable}" AUTHOR_WARNING)
  rr_check_target("${tTarget}" FATAL_ERROR)

  #
  # 业务逻辑
  #

  if(_INCLUDE_ITSELF)
    set(oIncludeItself "INCLUDE_ITSELF")
  else()
    set(oIncludeItself)
  endif()

  if(_RECURSE)
    set(oRecurse "RECURSE")
  else()
    set(oRecurse)
  endif()

  # 查找链接库
  rr_get_link_libraries(zLibs "${tTarget}" ${oIncludeItself} ${oRecurse})

  # 查找链接库对应的文件
  set(zFiles)

  foreach(sLib IN LISTS zLibs)
    if(TARGET "${sLib}")
      get_target_property(sType "${sLib}" TYPE)
      if(sType STREQUAL SHARED_LIBRARY)
        list(APPEND zFiles "$<TARGET_FILE:${sLib}>")
      endif()
    elseif(EXISTS "${sLib}")
      list(APPEND zFiles "${sLib}")
    endif()
  endforeach()

  list(REMOVE_DUPLICATES zFiles)

  # 返回结果
  set("${xVariable}" ${zFiles} PARENT_SCOPE)
endfunction()

#[=======================================================================[.rst:
.. command:: rr_post_build_copy_link_library_files

  构建后复制链接库文件。

  .. code-block:: cmake

    rr_post_build_copy_link_library_files(
      <target>
      [INCLUDE_ITSELF]
      [RECURSE]
      [DESTINATION <directory>...])

  参见：

  - :command:`get_link_library_files`

#]=======================================================================]
function(rr_post_build_copy_link_library_files tTarget)
  set(zOptKws    INCLUDE_ITSELF
                 RECURSE)
  set(zOneValKws)
  set(zMutValKws DESTINATION)
  cmake_parse_arguments(PARSE_ARGV 1 "" "${zOptKws}" "${zOneValKws}" "${zMutValKws}")

  #
  # 前置断言
  #

  rr_check_no_argn("${_UNPARSED_ARGUMENTS}" FATAL_ERROR)
  rr_check_target("${tTarget}" FATAL_ERROR)

  #
  # 业务逻辑
  #

  if(_INCLUDE_ITSELF)
    set(oIncludeItself "INCLUDE_ITSELF")
  else()
    set(oIncludeItself)
  endif()

  if(_RECURSE)
    set(oRecurse "RECURSE")
  else()
    set(oRecurse)
  endif()

  if(DEFINED _DESTINATION)
    set(zDestination ${_DESTINATION})
  else()
    set(zDestination "$<TARGET_FILE_DIR:${tTarget}>")
  endif()

  # 查找链接库文件
  rr_get_link_library_files(zFiles "${tTarget}" ${oIncludeItself} ${oRecurse})

  if(zFiles)
    foreach(pDest IN LISTS zDestination)
      add_custom_command(
        TARGET  "${tTarget}" POST_BUILD
        COMMAND "${CMAKE_COMMAND}" "-E" "copy_if_different"
                ${zFiles}
                "${pDest}"
        COMMENT "Copying link library files to ${pDest}...")
    endforeach()
  endif()
endfunction()
