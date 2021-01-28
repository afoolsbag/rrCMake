# zhengrr
# 2016-10-08 – 2021-01-28
# Unlicense

cmake_minimum_required(VERSION 3.10)
cmake_policy(VERSION 3.10)

include_guard()  # 3.10

#[=======================================================================[.rst:
.. command:: rr_add_compile_options

  基于 ``add_compile_options`` 命令，提供更多选项和功能。

  .. code-block:: cmake

    rr_add_compile_options(
      <argument-of-"add_compile_options"-command>...
      [ANALYZE]
      [DISABLE_LANGUAGE_EXTENSIONS]
      [HIGHEST_WARNING_LEVEL | RECOMMENDED_WARNING_LEVEL]
      [MULTIPLE_PROCESSES]
      [SECURITY_DEVELOPMENT_LIFECYCLE]
      [UTF-8]
      [VISIBLE_DEFAULT_HIDDEN]
      [WARNING_AS_ERROR])

  参见：

  - `add_compile_options <https://cmake.org/cmake/help/latest/command/add_compile_options.html>`_

#]=======================================================================]
function(rr_add_compile_options)
  set(zOptKws    ANALYZE
                 DISABLE_LANGUAGE_EXTENSIONS
                 HIGHEST_WARNING_LEVEL
                 MULTIPLE_PROCESSES
                 RECOMMENDED_WARNING_LEVEL
                 SECURITY_DEVELOPMENT_LIFECYCLE
                 UTF-8
                 VISIBLE_DEFAULT_HIDDEN
                 WARNING_AS_ERROR)
  set(zOneValKws)
  set(zMutValKws)
  cmake_parse_arguments(PARSE_ARGV 0 "" "${zOptKws}" "${zOneValKws}" "${zMutValKws}")

  #
  # 业务逻辑
  #

  # add_compile_options
  add_compile_options(${_UNPARSED_ARGUMENTS})

  # GCC
  set(GCC "FALSE")
  get_cmake_property(zLangs ENABLED_LANGUAGES)
  foreach(sLang IN LISTS zLangs)
    if(CMAKE_${sLang}_COMPILER_ID STREQUAL "GNU")
      set(GCC "TRUE")
      break()
    endif()
  endforeach()

  # 代码分析
  # MSVC: https://docs.microsoft.com/cpp/build/reference/analyze-code-analysis
  if(_ANALYZE)
    if(MSVC_VERSION GREATER_EQUAL 1910 AND CMAKE_CXX_COMPILER)
      add_compile_options("/analyze" "/analyze:WX-" "/analyze:ruleset AllRules.ruleset")
    endif()
  endif()

  # 禁用语言扩展
  # GCC:  https://gcc.gnu.org/onlinedocs/gcc/Warning-Options.html
  # MSVC: https://docs.microsoft.com/cpp/build/reference/za-ze-disable-language-extensions
  if(_DISABLE_LANGUAGE_EXTENSIONS)
    if(GCC)
      add_compile_options("-Wpedantic")
    endif()
    if(MSVC)
      add_compile_options("/Za")
    endif()
  endif()

  # 警告级别
  # GCC:  https://gcc.gnu.org/onlinedocs/gcc/Warning-Options.html
  # MSVC: https://docs.microsoft.com/cpp/build/reference/compiler-option-warning-level
  if(_HIGHEST_WARNING_LEVEL)
    if(GCC)
      add_compile_options("-Wall" "-Wextra")
    endif()
    if(MSVC)
      add_compile_options("/Wall")
    endif()
  elseif(_RECOMMENDED_WARNING_LEVEL)
    if(GCC)
      add_compile_options("-Wall")
    endif()
    if(MSVC)
      add_compile_options("/W4")
    endif()
  endif()

  # 使用多个进程生成
  # MSVC: https://docs.microsoft.com/cpp/build/reference/mp-build-with-multiple-processes
  if(_MULTIPLE_PROCESSES)
    if(MSVC)
      add_compile_options("/MP")
    endif()
  endif()

  # 启用附加安全检查
  # MSVC: https://docs.microsoft.com/cpp/build/reference/sdl-enable-additional-security-checks
  if(_SECURITY_DEVELOPMENT_LIFECYCLE)
    if(MSVC)
      add_compile_options("/sdl")
    endif()
  endif()

  # 将源和可执行字符集设置为 UTF-8
  # MSVC: https://docs.microsoft.com/cpp/build/reference/utf-8-set-source-and-executable-character-sets-to-utf-8
  if(_UTF-8)
    if(MSVC)
      add_compile_options("/utf-8")
    endif()
  endif()

  # 将符号的默认导出策略设置为“隐藏”
  # GCC: https://gcc.gnu.org/onlinedocs/gcc/Code-Gen-Options.html
  if(_VISIBLE_DEFAULT_HIDDEN)
    if(GCC)
      add_compile_options("-fvisibility=hidden")
    endif()
  endif()

  # 将警告视为错误
  # GCC:  https://gcc.gnu.org/onlinedocs/gcc/Warning-Options.html
  # MSVC: https://docs.microsoft.com/cpp/build/reference/compiler-option-warning-level
  if(_WARNING_AS_ERROR)
    if(GCC)
      add_compile_options("-Werror")
    endif()
    if(MSVC)
      add_compile_options("/WX")
    endif()
  endif()
endfunction()
