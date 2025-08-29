Bondis — Parcial MiT 2024

Resumen
- Modela recorridos por CABA y GBA y beneficios SUBE. Calcula combinaciones, jurisdicción, calles más transitadas, transbordos y costos por persona.

Cómo correr
- Abrir SWI-Prolog y cargar: `[bondis].`

Predicados clave
- Base: `recorrido/3` con `caba` o `gba(Zona)`.
- Combinación: `pueden_combinarse/2` si comparten calle en la misma área.
- Jurisdicción: `jurisdiccion/2` ⇒ `nacional` o `provincial(Prov)` según cruce de General Paz.
- Calles: `calle_mas_transitada/2`, `transbordo/2` (≥3 líneas y todas nacionales).
- Beneficios: `beneficiario/2` (estudiantil, casas_particulares(Area), jubilado).
- Costos: `costo_para/3`, base según jurisdicción y mínimos por beneficio (elige el menor).

Consultas de ejemplo
- `pueden_combinarse(17, 152).`
- `jurisdiccion(24, J).`
- `calle_mas_transitada(caba, Calle).`
- `transbordo(caba, Calle).`
- `costo_para(marta, 24, Costo).`

Notas de diseño
- Extensión de beneficios: agregar una cláusula a `costo_con_beneficio/4`.
- Costo PBA: `25 * (#calles gba)` + `50` si pasa por más de una zona.

