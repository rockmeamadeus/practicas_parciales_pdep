% Bondis (Pdep MiT 2024)

% Recorridos de ejemplo
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

zona_gba(sur). zona_gba(norte). zona_gba(oeste). zona_gba(este).

% 1) Pueden combinarse si comparten calle en la misma área
pueden_combinarse(L1, L2) :-
    recorrido(L1, Area, Calle),
    recorrido(L2, Area, Calle),
    L1 \= L2.

% 2) Jurisdicción de una línea
% nacional si cruza general paz (tiene recorridos en caba y en gba)
jurisdiccion(Linea, nacional) :-
    recorrido(Linea, caba, _),
    recorrido(Linea, gba(_), _).

% provincial(caba) si solo pasa por caba
jurisdiccion(Linea, provincial(caba)) :-
    recorrido(Linea, caba, _),
    \+ recorrido(Linea, gba(_), _).

% provincial(buenosAires) si solo pasa por gba
jurisdiccion(Linea, provincial(buenosAires)) :-
    recorrido(Linea, gba(_), _),
    \+ recorrido(Linea, caba, _).

% 3) Calle más transitada de una zona
% zona puede ser caba o gba(Zona)

% Calle perteneciente a un área (deduplicada con distinct/2)
calle_en_zona(Area, Calle) :- distinct(Calle, recorrido(_, Area, Calle)).

% Una calle A es más transitada que B si todas las líneas de B pasan por A
% y existe al menos una línea que pase por A y no por B.
mas_transitada_que(Area, A, B) :-
    calle_en_zona(Area, A),
    calle_en_zona(Area, B),
    forall(recorrido(L, Area, B), recorrido(L, Area, A)),
    recorrido(Lx, Area, A), \+ recorrido(Lx, Area, B).

% Definimos la calle más transitada evitando conteos
calle_mas_transitada(Area, Calle) :-
    calle_en_zona(Area, Calle),
    \+ (calle_en_zona(Area, Otra), Otra \= Calle, mas_transitada_que(Area, Otra, Calle)).

% 4) Calles de transbordos en una zona: al menos 3 líneas y todas nacionales

transbordo(Area, Calle) :-
    calle_en_zona(Area, Calle),
    % existen al menos 3 líneas distintas en esa calle
    recorrido(L1, Area, Calle),
    recorrido(L2, Area, Calle), L2 \= L1,
    recorrido(L3, Area, Calle), L3 \= L1, L3 \= L2,
    % y todas son nacionales
    forall(recorrido(L, Area, Calle), jurisdiccion(L, nacional)).


% 5) Beneficios y costos

% beneficios: estudiantil ; casas_particulares(Area) ; jubilado
beneficiario(pepito,  casas_particulares(gba(oeste))).
beneficiario(juanita, estudiantil).
beneficiario(tito,    sin_beneficio).
beneficiario(marta,   jubilado).
beneficiario(marta,   casas_particulares(caba)).
beneficiario(marta,   casas_particulares(gba(sur))).

% costo normal (sin beneficios)
costo_normal(Linea, 500) :- jurisdiccion(Linea, nacional).
costo_normal(Linea, 350) :- jurisdiccion(Linea, provincial(caba)).
costo_normal(Linea, Costo) :-
    jurisdiccion(Linea, provincial(buenosAires)),
    cantidad_calles_gba(Linea, CantCalles),
    plus_zonas_gba(Linea, Plus),
    Costo is 25 * CantCalles + Plus.

% Cantidad de calles GBA distintas usando setof/3 (evita aggregate_all)
cantidad_calles_gba(Linea, Cant) :-
    findall(Calle, recorrido(Linea, gba(_), Calle), CallesDup),
    sort(CallesDup, Calles),
    length(Calles, Cant).

% Plus por zonas GBA: 50 si recorre más de una zona, 0 si una sola
plus_zonas_gba(Linea, 50) :-
    recorrido(Linea, gba(Z1), _),
    recorrido(Linea, gba(Z2), _),
    Z1 \= Z2.
plus_zonas_gba(Linea, 0) :-
    recorrido(Linea, gba(Z), _),
    forall(recorrido(Linea, gba(Z2), _), Z2 = Z).

% costo con beneficios por persona: tomar el mínimo aplicable
costo_para(Persona, Linea, CostoFinal) :-
    costo_normal(Linea, Base),
    findall(C, costo_con_beneficio(Persona, Linea, Base, C), Opciones),
    Opciones = [],
    CostoFinal = Base.

costo_para(Persona, Linea, CostoFinal) :-
    costo_normal(Linea, Base),
    findall(C, costo_con_beneficio(Persona, Linea, Base, C), Opciones),
    Opciones \= [],
    min_list(Opciones, CostoFinal).

costo_con_beneficio(Persona, Linea, Base, 50) :- beneficiario(Persona, estudiantil).
costo_con_beneficio(Persona, Linea, _Base, 0) :-
    beneficiario(Persona, casas_particulares(Area)),
    recorrido(Linea, Area, _).
costo_con_beneficio(Persona, _Linea, Base, Mitad) :-
    beneficiario(Persona, jubilado),
    Mitad is Base / 2.

% 5.c) Agregar nuevos beneficios: se modela como nuevas cláusulas de costo_con_beneficio/4.
