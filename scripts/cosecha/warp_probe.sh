#!/bin/bash
# warp_probe.sh NOMBRE DESDE CADA LISTA [CUADROS]: probe del PC con la partida del usuario que
# recorre entradas de escena (ZAKURO_WARP) y deja crecer el manifiesto de sombreados.
name=$1 from=$2 every=$3 list=$4 frames=${5:-40000}
run=/work/runs/$name; rm -rf $run; mkdir -p $run/data $run/config $run/cache
cp -r /pn/sysdata $run/; cp /work/hud.txt $run/data/; cp -r /work/save/user $run/data/
printf 'language = 5\nregion = 1\nlayout = "TopOnly"\nswapped = false\n\n[options]\n' > $run/data/settings.toml
cd $run
env EGL_PLATFORM=surfaceless ZAKURO_FAST=1 ZAKURO_DATA=$run/data ZAKURO_RECOMPILED=/pn/title.so XDG_CACHE_HOME=$run/cache \
  ZAKURO_SHADER_MANIFEST=$run/data/shaders.txt POCKET_NATIVE_TITLES=/pn/titles POCKET_NATIVE_CONFIG=$run/config \
  ZAKURO_HIDE_BOTTOM=1 ZAKURO_WARP="$from:$every:$list" ZAKURO_SHOT_AT=${SHOTS:-} ZAKURO_WARP_TIME=${TIME:-} \
  timeout ${T:-3000} /pn/${BIN:-pocket-native} --probe /rom/mm3d-usa-rev1.cci $frames > $run/log.txt 2>&1
echo "exit $?" >> $run/log.txt
