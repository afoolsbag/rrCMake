#            _____ ___  ___      _
#           /  __ \|  \/  |     | |
#  _ __ _ __| /  \/| .  . | __ _| | _____
# | '__| '__| |    | |\/| |/ _` | |/ / _ \ zhengrr
# | |  | |  | \__/\| |  | | (_| |   <  __/ 2016-10-08 – 2021-01-20
# |_|  |_|   \____/\_|  |_/\__,_|_|\_\___| Unlicense

#[=======================================================================[.rst:
rrCMake
-------

为 zhengrr 定制的 CMake 工具集。

在项目 ``CMakeLists.txt`` 中添加以下代码，以引入该工具集：

.. code-block:: cmake

  list(APPEND CMAKE_MODULE_PATH "path/to/this/Modules")
  include(rrCMake)

#]=======================================================================]

cmake_minimum_required(VERSION 3.10)
cmake_policy(VERSION 3.10)

include_guard()  # 3.10

#[=======================================================================[.rst:
.. command:: _rrcmake_include_module_files

  内部命令：包含模块文件。

  遍历查找此文件所在目录的 ``rrCMake`` 子目录下的所有 ``*.cmake`` 模块，并逐个包含。

#]=======================================================================]
function(_rrcmake_include_module_files)
  file(GLOB zModuleFiles "${CMAKE_CURRENT_LIST_DIR}/rrCMake/*.cmake")
  foreach(pModuleFile IN LISTS zModuleFiles)
    include("${pModuleFile}")
  endforeach()
endfunction()

_rrcmake_include_module_files()
