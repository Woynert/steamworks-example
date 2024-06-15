project('wrapsdlttf', 'cpp')
cmake = import('cmake')

cmake_lib_a = subproject('wrapsdl').get_variable('cmake_lib')
#go_mod = custom_target(
  #output: 'hello.asd',
  #depends: sdl_dep,
  #command: [some_command_that_makes_the_output, a_lib.full_path(), '@OUTPUT@'],
#)

sdl2_ttf_proj = cmake.subproject('sdl2_ttf')
#message('\n=\n=\n=\n=\n=\nCMake targets:\n - ' + '\n - '.join(sdl2_ttf_proj.target_list()))
sdl2_ttf_dep = sdl2_ttf_proj.dependency('SDL2_ttf')

#cmake_lib = library(
  #'wrapsdlttf',
  #sources: [go_mod],
  #dependencies: [sdl_dep, sdl2_ttf_dep],
#)


libb_dep = declare_dependency(
  #include_directories: public_include,
  link_with: cmake_lib_a,
  dependencies: sdl2_ttf_dep,
)
meson.override_dependency('wrapsdlttf', libb_dep)
