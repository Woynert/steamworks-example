# 1. ============================================

sdl2_proj = cmake.subproject('SDL2-2.30.3')
message('CMake targets:\n - ' + '\n - '.join(sdl2_proj.target_list()))
sdl2_dep = sdl2_proj.dependency('SDL2')
sdl2_library_obj = sdl2_proj.target('SDL2').path()

# SDL2_ttf

opt_var = cmake.subproject_options()
opt_var.append_compile_args('c', '-I' + meson.project_source_root() / 'subprojects' / 'SDL2-2.30.3' / 'include')
opt_var.add_cmake_defines({'SDL2_LIBRARY': sdl2_library_obj})

sdl2_ttf_proj = cmake.subproject('sdl2_ttf', options: opt_var)
message('CMake targets:\n - ' + '\n - '.join(sdl2_ttf_proj.target_list()))
sdl2_ttf_dep = sdl2_ttf_proj.dependency('SDL2_ttf')

cmake_lib = library(
  'custom',
  sources: [],
  dependencies: [sdl2_dep, sdl2_ttf_dep],
  #static: true
)

# 2. ============================================

# SDL2

sdl2_proj = cmake.subproject('SDL2-2.30.3')
message('CMake targets:\n - ' + '\n - '.join(sdl2_proj.target_list()))
sdl2_dep = sdl2_proj.dependency('SDL2')
sdl2_library_obj = sdl2_proj.target('SDL2').path()

# SDL2_ttf

opt_var = cmake.subproject_options()
opt_var.append_compile_args('c', '-I' + meson.project_source_root() / 'subprojects' / 'SDL2-2.30.3' / 'include')
opt_var.add_cmake_defines({'SDL2_LIBRARY': sdl2_library_obj})

sdl2_ttf_proj = cmake.subproject('sdl2_ttf', options: opt_var)
message('CMake targets:\n - ' + '\n - '.join(sdl2_ttf_proj.target_list()))
sdl2_ttf_dep = sdl2_ttf_proj.dependency('SDL2_ttf')

# other

openal_proj = cmake.subproject('openal-soft')
openal_dep = openal_proj.dependency('OpenAL')

# === === pkg-config === ===

freetype_dep = dependency('freetype2')
glfw_dep = dependency('glfw')
