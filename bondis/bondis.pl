% Base de conocimiento
recorrido(17,  gba(sur),   mitre).
recorrido(24,  gba(sur),   belgrano).
recorrido(247, gba(sur),   onsari).
recorrido(60,  gba(norte), maipu).
recorrido(152, gba(norte), olivos).

recorrido(17,  caba, santaFe).
recorrido(152, caba, santaFe).
recorrido(10,  caba, santaFe).
recorrido(160, caba, medrano).
recorrido(24,  caba, corrientes).

% 1) Dos líneas se pueden combinar si comparten al menos una calle en una misma área.
pueden_combinarse(Linea1, Linea2) :-
    recorrido(Linea1, Area, Calle),
    recorrido(Linea2, Area, Calle),
    Linea1 \= Linea2.

% 2) La jurisdicción de una línea puede ser:
%    - nacional: si pasa por CABA y por al menos una zona del GBA
%    - provincial(caba): si pasa solo por CABA
%    - provincial(buenosAires): si pasa solo por GBA
jurisdiccion(Linea, nacional) :-
    recorrido(Linea, caba, _),
    recorrido(Linea, gba(_), _).

jurisdiccion(Linea, provincial(caba)) :-
    recorrido(Linea, caba, _),
    \+ recorrido(Linea, gba(_), _).

jurisdiccion(Linea, provincial(buenosAires)) :-
    recorrido(Linea, gba(_), _),
    \+ recorrido(Linea, caba, _).



% 3) La calle más transitada de una zona es aquella por la que pasan más líneas.
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


% 4) Una calle es transbordo si por ella pasan al menos 3 líneas y todas son nacionales.
transbordo(Area, Calle) :-
    cantidad_lineas(Area, Calle, CantLineas), CantLineas >= 3,
    forall(recorrido(Linea, Area, Calle), jurisdiccion(Linea, nacional)).


% 5) El costo del boleto depende de la jurisdicción y los beneficios.
%    Costos base: nacional $500, provincial(caba) $350, provincial(buenosAires) $25*calles + plus_zonas
%    Beneficios: estudiantil $50, casas_particulares gratis si pasa por esa área, jubilado 50% descuento
beneficiario(pepito,  casas_particulares(gba(oeste))).
beneficiario(juanita, estudiantil).
beneficiario(marta,   jubilado).
beneficiario(marta,   casas_particulares(caba)).
beneficiario(marta,   casas_particulares(gba(sur))).

costo_normal(Linea, 500) :- jurisdiccion(Linea, nacional).
costo_normal(Linea, 350) :- jurisdiccion(Linea, provincial(caba)).
costo_normal(Linea, Costo) :-
    jurisdiccion(Linea, provincial(buenosAires)),
    cantidad_calles_gba(Linea, CantCalles),
    plus_zonas_gba(Linea, Plus),
    Costo is 25 * CantCalles + Plus.

cantidad_calles_gba(Linea, CantidadCalles) :-
    findall(Calle, recorrido(Linea, gba(_), Calle), CallesDuplicadas),
    sort(CallesDuplicadas, Calles),
    length(Calles, CantidadCalles).

plus_zonas_gba(Linea, 50) :- cantidad_zonas_gba(Linea, CantidadZonas), CantidadZonas > 1.
plus_zonas_gba(Linea, 0)  :- cantidad_zonas_gba(Linea, 1).

cantidad_zonas_gba(Linea, CantidadZonas) :-
    findall(Zona, recorrido(Linea, gba(Zona), _), ZonasDuplicadas),
    sort(ZonasDuplicadas, Zonas),
    length(Zonas, CantidadZonas).

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

