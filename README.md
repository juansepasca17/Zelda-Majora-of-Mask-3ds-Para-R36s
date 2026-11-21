# Zelda Majora's Mask 3D para la R36S

Port de *The Legend of Zelda: Majora's Mask 3D* a la R36S (y consolas Linux parecidas) con
[Pocket Native](https://github.com/whovian64/pocket-native), que recompila el juego de 3DS
en tu PC a un programa nativo para la consola. Es el hermano del port de OoT3D
(release `pocket-native-fix8`), y usa el mismo motor y los mismos arreglos.

**Este repo no trae nada del juego.** Necesitas tu propia copia desencriptada de
Majora's Mask 3D **USA Rev 1 (v1.1)**, `CTR-P-AJRE`, Title ID `0004000000125500`.
Es la misma versión que piden los mods de una pantalla (DekUI, Majora ReMasked).

## Estado

| Versión | Qué es | Estado |
|---|---|---|
| v1 | Juego sin mods, dos pantallas (arriba grande, abajo chica), español | En prueba |
| v2 | Una pantalla | Sin empezar: no existe un parche de ROM, ver abajo |

### v1, prueba en el PC (sin pantalla, Mesa por software)

- Arranca y llega a jugar: intro, Skull Kid, bosque, Link controlable con el HUD de abajo.
- 145 % de la velocidad de la 3DS, **0 % de código interpretado**, ningún SVC faltante.
- 14 400 cuadros sin cuelgues.

Las mediciones en la consola van en [docs/BITACORA.md](docs/BITACORA.md).

## Cómo compilarlo

Igual que OoT3D (ver la guía `docs/COMPILAR.md` del repo de OoT3D), pero sin mod:

1. Kit Pocket Native 0.6.1 con `pocket-native-0.6.1-reframed.patch` (el del release `pocket-native-fix8`
   de OoT3D). El motor que sale es idéntico: sirve el mismo para los dos juegos.
2. Docker Desktop abierto y, desde la carpeta del kit:
   ```powershell
   powershell -ExecutionPolicy Bypass -File scripts\build.ps1 "C:\ruta\mm3d-usa-rev1.cci" -Out build -Precache
   ```
3. Copia `build\Pocket Native\pocket-native\games\0004000000125500\` a
   `/roms/ports/pocket-native/games/` de la SD, y el lanzador a `/roms/ports/`.
4. Ajustes de Majora (solo este juego, no cambia OoT3D):
   `games/0004000000125500/data/settings.toml` → [`config/settings.toml`](config/settings.toml).

## Una pantalla: por qué todavía no

Los mods que existen, [DekUI](https://github.com/tgacquin/mm3d-dekui) y
[Majora ReMasked](https://github.com/OTPR26/DekUI-Fork), **no son parches de la ROM**: son
forks del emulador Azahar. Cambian instrucciones del juego por llamadas al emulador y hacen el
trabajo en ~220 archivos de C++ (más cambios en los sombreados). Para Pocket Native habría que
reescribir en Rust la parte del HUD. Se decide después de medir la v1 en la consola.

## Carpetas

- `scripts/pc/`: pruebas sin pantalla en el PC (imagen `pn-run:1`).
- `scripts/console/`: trabajos para el agente de pruebas por red de la consola (`PN Dev.sh`).
- `config/`: ajustes del juego.
- `docs/`: bitácora y mediciones.

## Licencia

MIT para lo de este repo. Pocket Native y sus parches tienen su propia licencia.
