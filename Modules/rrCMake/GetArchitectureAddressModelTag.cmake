# zhengrr
# 2018-06-06 – 2019-11-18
# Unlicense

cmake_minimum_required(VERSION 3.10)
cmake_policy(VERSION 3.10)

include_guard()  # 3.10

if(NOT COMMAND get_architecture_tag)
  include("${CMAKE_CURRENT_LIST_DIR}/GetArchitectureTag.cmake")
endif()
if(NOT COMMAND get_address_model_tag)
  include("${CMAKE_CURRENT_LIST_DIR}/GetAddressModelTag.cmake")
endif()

#===============================================================================
#.rst:
# .. command::get_architecture_address_model_tag
#
#   获取架构和地址模型标签（get architecture address model tag）。
#
#   .. code-block:: cmake
#
#     get_architecture_address_model_tag(
#       <variable>
#     )
function(get_architecture_address_model_tag vVariable)
  get_architecture_tag(sArch)
  get_address_model_tag(sAddr)
  set(${vVariable} "${sArch}${sAddr}" PARENT_SCOPE)
endfunction()
