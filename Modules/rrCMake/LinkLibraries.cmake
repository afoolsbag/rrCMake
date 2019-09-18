# zhengrr
# 2019-04-15 – 2019-09-18
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
#       <variable> <target> [INCLUDE_ITSELF] [RECURSE]
#     )
function(get_link_libraries _VARIABLE _TARGET)
  set(zOptKws    INCLUDE_ITSELF
                 RECURSE)
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
  set(tTarget "${_TARGET}")
  if(NOT TARGET "${tTarget}")
    message(FATAL_ERROR "The name isn't a target: ${_TARGET}.")
  endif()

  # INCLUDE_ITSELF
  set(bIncludeItself ${_INCLUDE_ITSELF})

  # RECURSE
  set(bRecurse ${_RECURSE})

  #-----------------------------------------------------------------------------
  # 查找链接库

  # 获取直接依赖
  get_target_property(sType "${tTarget}" TYPE)
  if(sType STREQUAL INTERFACE_LIBRARY)
    get_target_property(zItems "${tTarget}" INTERFACE_LINK_LIBRARIES)
  else()
    get_target_property(zTemps1 "${tTarget}" INTERFACE_LINK_LIBRARIES)
    get_target_property(zTemps2 "${tTarget}" LINK_LIBRARIES)
	set(zItems ${zTemps1} ${zTemps2})
  endif()

  if(bIncludeItself)
    list(APPEND zItems "${tTarget}")
  endif()

  list(REMOVE_DUPLICATES zItems)

  # 获取间接依赖
  if(bRecurse)
    set(zTodos ${zItems})
    set(zDones)

	list(LENGTH zTodos nLen)
    while(NOT nLen EQUAL 0)
      foreach(sTodo IN LISTS zTodos)
        if(TARGET "${sTodo}")
          get_target_property(sType "${sTodo}" TYPE)
          if(sType STREQUAL INTERFACE_LIBRARY)
            get_target_property(zTemps "${sTodo}" INTERFACE_LINK_LIBRARIES)
            list(APPEND zTodos ${zTemps})
          else()
            get_target_property(zTemps1 "${sTodo}" INTERFACE_LINK_LIBRARIES)
            get_target_property(zTemps2 "${sTodo}" LINK_LIBRARIES)
            list(APPEND zTodos ${zTemps1} ${zTemps2})
          endif()
        endif()
        list(APPEND zDones "${sTodo}")
      endforeach()

      list(REMOVE_DUPLICATES zTodos)
      list(REMOVE_ITEM zTodos ${zDones})
	  list(LENGTH zTodos nLen)
    endwhile()

	set(zItems ${zDones})
  endif()

  set("${vVariable}" ${zItems} PARENT_SCOPE)
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
#       <variable> <target> [INCLUDE_ITSELF] [RECURSE]
#     )
function(get_link_files _VARIABLE _TARGET)
  set(zOptKws    INCLUDE_ITSELF
                 RECURSE)
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
  set(tTarget "${_TARGET}")
  if(NOT TARGET "${tTarget}")
    message(FATAL_ERROR "The name isn't a target: ${_TARGET}.")
  endif()

  # INCLUDE_ITSELF
  unset(oIncludeItself)
  if(_INCLUDE_ITSELF)
    set(oIncludeItself INCLUDE_ITSELF)
  endif()

  # RECURSE
  unset(oRecurse)
  if(_RECURSE)
    set(oRecurse RECURSE)
  endif()

  #-----------------------------------------------------------------------------
  # 查找链接文件

  get_link_libraries(zLibs "${sTarget}" ${oIncludeItself} ${oRecurse})

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
#       [INCLUDE_ITSELF]
#       [RECURSE]
#       [DESTINATION <directory>...]
#     )
function(post_build_copy_link_files _TARGET)
  set(zOptKws    INCLUDE_ITSELF
                 RECURSE)
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

  # INCLUDE_ITSELF
  unset(sIncludeItself)
  if(_INCLUDE_ITSELF)
    set(sIncludeItself INCLUDE_ITSELF)
  endif()

  # RECURSE
  unset(sRecurse)
  if(_RECURSE)
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

  get_link_files(zFiles "${sTarget}" ${sIncludeItself} ${sRecurse})
  if(zFiles)
    foreach(sDest IN LISTS zDestination)
      add_custom_command(
        TARGET "${sTarget}" POST_BUILD
        COMMAND "${CMAKE_COMMAND}" "-E" "copy_if_different"
                ${zFiles}
                "${sDest}"
        COMMENT "Copying link files to ${sDest}...")
    endforeach()
  endif()
endfunction()
