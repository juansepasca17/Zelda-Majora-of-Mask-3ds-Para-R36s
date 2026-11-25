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
- Controles pendientes de confirmar jugando: L2/R2 → I/II, Select, arrastrar máscaras, cámara con el stick derecho.

## 2026-11-21 — primera partida del usuario y v3

- Partida de ~28 min (`mm3d-play-01`). Lo bueno: corre bien en juego. Lo malo:
  - Título y selección de archivo "semirecortados": en Majora están en la **pantalla de abajo**, y el modo
    de una pantalla solo mostraba los recortes del HUD.
  - Fondos y personajes que faltan, parpadeos y negro en las escenas del título: casi todos los modelos usan un
    sombreado de vértices de 495 instrucciones (3 968 líneas de GLSL) y **cada combinación con un material
    nuevo tarda ~3,3 s en enlazarse en Mali**. 250 programas en la partida; mientras se enlazan, esos dibujos
    no salen. Los programas enlazados se guardan en `~/.cache/zakuro/gles/*.bin` (40 MB), así que la segunda
    vez es mucho mejor.
  - Pasados ~190 programas vivos, Mali rechaza enlaces con el log vacío (61 veces), la GPU queda al 17–19 %
    y el hilo GL esperando el 77 %: velocidad 17–47 % al final. No es memoria del sistema (250 MiB libres,
    swap zram sin usar).
- A/B/C en la consola (`mm3d-shaders-01`, el mismo recorrido): actual 96 %, `separable_shaders` 77 %
  (27 698 omitidos), `generic_shaders` 10 % (1 fps, cortado por tiempo). Se queda la actual.
- v3 (motor):
  - `check X Y R G B` en `hud.txt`: cada 15 presentaciones el hilo de la GPU lee la pantalla de abajo y la
    clasifica (HUD si coinciden ≥75 % de los puntos, negro, o "otra cosa"). "Otra cosa" durante 0,3 s pone
    las dos pantallas (BigTop) hasta que vuelve el HUD o el negro. Cursor oculto en esa vista salvo al moverlo.
  - `ZAKURO_PROGRAM_CAP` (150 por defecto): con más programas vivos, se borran los usados hace más tiempo
    hasta 3/4 del tope, nunca los del lote actual; vuelven desde la copia en disco. Estrés en el PC con tope 8:
    272 recortes, 0 errores, imagen correcta.
- Consola (`mm3d-v3-a`): 95 % de media, 0 omitidos; el log muestra negro → título (dos pantallas) → negro →
  menú → negro → HUD. Instalada (respaldos `pocket-native.v2` y `pocket-native.fix8`).
- Falta: una partida larga del usuario para confirmar que ya no hay rechazos de Mali.

## 2026-11-22 — segunda partida y v4

- Partida de 4,5 min con la v3 (`mm3d-play-02`). El usuario: las dos pantallas en la intro le gustan, pero
  hablar con un NPC también las ponía (la pantalla de abajo cambia en cada conversación); texturas que
  parpadean al entrar, salir y volver a entrar.
- Log:
  - Al arrancar se precargaron los 313 sombreados del manifiesto: 262 programas vivos y **31 rechazos de Mali en
    el mismo segundo**. El tope no actuó: durante la precarga todos cuentan como del lote actual.
  - Los rechazados quedaban "fallidos" toda la sesión y se dibujaban por CPU: tramos a 15 fps con la GPU al 22 %
    y el hilo de la GPU emulada al 60 %.
  - Recortes del tope (39 programas) y, al volver a la zona, recarga en segundo plano: el parpadeo.
- v4:
  - La precarga toma solo los 2/3 del tope más recientes del manifiesto (100).
  - Tras un recorte, los enlaces rechazados sin mensaje se olvidan y se reintentan.
  - Un programa con copia en disco se carga al momento en el hilo GL (si el candado del compilador está libre;
    si no, en segundo plano), sin dejar sus dibujos fuera. Se registra si tarda más de 30 ms.
  - Dos pantallas automáticas solo hasta la primera vez que aparece el HUD; luego deja de mirar la pantalla de abajo.
- Consola (`mm3d-v4-a`, manifiesto real de 406): "preparing the newest 100 of 406", 0 rechazos, 0 por CPU,
  ninguna carga de más de 30 ms, 93 % (99 % de media en muestras, 299/300 cuadros). Instalada (respaldo `pocket-native.v3`).

## 2026-11-22 — v5: precompilación en la primera carga

- Partida corta con la v4 (`mm3d-play-04`): 0 rechazos, 0 por CPU, 96 %. Todas las partidas terminan sin la línea de
  salida de `run.sh`: el usuario cierra con el atajo del sistema, no es un cuelgue.
- El manifiesto de la consola ya tenía 759 sombreados de **solo 2 programas de vértices** (707 y 23 líneas). El grande es
  idéntico a `2.pica`, que el kit saca de la romfs; `3dsrecomp learn` (con la carpeta `shaders.txt.vertex` al lado) los
  reconoce a los dos y deja una lista para compartir de 481 líneas, sin datos del juego.
- Esa lista va en el kit como `titles/0004000000125500/shaders.txt`; con `-Precache`, el kit escribe `vertex/precache.txt`
  (481: 437 del programa grande, 15 del chico, 29 de función fija) y el motor la precompila al arrancar con la pantalla
  "Preparando sombreados" (ahora en español), saltable con B, guardando cada programa sin dejarlo vivo.
- Consola (`mm3d-v5-a`): 270 precompilados en 3,2 s (ya estaban guardados), 0 rechazos, 0 por CPU, 95 %. Instalada
  (respaldos `pocket-native.v4` y `vertex.v4`). En una consola nueva serían unos 20–25 min la primera vez.

## 2026-11-24/25 — v6: sombreados separables, cosecha por teletransporte y precarga completa

- Partida de 33 min con la v5 (log en la SD): 0 rechazos, pero zonas negras al entrar a sitios nuevos. La lista de
  la consola pasó de 1 731 a 2 281 líneas en esa partida (1 291 sombreados distintos); OoT3D tiene 259 en total.
  Sin los registros de luces (0x140–0x1d9) quedarían 664; la iluminación genérica la descarta el propio menú
  ("muy lenta en la R36S").
- **Separables:** la prueba del 21-11 en la consola (`log_b-separables`) daba el dato clave: la mitad de vértices de
  3 968 líneas tarda 5,7 s **una vez** y cada fragmento nuevo 0,4–0,55 s, contra 2,8–3,3 s del programa entero.
  Aquella pasada salió peor solo porque las mitades no estaban guardadas. Activado para Majora en
  `titles/0004000000125500/profile.toml`; opción "Separable shaders" en el menú avanzado para apagarlo.
  - Memoria: al borrar un programa separable se libera su fragmento si nadie más lo usa; al precompilar, cada uno
    queda solo en disco (no vivo en Mali).
  - Carga inmediata de lo ya guardado también en separable (`fragment_stage_saved`).
- **Teletransporte (`ZAKURO_WARP=desde:cada:entradas`, solo para el probe del PC):** contexto del juego en
  `*(*0x72f5c0 + 0x16c)` (DekUI), `next_entrance` en `+0xC52E` (Project Restoration), disparador de transición `0x14` en
  `+0xC529` y tipo en `+0xC533` (orden del PlayState de la decompilación de N64). Con la partida del usuario, entradas
  `grupo << 9`: funciona (Ciudad Reloj Sur con `d800`, templos...). Tandas de 28 escenas con 500 cuadros cada una:
  56 escenas recorridas (la tanda 0 se arruinó al editar su script en marcha; la 3 se colgó en `c800`).
  `ZAKURO_WARP_TIME` fija la hora (datos de la partida en `0x7751D8`, hora en `+0x18`, noche en `+0x4`).
- Lista para compartir: lo jugado + lo cosechado → `3dsrecomp learn` → 2 634 sombreados (el kit precompila hasta 2 000).
- **Precarga completa** con la pantalla "Preparando sombreados"; si se salta con B, **sigue en segundo plano** de a uno,
  solo con el compilador libre (lo que pide la zona actual va primero), con un aviso en la esquina:
  "Preparando sombreados: faltan N (~M min)". Error encontrado y corregido: el reparto esperaba a que bajara la lista de
  pendientes, que nadie vaciaba durante la pantalla de carga → se quedaba trabada.
- **Piedra Sheikah:** mientras haya conversiones `y2r` (video), dos pantallas; 1,5 s después, una.
- **Diagnóstico:** cada cambio de lo que muestra la pantalla de abajo deja una captura en `data/shots/` (máx. 30).
- PC (Mesa), lista de 2 000, en frío: 1 022 preparados en 38,5 s; luego 14 400 cuadros con 167 dibujos omitidos
  (antes >1 100) y 120 % en juego.

## 2026-11-25 — prueba de la v6 en la consola (usuario)

- Opinión del usuario: "funciona de maravilla". Solo vio dibujos que faltaron un momento en la animación de Link
  poniéndose una máscara y en una escena del Skull Kid.
- Log (12 min): separables activos, la lista ya estaba precompilada de una sesión anterior del mismo día,
  **0 rechazos, 0 dibujos por CPU, 96 %** de media (233/300 cuadros dibujados), 415 MiB.
- 61 fragmentos nuevos (no estaban en la lista), mediana 354 ms, 47 de ellos entre las 18:08 y las 18:09 (~18 s):
  la máscara y el Skull Kid. Quedan guardados en la consola, así que ahí no se repiten. Para otros jugadores habría
  que sumar a la lista el manifiesto nuevo de la consola (2 896 líneas) con `3dsrecomp learn`.
- `data/shots`: lo que se marcaba como "otra cosa" durante charlas y escenas es **el HUD oscurecido** (el juego atenúa la
  pantalla de abajo). Para reactivar las dos pantallas automáticas en menús haría falta tratar el HUD oscurecido como HUD.
