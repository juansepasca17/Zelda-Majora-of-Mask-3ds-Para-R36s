#!/bin/bash
# mm3d-v1: primera prueba de Majora's Mask 3D en la consola, sin jugar.
# Lo corre el agente "PN Dev.sh" (el de OoT3D, sin cambios): aquí se redefine GAME.
# Usa --probe (pulsa A/Start solo) con reloj fijo, sobre una copia de data/ sin la partida.
# Sube: log del probe, informe, capturas, temperatura y memoria.
TITLE=0004000000125500
GAME="$PNDIR/games/$TITLE"
export TITLE GAME
FRAMES=${FRAMES:-14400}

echo "== equipo"; uname -a; free -m; df -h "$PNDIR" | tail -1
cat /sys/class/thermal/thermal_zone0/temp 2>/dev/null
for f in title.so game.3ds; do
  [ -f "$GAME/$f" ] || { echo "FALTA $GAME/$f: copia para-sd a /roms/ports"; exit 1; }
done
ls -l "$GAME" "$GAME/data"

probe() {  # probe NOMBRE [VAR=valor...]
  local name=$1; shift
  local d="$DEVDIR/bench-mm3d/$name"
  rm -rf "$d"; mkdir -p "$d/data"
  ( cd "$GAME/data" && for f in *; do case $f in user|log.txt) ;; *) cp -r "$f" "$d/data/" ;; esac; done ) 2>/dev/null
  pn_env
  echo "==== probe $name ($*)"
  local t0=$(date +%s)
  ( cd "$d" && env ZAKURO_DATA="$d/data" ZAKURO_CLOCK=1700000000000 "$@" \
      timeout 1800 "$PNDIR/pocket-native" --probe "$GAME/game.3ds" "$FRAMES" > "$d/log.txt" 2>&1 )
  echo "exit $name: $? en $(( $(date +%s) - t0 )) s"
  cat /sys/class/thermal/thermal_zone0/temp 2>/dev/null
  cp "$d/log.txt" "$JOBDIR/out/log_$name.txt"
  cp "$d/probe-$TITLE/report.md" "$JOBDIR/out/report_$name.md" 2>/dev/null
  for b in "$d"/probe-$TITLE/frame-*.bmp; do [ -f "$b" ] && gzip -c "$b" > "$JOBDIR/out/${name}_$(basename "$b").gz"; done
  # la caché de sombreados que se haya hecho sirve para las próximas partidas
  for f in "$d"/data/*; do case $(basename "$f") in log.txt|user|settings.toml) ;; *) cp -ru "$f" "$GAME/data/" ;; esac; done 2>/dev/null
}

probe base
"$PNDIR/power.sh" normal
sync
