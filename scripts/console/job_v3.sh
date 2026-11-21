#!/bin/bash
# mm3d-v3: HUD + dos pantallas automáticas en menús + tope de programas (ZAKURO_PROGRAM_CAP). Probe sin jugar con el motor nuevo y, si
# no falla, lo instala: motor nuevo (respaldo pocket-native.fix8), hud.txt y layout TopOnly.
# El motor nuevo no cambia nada en juegos sin hud.txt (OoT3D sigue igual).
TITLE=0004000000125500
GAME="$PNDIR/games/$TITLE"
export TITLE GAME
FRAMES=${FRAMES:-14400}
SUM_PN=@SUM_PN@
SUM_HUD=@SUM_HUD@

fetch pn-mm3d-v3.gz "$PNDIR/pocket-native.v3" $SUM_PN || exit 1
fetch hud-mm3d.txt "$DEVDIR/hud-mm3d.txt" $SUM_HUD || exit 1
chmod +x "$PNDIR/pocket-native.v3"

probe() {  # probe NOMBRE BINARIO LAYOUT [hud]
  local name=$1 bin=$2 layout=$3 hud=${4:-}
  local d="$DEVDIR/bench-mm3d/$name"
  rm -rf "$d"; mkdir -p "$d/data"
  ( cd "$GAME/data" && for f in *; do case $f in user|log.txt|hud.txt|settings.toml) ;; *) cp -r "$f" "$d/data/" ;; esac; done ) 2>/dev/null
  printf 'language = 5\nregion = 1\nlayout = "%s"\nswapped = false\n\n[options]\n' "$layout" > "$d/data/settings.toml"
  [ -n "$hud" ] && cp "$DEVDIR/hud-mm3d.txt" "$d/data/hud.txt"
  pn_env
  echo "==== probe $name ($layout ${hud:+hud})"
  ( cd "$d" && ZAKURO_DATA="$d/data" ZAKURO_CLOCK=1700000000000 ZAKURO_HIDE_BOTTOM=1 \
      timeout 1800 "$bin" --probe "$GAME/game.3ds" "$FRAMES" > "$d/log.txt" 2>&1 )
  echo "exit $name: $?"
  cat /sys/class/thermal/thermal_zone0/temp 2>/dev/null
  cp "$d/log.txt" "$JOBDIR/out/log_$name.txt"
  cp "$d/probe-$TITLE/report.md" "$JOBDIR/out/report_$name.md" 2>/dev/null
}

probe hud "$PNDIR/pocket-native.v3" TopOnly hud
"$PNDIR/power.sh" normal

if grep -q "Still running" "$JOBDIR/out/report_hud.md" 2>/dev/null; then
  cp -p "$PNDIR/pocket-native" "$PNDIR/pocket-native.v2"; [ -f "$PNDIR/pocket-native.fix8" ] || cp -p "$PNDIR/pocket-native.v2" "$PNDIR/pocket-native.fix8"
  mv -f "$PNDIR/pocket-native.v3" "$PNDIR/pocket-native"
  cp "$DEVDIR/hud-mm3d.txt" "$GAME/data/hud.txt"
  backup "$GAME/data/settings.toml"
  sed -i 's/^layout = .*/layout = "TopOnly"/; s/^swapped = .*/swapped = false/' "$GAME/data/settings.toml"
  echo "v3 instalada: motor con HUD automático y tope de programas (respaldo pocket-native.fix8), hud.txt y TopOnly"
else
  echo "v3 NO instalada: el probe fallo"
fi
sync
