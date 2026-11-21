# Bitácora

## 2026-11-21 — v1 (sin mods)

- ROM: USA Rev 1, NCCH `CTR-P-AJRE`, flags `0000000001030004` (NoCrypto), partición 0 de 654 643 200 bytes
  (la misma que DekUI da por buena).
- Compilación con el kit 0.6.1 + parche de fix8: el recompilador saca 104 archivos (329 MiB de C), 0 overrides;
  el juego para la consola en 118 s. El kit no tiene perfil para `0004000000125500`.
- `pocket-native` sale idéntico al de fix8 (SHA-256 `20d810af…edc50`).
- PC (x86, Mesa llvmpipe), probe 14 400 cuadros, reloj `1700000000000`: 166 s, 145 % de la velocidad,
  0,00 % interpretado, 1 369 dibujos omitidos mientras se hacían sombreados, 18 a la CPU, sin SVC faltantes.
  Llega a Link controlable en Termina (captura 7 y 8).
- Consola (R36S, dArkOSRE, 4.4.189), probe 14 400 cuadros, mismo reloj, layout BigTop:
  - en frío (`mm3d-v1-a`): 84 %, 220 290 dibujos omitidos mientras se hacían sombreados, árboles que faltan
    en una captura y la pantalla de abajo con un pedazo de la de arriba en otra. 76 °C.
  - con caché (`mm3d-v1-b`): 93 %, 0 omitidos, capturas idénticas al PC. Termina 114–135 %,
    escenas del bosque 70–88 % (GPU 70 % a ~470 MHz, `waiting on gpu` 33–37 %). 351 MiB, 307 libres.
  - Español correcto (Después de librar mil batallas…, Máscaras / Mapa / Inventario).

## 2026-11-21 — v2 (una pantalla, HUD del motor)

- Los mods de una pantalla (DekUI, Majora ReMasked) son forks de Azahar, no parches: en vez de
  portarlos, el motor gana un HUD genérico por composición (`hud.txt`):
  - GPU: con TopOnly, la pantalla de abajo se pasa con área `[0;4]` y se dibuja una vez por recorte,
    entera, escalada y colocada para que el recorte caiga en su sitio, con scissor al destino.
  - Núcleo: con HUD, la pantalla de abajo sigue dibujándose aunque `ZAKURO_HIDE_BOTTOM=1`.
  - Controles: `tap` (tecla = toque fijo), `swap` (tecla = ver la de abajo sola); en esa vista el stick
    derecho es el cursor y R2 toca, aunque el ajuste sea C-stick. Las teclas del HUD no llegan al juego.
- Medidas de la pantalla de abajo (320×240): I `264,0,56,56`, X `266,68,52,52`, Y `258,118,52,52`,
  II `264,184,56,56`, Ver `0,0,56,56`, rupias `0,64,60,32`, corazones+magia `80,0,172,40`.
- PC: el panel compuesto (`ZAKURO_PANEL_SHOT`) se ve bien a la primera; ajustes: el reloj de Pocket
  Native tapaba "Ver" (movido junto a I) y el recorte de corazones tomaba el borde del panel.
- Consola (`mm3d-v2-a`): 91 % de media (igual que v1), Termina 111–129 %, bosque 66–87 %,
  0 omitidos, sin avisos nuevos, ~270 MiB. Instalada: motor nuevo (respaldo `pocket-native.fix8`),
  `hud.txt`, TopOnly (respaldo de los ajustes en `settings.toml.bak`).
- Falta: que el usuario juegue (L2/R2 → I/II, Select, arrastrar máscaras, cámara con el stick derecho).
