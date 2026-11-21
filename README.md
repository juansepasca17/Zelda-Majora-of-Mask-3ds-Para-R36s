# Zelda Majora's Mask 3D para la R36S, en una pantalla

Port de *The Legend of Zelda: Majora's Mask 3D* a la R36S (y consolas Linux parecidas) con
[Pocket Native](https://github.com/whovian64/pocket-native), que recompila el juego de 3DS
en tu PC a un programa nativo para la consola. Es el hermano del port de OoT3D
(release `pocket-native-fix8`) y usa el mismo motor, ahora con un **HUD de una pantalla** propio.

**Este repo no trae nada del juego.** Necesitas tu propia copia desencriptada de
Majora's Mask 3D **USA Rev 1 (v1.1)**, `CTR-P-AJRE`, Title ID `0004000000125500`.

## Cómo se ve

El juego ocupa la pantalla entera (640×384, sin deformar) y el HUD va en las franjas negras:

- **Arriba:** corazones y magia, rupias.
- **Abajo:** Ver, y los botones **I · Y · X · II**.

Son recortes de la pantalla de abajo en vivo, así que todo lo que el juego dibuja ahí (objetos
asignados, máscaras, cantidades) se ve tal cual.

## Controles

| Botón | Hace |
|---|---|
| L2 | Usa el botón **I** |
| R2 | Usa el botón **II** |
| Select | Muestra la **pantalla de abajo completa** (máscaras, objetos, mapa, cuaderno) y vuelve |
| En esa vista: stick derecho + R2 | Mueve el cursor y toca o arrastra (para asignar máscaras y objetos) |
| Stick derecho (en juego) | Cámara (Circle Pad Pro emulado) |
| FN + R1 | Cambia a dos pantallas (arriba grande, abajo chica) y vuelve |
| El resto | Como en la 3DS |

## Rendimiento en la R36S (medido en la consola, probe con reloj fijo)

| Zona | Velocidad (100 % = 3DS, 30 fps) |
|---|---|
| Termina, con Link controlable | **111–129 %** (30 fps) |
| Escenas del bosque de la intro (Skull Kid) | 66–87 % (≈ 20–26 fps), límite de la GPU |
| Primera vez: compilación de sombreados | se salta dibujos unos segundos; se guarda y no vuelve a pasar |

0 % de código interpretado, sin SVC faltantes, ~270 MiB de memoria.

## Instalación (con el release)

1. **Compila tu ROM** con `PocketNative-kit-MM3D-v2.zip` (Pocket Native 0.6.1 + arreglos de fix8 + HUD):
   ```powershell
   powershell -ExecutionPolicy Bypass -File scripts\build.ps1 "C:\ruta\mm3d-usa-rev1.cci" -Out build -Precache
   ```
   Hace falta Docker Desktop abierto. Sale `build\Pocket Native\`.
2. Copia `build\Pocket Native\` a `/roms/ports/` de la SD.
3. Encima, copia `MM3D-UnaPantalla-R36S-v2.zip` (descomprimido): pone `hud.txt`, los ajustes
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
- `hud-sobre-fix8.patch`: solo el HUD (6 archivos).

## Por qué no DekUI

[DekUI](https://github.com/tgacquin/mm3d-dekui) y [Majora ReMasked](https://github.com/OTPR26/DekUI-Fork)
son forks del emulador Azahar (~220 archivos de C++ que cambian el código del juego en vivo), no
parches de ROM. Llevarlos a Pocket Native era mucho más trabajo que este HUD por composición.

## Carpetas

- `config/`: `hud.txt` y ajustes del juego.
- `patches/`: cambios al motor.
- `scripts/pc/`: pruebas sin pantalla en el PC (imagen `pn-run:1`).
- `scripts/console/`: trabajos para el agente de pruebas por red de la consola (`PN Dev.sh`).
- `docs/BITACORA.md`: mediciones.

## Licencia

MIT para lo de este repo. Pocket Native es MIT (fearkov, whovian).
