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
