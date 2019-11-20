# zhengrr
# 2019-04-15 – 2019-11-20
# Unlicense

cmake_minimum_required(VERSION 3.10)
cmake_policy(VERSION 3.10)

include_guard()  # 3.10

if(NOT COMMAND get_link_library_files)
  include("${CMAKE_CURRENT_LIST_DIR}/GetLinkLibraryFiles.cmake")
endif()

#.rst:
# .. command:: post_build_copy_link_library_files
#
#   构建后复制链接库文件。
#
#   .. code-block:: cmake
#
#     post_build_copy_link_library_files(
#       <target>
#       [INCLUDE_ITSELF]
#       [RECURSE]
#       [DESTINATION <directory>...]
#     )
#
#   参见：
#
#   - :command:`get_link_library_files`
#
function(post_build_copy_link_library_files _TARGET)
  set(zOptKws    INCLUDE_ITSELF
                 RECURSE)
  set(zOneValKws)
  set(zMutValKws DESTINATION)
  cmake_parse_arguments(PARSE_ARGV 1 "" "${zOptKws}" "${zOneValKws}" "${zMutValKws}")

  #
  # 参数规整
  #

  if(DEFINED _UNPARSED_ARGUMENTS)
    message(FATAL_ERROR "Unexpected arguments: ${_UNPARSED_ARGUMENTS}.")
  endif()

  # <target>
  set(tTarget "${_TARGET}")
  if(NOT TARGET "${tTarget}")
    message(FATAL_ERROR "The name isn't a target: ${tTarget}.")
  endif()

  # [INCLUDE_ITSELF]
  unset(oIncludeItself)
  if(_INCLUDE_ITSELF)
    set(oIncludeItself INCLUDE_ITSELF)
  endif()

  # [RECURSE]
  unset(oRecurse)
  if(_RECURSE)
    set(oRecurse RECURSE)
  endif()

  # [DESTINATION <directory>...]
  if(DEFINED _DESTINATION)
    set(zDestination ${_DESTINATION})
  else()
    set(zDestination "$<TARGET_FILE_DIR:${tTarget}>")
  endif()

  #
  # 构建后复制链接库文件
  #

  # 查找链接库文件
  get_link_library_files(zFiles "${tTarget}" ${oIncludeItself} ${oRecurse})

  if(zFiles)
    foreach(pDest IN LISTS zDestination)
      add_custom_command(
        TARGET  "${tTarget}" POST_BUILD
        COMMAND "${CMAKE_COMMAND}" "-E" "copy_if_different"
                ${zFiles}
                "${pDest}"
        COMMENT "Copying link files to ${pDest}...")
    endforeach()
  endif()

endfunction()
