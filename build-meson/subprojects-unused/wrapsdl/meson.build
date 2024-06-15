project('wrapsdl', 'cpp')
cmake = import('cmake')

# Import the CMake subproject
cmake_proj = cmake.subproject('sdl2')
cmake_dep = cmake_proj.dependency('SDL2')

# Create a Meson library wrapping the CMake project
cmake_lib = library(
  'wrapsdl',
  sources: [],
  dependencies: [cmake_dep],
  #static: true
)


liba_dep = declare_dependency(
  #include_directories: public_include,
  link_with: cmake_lib,
  #dependencies: public_deps,
)
meson.override_dependency('wrapsdl', liba_dep)
