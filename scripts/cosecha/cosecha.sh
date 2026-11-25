#!/bin/bash
for n in 0 1 2 3; do
  T=1500 bash /work/warp_probe.sh tanda$n 6000 500 "$(cat /work/tanda$n.txt)" 20500
done
