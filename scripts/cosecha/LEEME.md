# Cosecha de sombreados por teletransporte (PC, sin pantalla)

El motor tiene una opción de desarrollo, solo para el probe del PC y solo para Majora's Mask 3D USA 1.1:

- `ZAKURO_WARP=desde:cada:entradas` (hex, separadas por comas): a partir del cuadro `desde`, cada `cada` cuadros escribe
  la siguiente entrada en el contexto del juego (`*(*0x72f5c0 + 0x16c)`: `next_entrance` en `+0xC52E`, disparador `0x14`
  en `+0xC529`, tipo en `+0xC533`) y Link aparece allí.
- `ZAKURO_WARP_TIME=hex`: fija la hora al saltar (datos de la partida en `0x7751D8 + 8`: hora en `+0x18`, noche en `+0x4`;
  `0800` = 2 de la madrugada).

`warp_probe.sh` corre el probe con una partida guardada (`/work/save/user`) y deja crecer `data/shaders.txt`.
`tanda1.txt` y `tanda2.txt` son las 56 entradas (`grupo << 9`) que funcionaron; `noche.txt`, las mismas para la pasada
nocturna. Luego: unir los manifiestos (con sus carpetas `.vertex`) y `3dsrecomp learn ROM unido.txt lista.txt` da la lista
para compartir (`config/shaders.txt`).
