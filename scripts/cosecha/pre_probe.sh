#!/bin/bash
run=/work/runs/pre; rm -rf $run; mkdir -p $run/data $run/config $run/cache
cp -r /pn/sysdata $run/; cp /work/hud.txt $run/data/
printf 'language = 5\nregion = 1\nlayout = "TopOnly"\nswapped = false\n\n[options]\n' > $run/data/settings.toml
cd $run
env EGL_PLATFORM=surfaceless ZAKURO_FAST=1 ZAKURO_DATA=$run/data ZAKURO_RECOMPILED=/pn/title.so XDG_CACHE_HOME=$run/cache \
  ZAKURO_SHADER_MANIFEST=$run/data/shaders.txt ZAKURO_VERTEX_LIST=/pn/vertex/vertex.txt POCKET_NATIVE_TITLES=/pn/titles \
  POCKET_NATIVE_CONFIG=$run/config ZAKURO_PANEL_SHOT=$run/panel.ppm ZAKURO_HIDE_BOTTOM=1 \
  timeout 1500 /pn/pocket-native-night --probe /rom/mm3d-usa-rev1.cci 14400 > $run/log.txt 2>&1
echo "exit $?" >> $run/log.txt
