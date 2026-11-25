# Zelda Majora's Mask 3D para la R36S, en una pantalla

Port de *The Legend of Zelda: Majora's Mask 3D* a la R36S (y consolas Linux parecidas) con
[Pocket Native](https://github.com/whovian64/pocket-native), que recompila el juego de 3DS
en tu PC a un programa nativo para la consola. Es el hermano del port de OoT3D
(release `pocket-native-fix8`) y usa el mismo motor, ahora con un **HUD de una pantalla** propio.

**Este repo no trae nada del juego.** Necesitas tu propia copia desencriptada de
Majora's Mask 3D **USA Rev 1 (v1.1)**, `CTR-P-AJRE`, Title ID `0004000000125500`.

> **Cómo compilar y jugar, paso a paso: [docs/COMPILAR.md](docs/COMPILAR.md).**

## Estado: versión 1.0 ([release v1.0](https://github.com/juansepasca17/Zelda-Majora-of-Mask-3ds-Para-R36s/releases/tag/v1.0))

Probada jugando en la consola: 0 rechazos de Mali, 0 dibujos por CPU, 96 % de velocidad media. La 1.0 es la v6 de la tabla.

| Versión | Qué agregó |
|---|---|
| v1 | El juego sin mods, dos pantallas, español |
| v2 | HUD de una pantalla en el motor (`hud.txt`): recortes de la táctil, L2/R2 = I/II, Select = pantalla de abajo |
| v3 | Dos pantallas automáticas en el título y la selección de archivo; tope de programas para Mali |
| v4 | Precarga bajo el tope, reintento de rechazos de Mali, sin parpadeo al volver a una zona, una pantalla tras el primer HUD |
| v5 | Precompilación de 481 sombreados en la primera carga ("Preparando sombreados") |
| v6 = **1.0** | Sombreados separables (cada uno nuevo ~6 veces más barato en Mali), lista de **2 891** (jugados + cosechados por teletransporte, de día y de noche), precarga que sigue en segundo plano con aviso "faltan N (~M min)", dos pantallas con el video de la piedra Sheikah |

Detalles y mediciones de cada versión en [docs/BITACORA.md](docs/BITACORA.md).

## Cómo se ve

El juego ocupa la pantalla entera (640×384, sin deformar) y el HUD va en las franjas negras:

- **Arriba:** corazones y magia, rupias.
- **Abajo:** Ver, y los botones **I · Y · X · II**.

Son recortes de la pantalla de abajo en vivo, así que todo lo que el juego dibuja ahí (objetos
asignados, máscaras, cantidades) se ve tal cual.

Al empezar, mientras la pantalla de abajo muestra el título ("Oprime Start") o la selección de archivo,
el motor pone **las dos pantallas**. Cuando aparece el HUD de juego por primera vez pasa a una sola y ahí se queda
(Select muestra la de abajo cuando la necesites). Mientras se reproduce un video (las visiones de la piedra Sheikah)
se ponen las dos pantallas solas.

## Controles

| Botón | Hace |
|---|---|
| L2 | Usa el botón **I** |
| R2 | Usa el botón **II** |
| Select | Muestra la **pantalla de abajo completa** (máscaras, objetos, mapa, cuaderno) y vuelve |
| En esa vista: stick derecho + R2 | Mueve el cursor y toca o arrastra (para asignar máscaras y objetos) |
| Stick derecho (en juego) | Cámara (Circle Pad Pro emulado) |
| FN + R1 | Cambia a dos pantallas (arriba grande, abajo chica) y vuelve |
| FN | Menú de Pocket Native |
| FN + Start | Salir (mejor que el atajo del sistema, que cierra de golpe) |
| El resto | Como en la 3DS |

Guardar: en las estatuas de búho (la primera está en Ciudad Reloj Sur) o tocando la Canción del Tiempo.

## Rendimiento en la R36S (medido en la consola, probe con reloj fijo)

| Zona | Velocidad (100 % = 3DS, 30 fps) |
|---|---|
| Termina, con Link controlable | **111–129 %** (30 fps) |
| Escenas del bosque de la intro (Skull Kid) | 66–87 % (≈ 20–26 fps), límite de la GPU |
| Primera carga | pantalla **"Preparando sombreados"**: precompila 2 891 sombreados (unos 20–25 min estimados en una R36S nueva). **B la salta** y el resto sigue en segundo plano mientras juegas, con el aviso *"Preparando sombreados: faltan N (~M min)"* en la esquina. Así no salen zonas en negro al entrar a sitios nuevos |

0 % de código interpretado, sin SVC faltantes, ~270 MiB de memoria.

## Instalación (con el release)

1. **Compila tu ROM** con `PocketNative-kit-MM3D-v1.0.zip` (Pocket Native 0.6.1 + arreglos de fix8 + HUD):
   ```powershell
   powershell -ExecutionPolicy Bypass -File scripts\build.ps1 "C:\ruta\mm3d-usa-rev1.cci" -Out build -Precache
   ```
   Hace falta Docker Desktop abierto. **`-Precache` es importante:** el kit trae la lista de sombreados de Majora
   (`titles/0004000000125500/shaders.txt`) y saca de tu ROM los programas de vértices que necesita. Sale `build\Pocket Native\`.
2. Copia `build\Pocket Native\` a `/roms/ports/` de la SD.
3. Encima, copia `MM3D-UnaPantalla-R36S-v1.0.zip` (descomprimido): pone `hud.txt`, los ajustes
   (español, una pantalla) y el lanzador. Trae también el motor ya compilado, el mismo que sale del kit.

Si ya tienes OoT3D fix8 en la SD: el motor nuevo sirve para los dos. Sin `hud.txt` se comporta
exactamente como el de fix8, así que OoT3D sigue igual.

## Cómo funciona el HUD (para otros juegos)

Es un cambio al motor, no al juego: `hud.txt` en la carpeta `data` del juego. Con el layout
"TopOnly" dibuja recortes de la pantalla de abajo donde se le diga, y unos botones tocan puntos
fijos de la pantalla táctil. Formato en [config/hud.txt](config/hud.txt) y en
`frontend/src/hud.rs` del parche. Sirve para cualquier juego de 3DS con botones en la táctil.

Parches sobre Pocket Native 0.6.1 en [patches/](patches/):
- `pocket-native-0.6.1-fix8-hud.patch`: todo (fix8 + HUD) sobre el ZIP original.
- `hud-sobre-fix8.patch`: solo lo de Majora sobre fix8 (HUD, arreglos de Mali, aviso en español y la lista de sombreados).

## La lista de sombreados

[config/shaders.txt](config/shaders.txt) (481 líneas) es la lista para compartir que el kit armó (`3dsrecomp learn`) con lo que
se jugó en la consola: solo claves de programas de vértices y números de configuración de la GPU, nada del juego. Al compilar con
`-Precache`, el kit la cruza con tu ROM y deja `vertex/precache.txt`; el motor la precompila en la primera carga.

## Por qué no DekUI

[DekUI](https://github.com/tgacquin/mm3d-dekui) y [Majora ReMasked](https://github.com/OTPR26/DekUI-Fork)
son forks del emulador Azahar (~220 archivos de C++ que cambian el código del juego en vivo), no
parches de ROM. Llevarlos a Pocket Native era mucho más trabajo que este HUD por composición.

## Carpetas

- `config/`: `hud.txt`, ajustes del juego y la lista de sombreados.
- `patches/`: cambios al motor.
- `scripts/pc/`: pruebas sin pantalla en el PC (imagen `pn-run:1`).
- `scripts/console/`: trabajos para el agente de pruebas por red de la consola (`PN Dev.sh`).
- `docs/BITACORA.md`: mediciones.

## Licencia

MIT para lo de este repo. Pocket Native es MIT (fearkov, whovian).

## Sombreados separables

Majora combina más de 1 300 materiales con un programa de vértices de 3 968 líneas. En Mali, enlazar el programa entero
tarda ~2,8 s cada vez; con las dos mitades por separado, la de vértices se enlaza una vez (5,7 s) y cada material nuevo
solo su fragmento (~0,4–0,55 s). Está activado para Majora en `titles/0004000000125500/profile.toml`
([config/profile.toml](config/profile.toml)). Si en tu consola faltaran dibujos, se apaga en FN → Advanced → *Separable shaders*.

La lista se armó jugando y con el **teletransporte** del motor (ver [scripts/cosecha](scripts/cosecha/LEEME.md)).

## Ideas para después

- La lista de sombreados sale de unas pocas horas de juego. Más partidas la harían más completa: con el kit, `-Precache` sobre
  una carpeta ya jugada deja la lista nueva en `Pocket Native/shaders to share/`.
