project('example', 'cpp')
fs = import('fs')

raw_source_files = [
  'BaseMenu.cpp',
  'Friends.cpp',
  'Inventory.cpp',
  'ItemStore.cpp',
  'Leaderboards.cpp',
  'Lobby.cpp',
  'Main.cpp',
  'MainMenu.cpp',
  'OverlayExamples.cpp',
  'PhotonBeam.cpp',
  'QuitMenu.cpp',
  'RemotePlay.cpp',
  'RemoteStorage.cpp',
  'ServerBrowser.cpp',
  'Ship.cpp',
  'SimpleProtobuf.cpp',
  'SpaceWarClient.cpp',
  'SpaceWarEntity.cpp',
  'SpaceWarServer.cpp',
  'StarField.cpp',
  'StatsAndAchievements.cpp',
  'Sun.cpp',
  'VectorEntity.cpp',
  'clanchatroom.cpp',
  'connectingmenu.cpp',
  'gameenginesdl.cpp',
  'htmlsurface.cpp',
  'musicplayer.cpp',
  'p2pauth.cpp',
  'remotestoragesync.cpp',
  'stdafx.cpp',
  'voicechat.cpp',
]
src_path = '../src'
source_files = []
foreach file : raw_source_files
    source_files += files(join_paths(src_path, file))
endforeach

# deps

sdl2_dep = dependency('sdl2')
sdl2_ttf_dep = dependency('SDL2_ttf')
glew_dep = dependency('glew')
openal_dep = dependency('openal')

# steamworks sdk library

if host_machine.system() == 'windows'
  sdk_os = 'win64'
  sdk_lib_steam = 'steam_api64'
  sdk_lib_ticket = 'sdkencryptedappticket64'
  sdk_lib_steam_obj = 'steam_api64.dll'
  sdk_lib_ticket_obj = 'sdkencryptedappticket64.dll'
else
  sdk_os = 'linux64'
  sdk_lib_steam = 'steam_api'
  sdk_lib_ticket = 'sdkencryptedappticket'
  sdk_lib_steam_obj = 'libsteam_api.so'
  sdk_lib_ticket_obj = 'libsdkencryptedappticket.so'
endif
sdk_relative_path = '../steamworkslib'
sdk_path = join_paths(meson.current_source_dir(), sdk_relative_path)

steamworks_dep = declare_dependency(
  link_args : [
    '-L' + join_paths(sdk_path, 'redistributable_bin', sdk_os),
    '-L' + join_paths(sdk_path, 'public/steam/lib', sdk_os),
    '-l' + sdk_lib_steam,
    '-l' + sdk_lib_ticket,
  ],
  include_directories : include_directories(join_paths(sdk_relative_path, 'public')))

install_data(join_paths(sdk_path, 'redistributable_bin', sdk_os, sdk_lib_steam_obj), install_dir: get_option('bindir'))
install_data(join_paths(sdk_path, 'public/steam/lib', sdk_os, sdk_lib_ticket_obj), install_dir: get_option('bindir'))

# assets

install_data(join_paths(src_path, 'DejaVuSans.ttf'), install_dir: get_option('bindir'))
install_data(join_paths(src_path, 'steam_appid.txt'), install_dir: get_option('bindir'))

# compiler specific flags

compiler = meson.get_compiler('cpp').get_id()
if compiler == 'msvc'
  extra_args = ['-DWIN32', '/wd4828']
else # gcc, clang
  extra_args = ['-DPOSIX', '-g', '-Wno-invalid-offsetof']
endif

executable(
  'example', source_files,
  dependencies : [
    sdl2_dep,
    sdl2_ttf_dep,
    glew_dep,
    openal_dep,
    steamworks_dep,
  ],
  cpp_args : [
    '-DSDL',
    extra_args
  ],
  build_rpath: '$ORIGIN',
  install_rpath: '$ORIGIN',
  install: true,
)
