# Cómo compilar y jugar Majora's Mask 3D en la R36S (versión 1.0)

Tu PC convierte tu copia de Majora's Mask 3D en un programa para la consola. La consola nunca compila nada: solo
copias a la SD lo que sale del PC. Se hace una vez (unos 30–60 min la primera vez, casi todo descargas).

## 0. Lo que necesitas

| Qué | Detalles |
|---|---|
| **Tu juego** | *Majora's Mask 3D* **USA Rev 1 (v1.1)**, Title ID `0004000000125500`, sacado de tu propia consola (por ejemplo con GodMode9) como `.3ds`/`.cci` **desencriptado** (o `.cia`). Si está encriptado, pon el `aes_keys.txt` de tu consola junto al kit (`-Keys aes_keys.txt`). |
| **Un PC** | Windows o Linux con procesador Intel/AMD, ~10 GB libres. |
| **Docker Desktop** (Windows) o **podman/docker** (Linux) | El kit compila dentro de un contenedor. En Windows, si no lo tienes, el script ofrece instalarlo. Ábrelo y espera a que diga *Engine running*. |
| **La consola** | R36S (o clon) con ArkOS / dArkOS / dArkOSRE y PortMaster. |
| **Los archivos del release** | De [la release v1.0](https://github.com/juansepasca17/Zelda-Majora-of-Mask-3ds-Para-R36s/releases/tag/v1.0): `PocketNative-kit-MM3D-v1.0.zip` y `MM3D-UnaPantalla-R36S-v1.0.zip`. |

## 1. Compilar en el PC

1. Descomprime `PocketNative-kit-MM3D-v1.0.zip`. Queda la carpeta `pocket-native-0.6.1`.
2. Abre Docker Desktop y espera a *Engine running*.
3. **Arrastra tu ROM sobre `Build a game.bat`** (o haz doble clic y elígela). En este kit, ese `.bat` ya incluye la
   precompilación de sombreados (`-Precache`): usa la lista de 2 891 sombreados de Majora
   (`titles/0004000000125500/shaders.txt`) y saca de tu ROM lo que hace falta para precompilarlos en la consola.
   - En Linux: doble clic en `Build a game.desktop`, o `scripts/build.sh /ruta/a/tu/mm3d.cci --out build --precache`.
   - Por comando en Windows: `powershell -ExecutionPolicy Bypass -File scripts\build.ps1 "C:\ruta\mm3d.cci" -Out build -Precache`.
uta\mm3d.cci" -Out build -Precache`.
   - **No uses `Update Pocket Native`**: bajaría el Pocket Native original y borraría los arreglos del port (en este kit
     solo muestra un aviso).
4. La primera vez arma el contenedor (~2 GB de descarga) y Rust. Después: recompila el juego (~2 min) y lo compila
   (~2–7 min). Al final dice `done: copy "Pocket Native" into roms/ports on the handheld's card`.
5. Resultado: `build\Pocket Native\`, con el lanzador `.sh` y la carpeta `pocket-native`. Comprueba que existe
   `build\Pocket Native\pocket-native\games\0004000000125500\vertex\precache.txt`: si no está, faltó `-Precache`.

## 2. Copiar a la SD

1. Copia **el contenido** de `build\Pocket Native\` a `/roms/ports/` de la SD de la consola.
2. Descomprime `MM3D-UnaPantalla-R36S-v1.0.zip` y copia **su contenido** encima, en `/roms/ports/` (acepta reemplazar):
   pone el HUD de una pantalla (`hud.txt`), los ajustes (español, una pantalla), el lanzador
   `Zelda Majoras Mask 3D.sh` y el motor compilado.
   - Si ya tienes OoT3D fix8 en la SD: puedes combinar carpetas sin miedo, el motor nuevo sirve para los dos.
3. Expulsa la SD con seguridad y ponla en la consola.
4. En ArkOS, si no aparece en *Ports*: Start → *UI Settings* → *Scan Ports folder on boot*, y reinicia.

## 3. Jugar

1. *Ports* → **Zelda Majoras Mask 3D**.
2. **La primera vez** sale "Preparando sombreados", con el progreso y el tiempo que falta (unos 20–25 min). Prepara los
   sombreados del juego para que no salgan zonas en negro al entrar a sitios nuevos.
   - **B lo salta**: lo que falte se sigue preparando mientras juegas, con el aviso
     *"Preparando sombreados: faltan N (~M min)"* arriba a la izquierda.
   - Solo pasa una vez. Lo preparado se guarda en la consola.
3. El título y la selección de archivo salen en dos pantallas; al empezar a jugar queda una sola, con el HUD en las
   franjas de arriba y abajo.

### Controles

| Botón | Hace |
|---|---|
| L2 / R2 | Usan los botones **I** / **II** |
| Select | Muestra la pantalla de abajo completa (máscaras, objetos, mapa, cuaderno); otra vez Select para volver |
| En esa vista: stick derecho + R2 | Mueve el cursor y toca o arrastra (para asignar máscaras y objetos a X, Y, I, II) |
| Stick derecho | Cámara |
| FN + R1 | Dos pantallas (arriba grande, abajo chica) / una |
| FN | Menú de Pocket Native (pantalla, rendimiento, controles, opciones avanzadas) |
| FN + Start | **Salir** (mejor que el atajo del sistema, que cierra de golpe) |
| El resto | Como en la 3DS |

**Guardar:** en las estatuas de búho (la primera está en la Ciudad Reloj Sur; golpéala para activarla y háblale con A) o
tocando la Canción del Tiempo. Durante la introducción no se puede guardar.

## 4. Si algo sale mal

| Problema | Qué hacer |
|---|---|
| La compilación falla con `Could not resolve host` o `no such host` | Es la red de Docker. Vuelve a correr el comando (sigue donde quedó). Si se repite, en `%USERPROFILE%\.docker\daemon.json` agrega `"dns": ["8.8.8.8", "1.1.1.1"]` y reinicia Docker Desktop. |
| No sale "Preparando sombreados" y hay zonas en negro | Faltó `-Precache` al compilar: vuelve a compilar con él y copia otra vez `games/0004000000125500/vertex/`. |
| Faltan dibujos siempre, o va más lento que antes | FN → *Advanced* → **Separable shaders** en *Off* (vuelve al modo de antes, con más zonas en negro). |
| Faltan dibujos un instante en una animación nueva | Normal la primera vez (se está preparando ese sombreado); queda guardado y no se repite. |
| No ves un menú del juego | Está en la pantalla de abajo: pulsa **Select**. |
| Quieres reportar un fallo | Trae `/roms/ports/pocket-native/games/0004000000125500/data/log.txt` (se borra al volver a abrir el juego) y, si hay, la carpeta `data/shots/`. |
