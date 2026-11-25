# Lecciones para otros ports de 3DS a la R36S (Pocket Native)

Lo aprendido con OoT3D (fix1–fix8) y Majora's Mask 3D (v1–v6). Sirve para cualquier juego de 3DS en la R36S
(RK3326, Mali-G31, 1 GB) y para volver a OoT3D. Pendiente de confirmar con la prueba de la v6 en la consola.

## 1. Sombreados: lo que más se nota en la R36S

- **Mide cuántos sombreados distintos tiene el juego** (`data/shaders.txt`, una línea por combinación). OoT3D: 259;
  Majora: más de 2 800. Un juego con muchas combinaciones va a tener zonas en negro aunque corra a 30 fps.
- **En Mali, enlazar es lo caro, no compilar.** Un programa con el programa de vértices grande (3 968 líneas) tarda
  ~2,8–3,3 s en enlazar; el log lo dice en "programs compiled ... ms linking" y "a slow program".
- **Sombreados separables** (`separable_shaders`, por juego en `titles/<id>/profile.toml`): la mitad de vértices se enlaza
  una vez (5,7 s) y cada material nuevo solo su fragmento (0,4–0,55 s). Para un juego con muchas combinaciones, actívalo.
  Al probarlo, compara con los dos modos ya guardados en disco (si no, el que no tiene copias guardadas pierde siempre).
- **El controlador de Mali rechaza enlaces** (log vacío, "could not link a program,") con ~190 programas grandes vivos
  a la vez. Los rechazados se dibujaban por CPU toda la sesión → 15 fps. Remedios en el motor: tope de programas vivos
  (`ZAKURO_PROGRAM_CAP`, 150), precarga al arrancar limitada al tope, reintento de los rechazados tras liberar espacio
  y, en separable, liberar el fragmento al borrar el programa.
- **La iluminación genérica y los sombreados genéricos** reducen combinaciones, pero en la R36S son muy lentos
  (genéricos: 10 %, 1 fps). No sirven.
- **Lista para compartir:** `3dsrecomp learn ROM manifiesto.txt lista.txt` (con la carpeta `manifiesto.txt.vertex/` al lado)
  convierte lo jugado en una lista sin datos del juego → `titles/<id>/shaders.txt`. El kit, con `-Precache`, saca de la ROM
  los programas de vértices (`vertex/N.pica`) y escribe `vertex/precache.txt`. Tope del kit: `MOST` en
  `recompiler/src/precache/mod.rs` (lo subimos a 3 000).
- **Precarga:** pantalla "Preparando sombreados" al arrancar, saltable con B; lo que falte sigue en segundo plano de a uno,
  solo con el compilador libre (lo que pide la zona actual va primero), con aviso de cuánto falta.
  Ojo: la cola del compilador es FIFO; no la llenes con miles de trabajos de precarga.

## 2. Cosechar sombreados sin jugar (teletransporte)

- En Grezzo (OoT3D y MM3D) el contexto de juego tiene `next_entrance`, un disparador de transición y el tipo, en el mismo
  orden que el PlayState de la decompilación de N64 (disparador 5 bytes antes, tipo 5 después). Escribir la entrada +
  disparador `0x14` lleva a Link allí. Majora USA 1.1: contexto `*(*0x72f5c0 + 0x16c)`, entrada en `+0xC52E`.
  Fuentes: DekUI (`src/mm3d/*.h`) y Project Restoration (`source/game/context.h`, `common_data.h`).
- Hora: datos de la partida (Majora USA 1.1) en `0x7751D8 + 8` (antes van `start` y `scene`): hora `u16` en `+0x18`,
  noche en `+0x4`. Valida leyendo el valor antes de escribir (debe coincidir con la hora en pantalla).
- Corre las tandas en el probe del PC con una partida guardada, en grupos pequeños (una entrada inválida puede colgar el
  juego) y con tiempo límite. No edites un script de bash mientras corre.
- Para OoT3D la idea es la misma; habría que buscar sus direcciones (OoT3D Randomizer y Project Restoration de OoT3D).

## 3. Una pantalla

- Si el mod de una pantalla es un fork de emulador (como DekUI), no se porta: haz el HUD en el motor (`hud.txt`):
  recortes de la pantalla de abajo en las franjas de TopOnly, teclas que tocan un punto, tecla para ver la de abajo.
- Menús en la pantalla de abajo (título, selección de archivo): detecta con `check X Y R G B` (colores del HUD) y pon las dos
  pantallas **solo hasta ver el HUD por primera vez**; en juego, las charlas cambian la pantalla de abajo y molestaría.
- Video (`y2r`): las conversiones cuentan cuadros de video; úsalo para poner las dos pantallas (piedra Sheikah).

## 4. Pruebas y entorno

- **Primero el PC** (probe sin pantalla con Mesa, `ZAKURO_PANEL_SHOT` para ver el panel compuesto, `ZAKURO_SHOT_AT` para
  las dos pantallas), **después la consola** (agente `PN Dev.sh` + `devserver.py` por Tailscale; la app de Tailscale del PC
  tiene que estar abierta).
- El probe del PC **no** pasa por todo: no recorre la Ciudad Reloj ni abre menús. Pide una partida real y trae `log.txt`.
- Los logs sin "exit status" al final no son cuelgues: el usuario cerró con el atajo del sistema.
- Docker Desktop en esta PC pierde DNS a ratos: `dns: ["8.8.8.8","1.1.1.1"]` en `~/.docker/daemon.json` lo arregla
  (lo revertimos al terminar). Reintenta las compilaciones en un bucle.
- `Compress-Archive` de PowerShell 5.1 guarda rutas con `\`: haz los ZIP con Python (`zipfile`).
- Antes de un proceso largo: energía en "nunca suspender" (también con la tapa cerrada) y restaurarla al final.
