# Prácticas Parciales – Paradigma Lógico (Prolog)

Este proyecto agrupa resoluciones de parciales/prácticas en Prolog:

- Bondis (`bondis.pl`)
- Improlog (`improlog.pl`)
- Prolog de la Costa (`prolog_de_la_costa.pl`)
- Turf! (`turf.pl`)
- Vacaciones (`vacaciones.pl`)

Cada ejercicio cuenta con un README específico con notas de modelado y decisiones de diseño.

## Requisitos

- SWI‑Prolog (probado con 8.x)

## Uso rápido

En cada archivo, cargar en SWI‑Prolog y consultar predicados del enunciado. Ejemplo:

```
?- [prolog_de_la_costa].
?- opcion_entretenimiento(sofi, enero, Opcion).
```

## Convenciones

- Preferimos `forall/2` y formulaciones declarativas (evitando `aggregate_all/3` cuando la universalidad es más expresiva).
- Evitamos disyunciones largas en una sola cláusula; separamos en múltiples cláusulas.
- Evitamos `arg/3`; preferimos unificación por patrones.

## Estructura

- `*.pl`: soluciones Prolog
- `README-*.md`: notas por problema

## Licencia

Uso académico.
