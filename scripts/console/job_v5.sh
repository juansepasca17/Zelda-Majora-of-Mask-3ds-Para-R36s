#!/bin/bash
# mm3d-v5: precompilación de sombreados en la primera carga (lista del kit, titles/<id>/shaders.txt).
# Trae el motor nuevo y la carpeta vertex/ con precache.txt; probe; si no falla, lo instala.
TITLE=0004000000125500
GAME="$PNDIR/games/$TITLE"
export TITLE GAME
fetch pn-mm3d-v5.gz "$PNDIR/pocket-native.v5" 650eb48d7470adc5a5658f4cec10892f79130d11b56982649ea2cffb33426f6b || exit 1
fetch mm3d-vertex-v5.tgz "$DEVDIR/mm3d-vertex-v5.tgz" f44d73b8a1a5f6e924aec509f3cf4be1bce64194f81a311e2d85c1560b39b74b || exit 1
chmod +x "$PNDIR/pocket-native.v5"
rm -rf "$DEVDIR/vertex-v5"; mkdir -p "$DEVDIR/vertex-v5"; tar -xzf "$DEVDIR/mm3d-vertex-v5.tgz" -C "$DEVDIR/vertex-v5"; ls "$DEVDIR/vertex-v5"
d="$DEVDIR/bench-mm3d/v5"; rm -rf "$d"; mkdir -p "$d/data"
( cd "$GAME/data" && for f in *; do case $f in user|log.txt) ;; *) cp -r "$f" "$d/data/" ;; esac; done )
pn_env
echo "==== probe v5"
( cd "$d" && ZAKURO_DATA="$d/data" ZAKURO_SHADER_MANIFEST="$d/data/shaders.txt" ZAKURO_VERTEX_LIST="$DEVDIR/vertex-v5/vertex.txt"     ZAKURO_CLOCK=1700000000000 ZAKURO_HIDE_BOTTOM=1 timeout 2400 "$PNDIR/pocket-native.v5" --probe "$GAME/game.3ds" 14400 > "$d/log.txt" 2>&1 )
echo "exit v5: $?  temp $(cat /sys/class/thermal/thermal_zone0/temp)"
cp "$d/log.txt" "$JOBDIR/out/log_v5.txt"; cp "$d/probe-$TITLE/report.md" "$JOBDIR/out/report_v5.md" 2>/dev/null
"$PNDIR/power.sh" normal
if grep -q "Still running" "$JOBDIR/out/report_v5.md" 2>/dev/null; then
  cp -p "$PNDIR/pocket-native" "$PNDIR/pocket-native.v4"
  mv -f "$PNDIR/pocket-native.v5" "$PNDIR/pocket-native"
  [ -d "$GAME/vertex.v4" ] || cp -r "$GAME/vertex" "$GAME/vertex.v4"
  cp -f "$DEVDIR/vertex-v5/"* "$GAME/vertex/"
  echo "v5 instalada (respaldos pocket-native.v4 y vertex.v4)"
else
  echo "v5 NO instalada: el probe fallo"
fi
rm -rf "$d"; sync
