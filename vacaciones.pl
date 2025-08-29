% Vacaciones (Parcial 2023)

% ----- Punto 1: Destinos -----

% va(Persona, Destino)
va(dodain, pehuenia).
va(dodain, san_martin).
va(dodain, esquel).
va(dodain, sarmiento).
va(dodain, camarones).
va(dodain, playas_doradas).

va(alf, bariloche).
va(alf, san_martin).
va(alf, el_bolson).

va(nico, mar_del_plata).

va(vale, calafate).
va(vale, el_bolson).

% Martu va donde Nico y Alf
va(martu, Destino) :- va(nico, Destino).
va(martu, Destino) :- va(alf, Destino).

% Juan indeciso entre Villa Gesell o Federación
va(juan, villa_gesell).
va(juan, federacion).

% Carlos no se va de vacaciones: no hay hechos va(carlos,_).

persona(Persona) :- distinct(Persona, va(Persona, _)).


% ----- Punto 2: Atracciones y copado -----

% atraccion(Destino, Tipo)
% Tipos:
%  parque_nacional(Nombre)
%  cerro(Nombre, Altura)
%  cuerpo_agua(Nombre, PescaSiNo, Temp)
%  playa(DifMareas)
%  excursion(Nombre)

% Ejemplos del enunciado
atraccion(esquel, parque_nacional(los_alerces)).
atraccion(esquel, excursion(trochita)).
atraccion(esquel, excursion(trevelin)).

atraccion(pehuenia, cerro(batea_mahuida, 2000)).
atraccion(pehuenia, cuerpo_agua(moquehue, si, 14)).
atraccion(pehuenia, cuerpo_agua(alumine,  si, 19)).

% Agregamos algunas atracciones para completar
atraccion(san_martin, parque_nacional(lanin)).
atraccion(san_martin, excursion(kayak)).

atraccion(bariloche, cerro(catedral, 2405)).
atraccion(bariloche, playa(3)).

atraccion(el_bolson, cuerpo_agua(rio_azul, si, 16)).
atraccion(el_bolson, excursion(patagonia)).

atraccion(mar_del_plata, playa(6)).

atraccion(camarones, playa(4)).

atraccion(playas_doradas, playa(2)).

atraccion(calafate, cuerpo_agua(lago_argentino, no, 5)).
atraccion(calafate, excursion(glaciar_perito_moreno)).


% Copado según reglas
copado(parque_nacional(_)).
copado(cerro(_, Alt)) :- Alt > 2000.
copado(cuerpo_agua(_, si, _)).
copado(cuerpo_agua(_, no, Temp)) :- Temp > 20.
copado(playa(Dif)) :- Dif < 5.
copado(excursion(Nombre)) :- atom_length(Nombre, L), L > 7.

hay_algo_copado(Destino) :- atraccion(Destino, Tipo), copado(Tipo).

vacaciones_copadas(Persona) :-
    persona(Persona),
    forall(va(Persona, Destino), hay_algo_copado(Destino)).


% ----- Punto 3: No se cruzaron -----

no_se_cruzaron(P1, P2) :-
    persona(P1), persona(P2), P1 \= P2,
    \+ (va(P1, D), va(P2, D)).


% ----- Punto 4: Vacaciones gasoleras -----

costo_vida(sarmiento,          100).
costo_vida(esquel,             150).
costo_vida(pehuenia,           180).
costo_vida(san_martin,         150).
costo_vida(camarones,          135).
costo_vida(playas_doradas,     170).
costo_vida(bariloche,          140).
costo_vida(calafate,           240).
costo_vida(el_bolson,          145).
costo_vida(mar_del_plata,      140).

gasolero(Destino) :- costo_vida(Destino, C), C < 160.

vacaciones_gasoleras(Persona) :-
    persona(Persona),
    forall(va(Persona, Destino), gasolero(Destino)).


% ----- Punto 5: Itinerarios posibles -----

itinerario(Persona, Itinerario) :-
    persona(Persona),
    findall(D, va(Persona, D), DestinosDup),
    sort(DestinosDup, Destinos), % evitamos duplicados
    permutacion(Destinos, Itinerario).

permutacion([], []).
permutacion(Lista, [X|R]) :- select(X, Lista, Resto), permutacion(Resto, R).
