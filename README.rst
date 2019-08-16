CMake
=====

`CMake <https://cmake.org>`_

参考
----

`CMake Reference Documentation <https://cmake.org/cmake/help/latest/>`_

- `cmake-commands(7) <https://cmake.org/cmake/help/latest/manual/cmake-commands.7.html>`_

- `cmake-developer(7) <https://cmake.org/cmake/help/latest/manual/cmake-developer.7.html>`_

- `cmake-language(7) <https://cmake.org/cmake/help/latest/manual/cmake-language.7.html>`_

- `cmake-modules(7) <https://cmake.org/cmake/help/latest/manual/cmake-modules.7.html>`_

- `cmake-packages(7) <https://cmake.org/cmake/help/latest/manual/cmake-packages.7.html>`_

- `cmake-variables(7) <https://cmake.org/cmake/help/latest/manual/cmake-variables.7.html>`_

`CMake Community Wiki <https://gitlab.kitware.com/cmake/community/wikis/>`_

- `Useful variables <https://gitlab.kitware.com/cmake/community/wikis/doc/cmake/Useful-Variables>`_

风格
----

**变量**

变量名采用小驼峰、匈牙利风格（``tLowerCamelCase``）；
除非特别说明，取变量值一般建议括上引号（``"${tLowerCamelCase}"``），空值会被解析为空字符串（``""``）占位而不是忽略；
前缀一般含义如下：

- 前缀 ``b`` 暗示变量值用作真假值（``bBoolean``）
- 前缀 ``e`` 暗示变量值用作表达式（``eExpression``）
- 前缀 ``n`` 暗示变量值用作数字（``nNumber``）
- 前缀 ``o`` 暗示变量值用作选项（``oOption``），若为空则应被忽略，在解引用时不应括上引号（``${oOption}``）
- 前缀 ``r`` 暗示变量值用作正则表达式（``rRegularExpression``）
- 前缀 ``s`` 暗示变量值用作字符串（``sString``）
- 前缀 ``p`` 暗示变量值用作路径（``pPath``）
- 前缀 ``t`` 暗示变量值用作目标（``tTarget``）
- 前缀 ``v`` 暗示变量值用作变量名（``vVariable``）
- 前缀 ``z`` 暗示变量值用作字符串列表（``zStringList``），在解引用时一般不括上引号（``${zStringList}``）

任何变量值都是字符串，前缀用于暗示该字符串接受的处理方式，并无强制性。

Conan
-----

`Conan <https://conan.io/>`_

- `conan-center <https://bintray.com/conan/conan-center>`_
- `CONAN_USER_HOME <https://docs.conan.io/en/latest/reference/env_vars.html#conan-user-home>`_

`CMake-Conan <https://github.com/conan-io/cmake-conan>`_

Hunter
------

`Hunter <https://docs.hunter.sh/>`_

- `All packages <https://docs.hunter.sh/en/latest/packages/all.html>`_
- `HUNTER_ROOT <https://github.com/hunter-packages/gate#effects>`_

reStructuredText
----------------

`reStructuredText <http://docutils.sourceforge.net/rst.html>`_

- `Quick reStructuredText <http://docutils.sourceforge.net/docs/user/rst/quickref.html>`_
- `reStructuredText Markup Specification <http://docutils.sourceforge.net/docs/ref/rst/restructuredtext.html>`_
- `Online reStructuredText editor <http://rst.ninjs.org/>`_

许可
----

项目采用 Unlicense 许可，文档采用 CC0-1.0 许可：

.. image:: https://licensebuttons.net/p/zero/1.0/88x31.png
   :target: https://creativecommons.org/publicdomain/zero/1.0/

To the extent possible under law, zhengrr has waived all copyright and related or neighboring rights to this work.
