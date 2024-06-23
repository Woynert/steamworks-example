#!/usr/bin/env sh
for file in "./deps/libs"/*; do
    if [ ! -L "$file" ] && [ -f "$file" ]; then
      echo "Patching: $file"
      patchelf --set-rpath "\$ORIGIN" "$file"
    fi
done
