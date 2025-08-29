Turf! — Parcial Lógico 2024

Resumen
- Modela jockeys, caballos, studs, premios y preferencias.
- Consultas: preferencia múltiple, aborrecimiento por stud, piolines, apuestas y colores.

Cómo correr
- Abrir SWI-Prolog y cargar: `[turf].`

Predicados clave
- `jockey/3`, `caballo/1`, `stud/2`, `gano/2`, `prefiere/2`.
- `prefiere_mas_de_un_jockey/1` (inversible).
- `aborrece/2` (inversible): caballo × stud.
- `piolin/1` (inversible): preferido por todos los ganadores de premios importantes.
- `gana_apuesta/2`: `ganador/1`, `segundo/1`, `exacta/2`, `imperfecta/2`.
- `tiene_color/2`, `puede_comprar/2` (subconjuntos por color).

Consultas de ejemplo
- `prefiere_mas_de_un_jockey(C).`
- `aborrece(botafogo, el_tute).`
- `piolin(J).`
- `gana_apuesta(imperfecta(old_man, botafogo), [botafogo, old_man, _]).`
- `puede_comprar(marron, Cs).`

Notas de diseño
- Inversibilidad con dominios (`caballo/1`, `jockey/3`, `caballeriza/1`) y `\=/2` para desigualdad.
- Negación controlada para Enérgica y aborrecimiento.
- Pelaje se descompone en colores base para no perder información.

