Prolog de la Costa — Parcial 2023

Resumen
- Modela comidas, atracciones (tranquilas, intensas, montañas, acuáticas), meses y visitantes/grupos.
- Consultas: bienestar, satisfacer hambre, lluvia de hamburguesas, opciones por mes.

Cómo correr
- Abrir SWI-Prolog y cargar: `[prolog_de_la_costa].`

Predicados clave
- Base: `comida/2`, `tranquila/2`, `intensa/2`, `montana_rusa/3`, `acuatico/1`.
- Visitantes: `visitante/6` y derivados (`edad/2`, `dinero/2`, `chico/1`, `adulto/1`, `viene_solo/1`).
- Bienestar: `bienestar/2` con excepción si viene solo.
- Hambre: `grupo_puede_satisfacer_hambre/2` (pago + `satisface/2`).
- Lluvia: `lluvia_de_hamburguesas/2` usando `peligrosa_para/2` según edad/estado.
- Opciones: `opcion_entretenimiento/3` por mes (considera apertura de acuáticas).

Consultas de ejemplo
- `bienestar(eusebio, E).`
- `grupo_puede_satisfacer_hambre(viejitos, hamburguesa).`
- `lluvia_de_hamburguesas(tomi, A).`
- `opcion_entretenimiento(sofi, enero, Opcion).`

Notas de diseño
- Inversibilidad en consultas principales con dominios y `forall/2` cuando corresponde.
- Peligrosidad de montañas: usa `aggregate_all/3` para máximo de giros y la excepción de “necesita_entretenerse”.
- Apertura acuática: de septiembre a marzo; resto todo el año.

