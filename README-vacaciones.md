Vacaciones — Parcial 2023

Resumen
- Modela destinos por persona, atracciones y costos de vida. Consulta vacaciones copadas, si no se cruzan, gasoleras e itinerarios posibles.

Cómo correr
- Abrir SWI-Prolog y cargar: `[vacaciones].`

Predicados clave
- Destinos: `va/2`; `persona/1` se infiere.
- Atracciones: `atraccion/2` con tipos `parque_nacional/1`, `cerro/2`, `cuerpo_agua/3`, `playa/1`, `excursion/1`.
- Copado: `copado/1` y `vacaciones_copadas/1` (inversible).
- No cruce: `no_se_cruzaron/2` (completamente inversible).
- Gasoleras: `vacaciones_gasoleras/1` (inversible) con `costo_vida/2`.
- Itinerarios: `itinerario/2` genera todas las permutaciones de destinos.

Consultas de ejemplo
- `vacaciones_copadas(alf).`
- `no_se_cruzaron(dodain, nico).`
- `vacaciones_gasoleras(martu).`
- `itinerario(alf, It).`

Notas de diseño
- Martu hereda destinos de Nico y Alf; Juan indeciso modelado con dos hechos; Carlos sin hechos `va/2`.
- Se evita perder info modelando cada tipo de atracción con su estructura y condiciones de “copado”.

