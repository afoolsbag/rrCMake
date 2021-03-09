CMake
=====

`CMake <https://cmake.org>`_ 是一款跨平台、开源的构建系统，用于生成平台相关的构建系统。

参考
----

`CMake Reference Documentation <https://cmake.org/cmake/help/latest/>`_

- `cmake-buildsystem(7) <https://cmake.org/cmake/help/latest/manual/cmake-buildsystem.7.html>`_
- `cmake-commands(7) <https://cmake.org/cmake/help/latest/manual/cmake-commands.7.html>`_
- `cmake-compile-features(7) <https://cmake.org/cmake/help/latest/manual/cmake-compile-features.7.html>`_
- `cmake-developer(7) <https://cmake.org/cmake/help/latest/manual/cmake-developer.7.html>`_
- `cmake-env-variables(7) <https://cmake.org/cmake/help/latest/manual/cmake-env-variables.7.html>`_
- `cmake-file-api(7) <https://cmake.org/cmake/help/latest/manual/cmake-file-api.7.html>`_
- `cmake-generator-expressions(7) <https://cmake.org/cmake/help/latest/manual/cmake-generator-expressions.7.html>`_
- `cmake-generators(7) <https://cmake.org/cmake/help/latest/manual/cmake-generators.7.html>`_
- `cmake-language(7) <https://cmake.org/cmake/help/latest/manual/cmake-language.7.html>`_
- `cmake-modules(7) <https://cmake.org/cmake/help/latest/manual/cmake-modules.7.html>`_
- `cmake-packages(7) <https://cmake.org/cmake/help/latest/manual/cmake-packages.7.html>`_
- `cmake-policies(7) <https://cmake.org/cmake/help/latest/manual/cmake-policies.7.html>`_
- `cmake-presets(7) <https://cmake.org/cmake/help/latest/manual/cmake-presets.7.html>`_
- `cmake-properties(7) <https://cmake.org/cmake/help/latest/manual/cmake-properties.7.html>`_
- `cmake-qt(7) <https://cmake.org/cmake/help/latest/manual/cmake-qt.7.html>`_
- `cmake-server(7) <https://cmake.org/cmake/help/latest/manual/cmake-server.7.html>`_
- `cmake-toolchains(7) <https://cmake.org/cmake/help/latest/manual/cmake-toolchains.7.html>`_
- `cmake-variables(7) <https://cmake.org/cmake/help/latest/manual/cmake-variables.7.html>`_
- `cpack-generators(7) <https://cmake.org/cmake/help/latest/manual/cpack-generators.7.html>`_

`CMake Community Wiki <https://gitlab.kitware.com/cmake/community/wikis/>`_

- `Useful variables <https://gitlab.kitware.com/cmake/community/wikis/doc/cmake/Useful-Variables>`_

风格
----

**参数**

给命令的参数有三种形式：

- 括号参数 ``[[argument...]]``，不对转义序列和变量引用求值，被当做单个参数
- 引号参数 ``"argument..."``，求值，被当做单个参数
- 裸参数 ``argument...``，求值，其结果被视为列表，并据列表内容被当做任意个参数

**变量**

变量名采用小驼峰、匈牙利风格（``tLowerCamelCase``）；
除非特别说明，引用变量一般建议括上引号（``"${tLowerCamelCase}"``），以避免意外的参数位置偏移；
变量名前缀一般含义如下：

- 前缀 ``b`` 暗示变量值用作真假值（``bBoolean``），其值应取以下四值之一：``TRUE``、``FALSE``、``ON`` 或 ``OFF``
- 前缀 ``e`` 暗示变量值用作表达式（``eExpression``）
- 前缀 ``n`` 暗示变量值用作数字（``nNumber``）
- 前缀 ``o`` 暗示变量值用作选项（``oOption``），若为空则应被忽略，在引用变量时不应括上引号（``${oOption}``）
- 前缀 ``r`` 暗示变量值用作正则表达式（``rRegularExpression``）
- 前缀 ``s`` 暗示变量值用作字符串（``sString``）
- 前缀 ``p`` 暗示变量值用作路径（``pPath``）
- 前缀 ``t`` 暗示变量值用作目标（``tTarget``）
- 前缀 ``v`` 暗示变量值用作版本号（``vVersion``）
- 前缀 ``x`` 暗示变量值用作变量名（``xVariable``）
- 前缀 ``z`` 暗示变量值用作字符串列表（``zStringList``），在引用变量时一般不括上引号（``${zStringList}``）

任何变量值都是字符串，变量名前缀用于暗示该字符串接受的处理方式，并无强制性。

**断言**

按实践经验，CMake 中的错误不易排查，因而在公开的自定义的 CMake 命令中加入断言，牺牲性能以强化纠错能力。

reStructuredText
----------------

`reStructuredText <http://docutils.sourceforge.net/rst.html>`_

- `Quick reStructuredText <http://docutils.sourceforge.net/docs/user/rst/quickref.html>`_
- `reStructuredText Markup Specification <http://docutils.sourceforge.net/docs/ref/rst/restructuredtext.html>`_
- `Online reStructuredText editor <http://rst.ninjs.org/>`_

C/C++ 包管理工具
----------------

参见 `The State of Package Management in C++ - Mathieu Ropert [ACCU 2019] <https://youtube.com/watch?v=k99_qbB2FvM>`_。

cget
^^^^

`cget <https://cget.readthedocs.io/>`_

Conan
^^^^^

`Conan <https://conan.io/>`_ 采用非侵入式设计，需要安装；

.. code-block::

  :: 查看代理
  %USERPROFILE%> conan config get [proxies.http]

  :: 设置代理
  %USERPROFILE%> conan config set proxies.http=http://[username:password@]proxy.example.org:49152/

  :: 移除代理
  %USERPROFILE%> conan config rm proxies.http

Conan 通过指定 ``conanfile.txt`` 的 ``[generators]`` 为 ``cmake_paths``，
并设定 CMake 的 ``CMAKE_TOOLCHAIN_FILE`` 变量为 ``/path/to/conan_paths.cmake`` 实现非侵入式设计；

Conan 通过设定 `CONAN_USER_HOME <https://docs.conan.io/en/latest/reference/env_vars.html#conan-user-home>`_ 环境变量指定库存储位置；

Conan 提供 `CMake-Conan <https://github.com/conan-io/cmake-conan>`_ 脚本，侵入式地包装 Conan 命令为 CMake 命令；

Conan 提供 `ConanCenter <https://conan.io/center/>`_ 资源库。

Hunter
^^^^^^

`Hunter <https://hunter.sh/>`_ 使用纯 CMake 实现，采用侵入式设计，无需安装；

Hunter 通过设定 `HUNTER_ROOT <https://github.com/hunter-packages/gate#effects>`_ 环境变量指定库存储位置；

Hunter 支持的库列表可以在 `All packages <https://hunter.readthedocs.io/en/latest/packages/all.html>`_ 找到。

vcpkg
^^^^^

`vcpkg <https://vcpkg.readthedocs.io/>`_ 采用非侵入式设计，需要安装；

vcpkg 通过设定 CMake 的 ``CMAKE_TOOLCHAIN_FILE`` 变量为 ``/path/to/vcpkg/scripts/buildsystems/vcpkg.cmake`` 实现非侵入式设计；

vcpkg 通过设定 `VCPKG_DOWNLOADS <https://vcpkg.readthedocs.io/en/latest/users/config-environment/>`_ 环境变量指定库下载位置。

许可
----

项目采用 Unlicense 许可，文档采用 CC0-1.0 许可：

.. image:: https://licensebuttons.net/p/zero/1.0/88x31.png
   :target: https://creativecommons.org/publicdomain/zero/1.0/

To the extent possible under law, zhengrr has waived all copyright and related or neighboring rights to this work.
