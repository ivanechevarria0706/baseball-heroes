# Baseball Heroes Remake — Phase 8O
## Match Presentation / VS / Loading

Esta fase mejora la transición entre LINE UP y el partido para que el juego no
salte de una pantalla de menú directamente al gameplay.

### Nuevo flujo

```text
LINE UP
  -> BASEBALL HEROES LOADING
  -> VS PRESENTATION
  -> BALLPARK REVEAL / PLAY BALL!
  -> GAME
```

### Cambios
- Pantalla de loading estilo Baseball Heroes con barra de progreso.
- Presentación VS con escudos, Hero, pitcher, ciudades, equipos y OVR.
- Reveal del estadio antes de iniciar el juego.
- `PLAY BALL!` como cierre de la presentación.
- Sonidos de transición reutilizando los SFX limpios ya incluidos.
- SPACE o ENTER permiten saltar la presentación.
- Botón SKIP disponible.
- Botón BACK vuelve a LINE UP sin gastar energía.
- La energía ahora se descuenta sólo al terminar/saltar la presentación y
  entrar realmente al partido.
- Se conserva el autoescalado de ventana y todo el gameplay de 8N.

### Probar

```powershell
cd "C:\Users\ivane\Downloads\baseball_heroes_remake_phase8O_match_presentation"
.\play.bat
```

Prueba `HOME -> PLAY BALL -> LINE UP -> PLAY` y observa las tres etapas antes
del primer inning.
