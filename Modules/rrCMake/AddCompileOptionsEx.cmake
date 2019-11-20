# zhengrr
# 2016-10-08 – 2019-11-20
# Unlicense

cmake_minimum_required(VERSION 3.10)
cmake_policy(VERSION 3.10)

include_guard()  # 3.10

#.rst:
# .. command:: add_compile_options_ex
#
#   添加编译配置（add compile options），扩展功能（extend）。
#
#   .. code-block:: cmake
#
#     add_compile_options_ex(
#       <argument-of-add_compile_options>...
#       [ANALYZE]
#       [DISABLE_LANGUAGE_EXTENSIONS]
#       [HIGHEST_WARNING_LEVEL|RECOMMENDED_WARNING_LEVEL]
#       [MULTIPLE_PROCESSES]
#       [UTF-8]
#       [VISIBLE_DEFAULT_HIDDEN]
#       [WARNING_AS_ERROR]
#     )
#
#   参见：
#
#   - `add_compile_options <https://cmake.org/cmake/help/latest/command/add_compile_options.html>`_
#   - `MSVC: Code Analysis <https://docs.microsoft.com/cpp/build/reference/analyze-code-analysis>`_
#   - `MSVC: Disable Language Extensions <https://docs.microsoft.com/cpp/build/reference/za-ze-disable-language-extensions>`_
#   - `GCC: Warning Options <https://gcc.gnu.org/onlinedocs/gcc/Warning-Options.html>`_
#   - `MSVC: Warning Level <https://docs.microsoft.com/cpp/build/reference/compiler-option-warning-level>`_
#   - `MSVC: Build with Multiple Processes <https://docs.microsoft.com/cpp/build/reference/mp-build-with-multiple-processes>`_
#   - `MSVC: Set Source and Executable character sets to UTF-8 <https://docs.microsoft.com/cpp/build/reference/utf-8-set-source-and-executable-character-sets-to-utf-8>`_
#
function(add_compile_options_ex)
  set(zOptKws    ANALYZE
                 DISABLE_LANGUAGE_EXTENSIONS
                 HIGHEST_WARNING_LEVEL
                 MULTIPLE_PROCESSES
                 RECOMMENDED_WARNING_LEVEL
                 UTF-8
                 VISIBLE_DEFAULT_HIDDEN
                 WARNING_AS_ERROR)
  set(zOneValKws)
  set(zMutValKws)
  cmake_parse_arguments(PARSE_ARGV 0 "" "${zOptKws}" "${zOneValKws}" "${zMutValKws}")

  #
  # 参数规整
  #

  set(zArgumentsOfAddCompileOptions ${_UNPARSED_ARGUMENTS})
  set(bAnalyze                      "${_ANALYZE}")
  set(bDisableLanguageExtensions    "${_DISABLE_LANGUAGE_EXTENSIONS}")
  set(bHighestWarningLevel          "${_HIGHEST_WARNING_LEVEL}")
  set(bMultipleProcesses            "${_MULTIPLE_PROCESSES}")
  set(bRecommendedWarningLevel      "${_RECOMMENDED_WARNING_LEVEL}")
  set(bUtf8                         "${_UTF-8}")
  set(bVisibleDefaultHidden         "${_VISIBLE_DEFAULT_HIDDEN}")
  set(bWarningAsError               "${_WARNING_AS_ERROR}")

  #
  # 基础功能
  #

  add_compile_options(${zArgumentsOfAddCompileOptions})

  #
  # 扩展功能
  #

  get_cmake_property(zLangs ENABLED_LANGUAGES)

  if(bAnalyze)
    if(1910 LESS_EQUAL MSVC_VERSION AND CMAKE_CXX_COMPILER)
      add_compile_options("/analyze" "/analyze:WX-" "/analyze:ruleset AllRules.ruleset")
    endif()
  endif()

  if(bDisableLanguageExtensions)
    foreach(sLang IN LISTS zLangs)
      if(CMAKE_${sLang}_COMPILER_ID STREQUAL "GNU")
        add_compile_options("-Wpedantic")
        break()
      endif()
    endforeach()
    if(MSVC)
      add_compile_options("/Za")
    endif()
  endif()

  if(bHighestWarningLevel)
    foreach(sLang IN LISTS zLangs)
      if(CMAKE_${sLang}_COMPILER_ID STREQUAL "GNU")
        add_compile_options("-Wall" "-Wextra")
        break()
      endif()
    endforeach()
    if(MSVC)
      add_compile_options("/Wall")
    endif()
  elseif(bRecommendedWarningLevel)
    foreach(sLang IN LISTS zLangs)
      if(CMAKE_${sLang}_COMPILER_ID STREQUAL "GNU")
        add_compile_options("-Wall")
        break()
      endif()
    endforeach()
    if(MSVC)
      add_compile_options("/W4")
    endif()
  endif()

  if(bMultipleProcesses)
    if(MSVC)
      add_compile_options("/MP")
    endif()
  endif()

  if(bUtf8)
    if(MSVC)
      add_compile_options("/utf-8")
    endif()
  endif()

  if(bVisibleDefaultHidden)
    foreach(sLang IN LISTS zLangs)
      if(CMAKE_${sLang}_COMPILER_ID STREQUAL "GNU")
        add_compile_options("-fvisibility=hidden")
        break()
      endif()
    endforeach()
  endif()

  if(bWarningAsError)
    foreach(sLang IN LISTS zLangs)
      if(CMAKE_${sLang}_COMPILER_ID STREQUAL "GNU")
        add_compile_options("-Werror")
        break()
      endif()
    endforeach()
    if(MSVC)
      add_compile_options("/WX")
    endif()
  endif()

endfunction()
