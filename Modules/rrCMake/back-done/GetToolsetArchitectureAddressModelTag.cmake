# zhengrr
# 2018-06-06 – 2019-11-20
# Unlicense

cmake_minimum_required(VERSION 3.10)
cmake_policy(VERSION 3.10)

include_guard()  # 3.10

if(NOT COMMAND check_name_with_cmake_rules)
  include("${CMAKE_CURRENT_LIST_DIR}/CheckNameWithCMakeRules.cmake")
endif()
if(NOT COMMAND get_toolset_tag)
  include("${CMAKE_CURRENT_LIST_DIR}/GetToolsetTag.cmake")
endif()
if(NOT COMMAND get_architecture_tag)
  include("${CMAKE_CURRENT_LIST_DIR}/GetArchitectureTag.cmake")
endif()
if(NOT COMMAND get_address_model_tag)
  include("${CMAKE_CURRENT_LIST_DIR}/GetAddressModelTag.cmake")
endif()

#.rst:
# .. command::get_toolset_architecture_address_model_tag
#
#   获取工具集、架构和地址模型标签（get toolset architecture address model tag）。
#
#   .. code-block:: cmake
#
#     get_toolset_architecture_address_model_tag(
#       <variable>
#     )
#
#   参见：
#
#   - :command:`check_name_with_cmake_rules`
#   - :command:`get_toolset_tag`
#   - :command:`get_architecture_tag`
#   - :command:`get_address_model_tag`
#
function(get_toolset_architecture_address_model_tag xVariable)
  check_name_with_cmake_rules("${xVariable}" AUTHOR_WARNING)
  get_toolset_tag(sTool)
  get_architecture_tag(sArch)
  get_address_model_tag(sAddr)
  set("${xVariable}" "${sTool}${sArch}${sAddr}" PARENT_SCOPE)
endfunction()
