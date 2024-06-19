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

sdk_relative = '../steamworkslib'
sdk_path = join_paths(meson.current_source_dir(), sdk_relative)
steamworks_dep = declare_dependency(
  link_args : [
    '-L' + join_paths(sdk_path, 'redistributable_bin/linux64'),
    '-L' + join_paths(sdk_path, 'public/steam/lib/linux64'),
    '-l' + 'steam_api',
    '-l' + 'sdkencryptedappticket',
  ],
  include_directories : include_directories(join_paths(sdk_relative, 'public')))

fs.copyfile(join_paths(sdk_path, 'redistributable_bin/linux64/libsteam_api.so'), 'libsteam_api.so')
fs.copyfile(join_paths(sdk_path, 'public/steam/lib/linux64/libsdkencryptedappticket.so'), 'libsdkencryptedappticket.so')

# assets

fs.copyfile(join_paths(src_path, 'DejaVuSans.ttf'), 'DejaVuSans.ttf')
fs.copyfile(join_paths(src_path, 'steam_appid.txt'), 'steam_appid.txt')

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
    #'-std=c++0x',
    '-Wno-invalid-offsetof',
    '-DPOSIX',
    '-DSDL',
    # For Zig compatibiliy: https://github.com/ziglang/zig/issues/5163
    # TODO: Research more on this
    '-fno-sanitize=all', 
  ],
  build_rpath: '$ORIGIN',
)
