# zhengrr
# 2019-04-15 – 2019-08-09
# Unlicense

cmake_minimum_required(VERSION 3.10)
cmake_policy(VERSION 3.10)

include_guard()  # 3.10

#===============================================================================
#.rst:
# .. command:: get_link_libraries
#
#   获取链接库。
#
#   .. code-block:: cmake
#
#     get_link_libraries(
#       <variable> <target> [RECURSE]
#     )
function(get_link_libraries _VARIABLE _TARGET)
  set(zOptKws    RECURSE)
  set(zOneValKws)
  set(zMutValKws)
  cmake_parse_arguments(PARSE_ARGV 2 "" "${zOptKws}" "${zOneValKws}" "${zMutValKws}")

  #-----------------------------------------------------------------------------
  # 规整化参数

  # UNPARSED_ARGUMENTS 
  if(DEFINED _UNPARSED_ARGUMENTS)
    message(FATAL_ERROR "Unexpected arguments: ${_UNPARSED_ARGUMENTS}.")
  endif()

  # VARIABLE
  set(vVariable "${_VARIABLE}")

  # TARGET
  set(sTarget "${_TARGET}")

  if(NOT TARGET "${sTarget}")
    message(FATAL_ERROR "The name isn't a target: ${_TARGET}.")
  endif()

  # RECURSE
  set(sRecurse "${_RECURSE}")

  #-----------------------------------------------------------------------------
  # 查找链接库

  if(sRecurse)

    set(zRecItems)                                              # recursive
    get_target_property(zNonItems "${sTarget}" LINK_LIBRARIES)  # non-recursive
    list(REMOVE_DUPLICATES zNonItems)

    while(zNonItems)
      foreach(sNonItem IN LISTS zNonItems)
        if(TARGET "${sNonItem}")
          get_target_property(sType "${sNonItem}" TYPE)
          if(sType STREQUAL INTERFACE_LIBRARY)
            get_target_property(zTmpItems "${sNonItem}" INTERFACE_LINK_LIBRARIES)
            list(APPEND zNonItems ${zTmpItems})
          else()
            get_target_property(zTmpItems "${sNonItem}" LINK_LIBRARIES)
            list(APPEND zNonItems ${zTmpItems})
          endif()
        endif()
        list(APPEND zRecItems "${sNonItem}")
      endforeach()
      list(REMOVE_DUPLICATES zNonItems)
      list(REMOVE_ITEM zNonItems ${zRecItems})
    endwhile()

    set("${vVariable}" ${zRecItems} PARENT_SCOPE)

  else()

    get_target_property(zItems "${sTarget}" LINK_LIBRARIES)
    list(REMOVE_DUPLICATES zItems)

    set("${vVariable}" ${zItems} PARENT_SCOPE)

  endif()
endfunction()

#===============================================================================
#.rst:
# .. command:: get_link_files
#
#   获取链接文件。
#
#   .. code-block:: cmake
#
#     get_link_files(
#       <variable> <target> [RECURSE]
#     )
function(get_link_files _VARIABLE _TARGET)
  set(zOptKws    RECURSE)
  set(zOneValKws)
  set(zMutValKws)
  cmake_parse_arguments(PARSE_ARGV 2 "" "${zOptKws}" "${zOneValKws}" "${zMutValKws}")

  #-----------------------------------------------------------------------------
  # 规整化参数

  # UNPARSED_ARGUMENTS 
  if(DEFINED _UNPARSED_ARGUMENTS)
    message(FATAL_ERROR "Unexpected arguments: ${_UNPARSED_ARGUMENTS}.")
  endif()

  # VARIABLE
  set(vVariable "${_VARIABLE}")

  # TARGET
  set(sTarget "${_TARGET}")

  if(NOT TARGET "${sTarget}")
    message(FATAL_ERROR "The name isn't a target: ${_TARGET}.")
  endif()

  # RECURSE
  unset(sRecurse)
  if(DEFINED _RECURSE)
    set(sRecurse RECURSE)
  endif()

  #-----------------------------------------------------------------------------
  # 查找链接文件

  get_link_libraries(zLibs ${sTarget} ${sRecurse})
  unset(zFiles)

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
  set("${vVariable}" ${zFiles} PARENT_SCOPE)
endfunction()

#===============================================================================
#.rst:
# .. command:: post_build_copy_link_files
#
#   构建后复制链接文件。
#
#   .. code-block:: cmake
#
#     post_build_copy_link_files(
#       <target>
#       [RECURSE]
#       [DESTINATION <directory>...]
#     )
function(post_build_copy_link_files _TARGET)
  set(zOptKws    RECURSE)
  set(zOneValKws)
  set(zMutValKws DESTINATION)
  cmake_parse_arguments(PARSE_ARGV 1 "" "${zOptKws}" "${zOneValKws}" "${zMutValKws}")

  #-----------------------------------------------------------------------------
  # 规整化参数

  # UNPARSED_ARGUMENTS 
  if(DEFINED _UNPARSED_ARGUMENTS)
    message(FATAL_ERROR "Unexpected arguments: ${_UNPARSED_ARGUMENTS}.")
  endif()

  # TARGET
  set(sTarget "${_TARGET}")

  if(NOT TARGET "${sTarget}")
    message(FATAL_ERROR "The name isn't a target: ${_TARGET}.")
  endif()

  # RECURSE
  unset(sRecurse)
  if(DEFINED _RECURSE)
    set(sRecurse RECURSE)
  endif()

  # DESTINATION
  if(DEFINED _DESTINATION)
    set(zDestination ${_DESTINATION})
  else()
    set(zDestination "$<TARGET_FILE_DIR:${sTarget}>")
  endif()

  #-----------------------------------------------------------------------------
  # 构建后复制链接库

  get_link_files(zFiles "${sTarget}" ${sRecurse})

  foreach(sDest IN LISTS zDestination)
    add_custom_command(
      TARGET "${sTarget}" POST_BUILD
      COMMAND "${CMAKE_COMMAND}" "-E" "copy_if_different"
              ${zFiles}
              "${sDest}"
      COMMENT "Copying link files to ${sDest}...")
  endforeach()
endfunction()
