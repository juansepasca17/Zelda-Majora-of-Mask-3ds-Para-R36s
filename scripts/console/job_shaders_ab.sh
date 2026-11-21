#!/bin/bash
# mm3d-shaders: A/B/C en frío (sin caché de sombreados) del enlace de programas en Mali.
#   a-actual: como viene · b-separables: separable_shaders · c-generico: generic_shaders
# Copias de data/ sin partida ni caché; no toca la instalación.
TITLE=0004000000125500
GAME="$PNDIR/games/$TITLE"
export TITLE GAME
FRAMES=${FRAMES:-14400}

probe() {  # probe NOMBRE [línea de [advanced]]
  local name=$1 adv=${2:-}
  local d="$DEVDIR/bench-mm3d/$name"
  rm -rf "$d"; mkdir -p "$d/data"
  cp "$GAME/data/hud.txt" "$d/data/"
  printf 'language = 5\nregion = 1\nlayout = "TopOnly"\nswapped = false\n\n[options]\n' > "$d/data/settings.toml"
  [ -n "$adv" ] && printf '\n[advanced]\n%s\n' "$adv" >> "$d/data/settings.toml"
  pn_env
  echo "==== probe $name ($adv) $(free -m | awk '/Mem/{print $7" MiB libres"}')"
  ( cd "$d" && ZAKURO_DATA="$d/data" ZAKURO_SHADER_MANIFEST="$d/data/shaders.txt" ZAKURO_CLOCK=1700000000000 ZAKURO_HIDE_BOTTOM=1 \
      timeout 1500 "$PNDIR/pocket-native" --probe "$GAME/game.3ds" "$FRAMES" > "$d/log.txt" 2>&1 )
  echo "exit $name: $?  temp $(cat /sys/class/thermal/thermal_zone0/temp)"
  cp "$d/log.txt" "$JOBDIR/out/log_$name.txt"
  cp "$d/probe-$TITLE/report.md" "$JOBDIR/out/report_$name.md" 2>/dev/null
  for b in "$d"/probe-$TITLE/frame-*.bmp; do [ -f "$b" ] && gzip -c "$b" > "$JOBDIR/out/${name}_$(basename "$b").gz"; done
  rm -rf "$d"
  sleep 20   # que baje un poco la temperatura entre pasadas
}

probe a-actual
probe b-separables "separable_shaders = true"
probe c-generico "generic_shaders = true"
"$PNDIR/power.sh" normal
sync
