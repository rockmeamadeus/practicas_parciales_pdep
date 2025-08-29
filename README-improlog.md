Improlog — Parcial MiT 2023

Resumen
- Modela integrantes, niveles, instrumentos (ritmico/armonico/melodico), y tipos de grupos.
- Consultas: buena base, se destaca, cupo, incorporar, se quedó en banda, puede tocar.

Cómo correr
- Abrir SWI-Prolog y cargar: `[improlog].`

Predicados clave
- Base: `integrante/3`, `nivelQueTiene/3`, `instrumento/2`.
- Tipos de grupo: `grupo/2` con `bigBand`, `formacion(Lista)`, `ensamble(NivelMin)`.
- `buena_base/1`: alguien rítmico y alguien armónico distintos.
- `se_destaca/2`: nivel propio ≥ nivel de todos + 2 en ese grupo.
- `hay_cupo/2`: sirve para el tipo y no existe en el grupo; excepción big band (melódicos de viento).
- `puede_incorporarse/3`: no forma parte, hay cupo, y nivel ≥ mínimo esperado (según tipo).
- `se_quedo_en_banda/1`: no pertenece y no hay ningún grupo donde pueda incorporarse.
- `puede_tocar/1`: depende de tipo (base + 5 vientos; o cubrir formación; o para ensamble base + algún melódico).

Consultas de ejemplo
- `buena_base(sophieTrio).`
- `se_destaca(sophie, sophieTrio).`
- `hay_cupo(vientosDelEste, trompeta).`
- `puede_incorporarse(lore, sophieTrio, violin).`
- `puede_tocar(jazzmin).` `puede_tocar(estudio1).`

Notas de diseño
- Mínimo esperado: big band=1; formaciones: `7 - cantidad`; ensamble: declarado.
- Extensibilidad: para nuevos tipos, agregar constructor en `grupo/2` y adaptar `sirve_para/2`, `minimo_esperado/2`, `puede_tocar/1`.

