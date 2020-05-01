#            _____ ___  ___      _
#           /  __ \|  \/  |     | |
#  _ __ _ __| /  \/| .  . | __ _| | _____
# | '__| '__| |    | |\/| |/ _` | |/ / _ \ zhengrr
# | |  | |  | \__/\| |  | | (_| |   <  __/ 2016-10-08 – 2020-05-01
# |_|  |_|   \____/\_|  |_/\__,_|_|\_\___| Unlicense

#.rst:
# rrCMake
# -------
#
# 为 zhengrr 定制的 CMake 工具集。
#

cmake_minimum_required(VERSION 3.10)
cmake_policy(VERSION 3.10)

include_guard()  # 3.10

#.rst:
# .. command:: _rrcmake_include_module_files
#
#   遍历查找 rrCMake 目录下所有 *.cmake 模块，并将其包含。
#
function(_rrcmake_include_module_files)
  file(GLOB zModuleFiles "${CMAKE_CURRENT_LIST_DIR}/rrCMake/*.cmake")
  foreach(pModuleFile IN LISTS zModuleFiles)
    include("${pModuleFile}")
  endforeach()
endfunction()

# sctipt
_rrcmake_include_module_files()
