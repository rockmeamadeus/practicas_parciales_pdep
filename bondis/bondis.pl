% Bondis (Pdep MiT 2024) — versión refactorizada
% Objetivos:
% - Mantener exactamente el mismo enunciado y resultados
% - Aplicar buenas prácticas (inversibilidad, evitar duplicaciones, cuantificadores universales)
% - Tomar como referencia de estilo el parcial resuelto del profe (turf_version_profe.pl)

% -------------------------------
% Base de conocimiento (hechos)
% -------------------------------
% recorrido(Linea, Area, Calle).
% Area: caba | gba(Zona) con Zona en {sur,norte,oeste,este}

% GBA
recorrido(17,  gba(sur),   mitre).
recorrido(24,  gba(sur),   belgrano).
recorrido(247, gba(sur),   onsari).
recorrido(60,  gba(norte), maipu).
recorrido(152, gba(norte), olivos).

% CABA
recorrido(17,  caba, santaFe).
recorrido(152, caba, santaFe).
recorrido(10,  caba, santaFe).
recorrido(160, caba, medrano).
recorrido(24,  caba, corrientes).

% --------------------------------------
% 1) Combinación: comparten calle y área
% --------------------------------------
pueden_combinarse(Linea1, Linea2) :-
    recorrido(Linea1, Area, Calle),
    recorrido(Linea2, Area, Calle),
    Linea1 \= Linea2.

% --------------------------------------
% 2) Jurisdicción de una línea
%    nacional si pasa por CABA y GBA
%    provincial(caba) si solo CABA
%    provincial(buenosAires) si solo GBA
% --------------------------------------
jurisdiccion(Linea, nacional) :-
    recorrido(Linea, caba, _),
    recorrido(Linea, gba(_), _).

jurisdiccion(Linea, provincial(caba)) :-
    recorrido(Linea, caba, _),
    \+ recorrido(Linea, gba(_), _).

jurisdiccion(Linea, provincial(buenosAires)) :-
    recorrido(Linea, gba(_), _),
    \+ recorrido(Linea, caba, _).


% ---------------------------------------------------
% 3) Calle más transitada de una zona (sin conteos)
%     - Se compara por inclusión de líneas (cuantificación)
%     - Evita aggregate: usa forall/2 con generadores
% ---------------------------------------------------

mas_transitada_que(Area, CalleA, CalleB) :-
    cantidad_lineas(Area, CalleA, CantA),
    cantidad_lineas(Area, CalleB, CantB),
    CantA > CantB.

cantidad_lineas(Area, Calle, Cantidad) :-
    findall(Linea, recorrido(Linea, Area, Calle), Lineas),
    length(Lineas, Cantidad).

calle_mas_transitada(Area, Calle) :-
    recorrido(_, Area, Calle),
    forall((recorrido(_, Area, OtraCalle), OtraCalle \= Calle), \+ mas_transitada_que(Area, OtraCalle, Calle)).




% --------------------------------------------------------------------
% 4) Transbordo en una zona: al menos 3 líneas distintas y todas nacionales
%     - Se computa cantidad con findall/sort (dedup)
%     - Universalidad sobre el conjunto de líneas de la calle
% --------------------------------------------------------------------

transbordo(Area, Calle) :-
    calle_en_zona(Area, Calle),
    lineas_en_calle(Area, Calle, LineasQuePasan),
    length(LineasQuePasan, CantidadLineas), CantidadLineas >= 3,
    forall(member(Linea, LineasQuePasan), jurisdiccion(Linea, nacional)).

lineas_en_calle(Area, Calle, Lineas) :-
    findall(Linea, recorrido(Linea, Area, Calle), LineasDuplicadas),
    sort(LineasDuplicadas, Lineas).


% ---------------------------------
% 5) Beneficios y costos por persona
% ---------------------------------

% Beneficios: estudiantil ; casas_particulares(Area) ; jubilado
beneficiario(pepito,  casas_particulares(gba(oeste))).
beneficiario(juanita, estudiantil).
beneficiario(tito,    sin_beneficio).
beneficiario(marta,   jubilado).
beneficiario(marta,   casas_particulares(caba)).
beneficiario(marta,   casas_particulares(gba(sur))).

% Costo normal (sin beneficios)
costo_normal(Linea, 500) :- jurisdiccion(Linea, nacional).
costo_normal(Linea, 350) :- jurisdiccion(Linea, provincial(caba)).
costo_normal(Linea, Costo) :-
    jurisdiccion(Linea, provincial(buenosAires)),
    cantidad_calles_gba(Linea, CantCalles),
    plus_zonas_gba(Linea, Plus),
    Costo is 25 * CantCalles + Plus.

% Cantidad de calles GBA distintas
cantidad_calles_gba(Linea, CantidadCalles) :-
    findall(Calle, recorrido(Linea, gba(_), Calle), CallesDuplicadas),
    sort(CallesDuplicadas, Calles),
    length(Calles, CantidadCalles).

% Plus por zonas GBA: 50 si recorre más de una zona, 0 en caso contrario
plus_zonas_gba(Linea, 50) :- cantidad_zonas_gba(Linea, CantidadZonas), CantidadZonas > 1.
plus_zonas_gba(Linea, 0)  :- cantidad_zonas_gba(Linea, 1).

cantidad_zonas_gba(Linea, CantidadZonas) :-
    findall(Zona, recorrido(Linea, gba(Zona), _), ZonasDuplicadas),
    sort(ZonasDuplicadas, Zonas),
    length(Zonas, CantidadZonas).

% Costo final considerando beneficios: elegimos el mínimo entre base y opciones
costo_para(Persona, Linea, CostoFinal) :-
    costo_normal(Linea, CostoBase),
    findall(Costo, costo_con_beneficio(Persona, Linea, CostoBase, Costo), CostosConBeneficio),
    min_list([CostoBase|CostosConBeneficio], CostoFinal).

costo_con_beneficio(Persona, _Linea, _CostoBase, 50) :-
    beneficiario(Persona, estudiantil).

costo_con_beneficio(Persona, Linea, _CostoBase, 0) :-
    beneficiario(Persona, casas_particulares(Area)),
    recorrido(Linea, Area, _).

costo_con_beneficio(Persona, _Linea, CostoBase, CostoMitad) :-
    beneficiario(Persona, jubilado),
    CostoMitad is CostoBase / 2.

% Nota: agregar nuevos beneficios = nuevas cláusulas de costo_con_beneficio/4.
