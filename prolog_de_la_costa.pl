% Prolog de la Costa

% ----- Punto 1: Base de conocimiento -----

% Puestos de comida y precios
comida(hamburguesa, 2000).
comida(panchito_con_papas, 1500).
comida(lomito_completo, 2500).
comida(caramelos, 0). % costo cero, pero su satisfacción tiene regla especial

% Atracciones tranquilas
% tranquila(Nombre, publico).
% publico: adultos_y_chicos | solo_chicos
tranquila(autitos_chocadores, adultos_y_chicos).
tranquila(casa_embrujada, adultos_y_chicos).
tranquila(laberinto, adultos_y_chicos).
tranquila(tobogan, solo_chicos).
tranquila(calesita, solo_chicos).

% Atracciones intensas con coeficiente de lanzamiento
% intensa(Nombre, Coef).
intensa(barco_pirata, 14).
intensa(tazas_chinas, 6).
intensa(simulador_3d, 2).

% Montañas rusas: giros invertidos y duración en segundos
% montana_rusa(Nombre, GirosInvertidos, DuracionSeg).
montana_rusa(abismo_mortal_recargada, 3, 134). % 2:14
montana_rusa(paseo_por_el_bosque, 0, 45).

% Atracciones acuáticas (habilitadas de septiembre a marzo inclusive)
acuatico(el_torpedo_salpicon).
acuatico(espero_que_hayas_traido_una_muda_de_ropa).

mes(septiembre). mes(octubre). mes(noviembre). mes(diciembre).
mes(enero). mes(febrero). mes(marzo). mes(abril). mes(mayo). mes(junio). mes(julio). mes(agosto).

mes_habilitado_acuatico(septiembre).
mes_habilitado_acuatico(octubre).
mes_habilitado_acuatico(noviembre).
mes_habilitado_acuatico(diciembre).
mes_habilitado_acuatico(enero).
mes_habilitado_acuatico(febrero).
mes_habilitado_acuatico(marzo).

% Visitantes: nombre, edad, dinero, hambre, aburrimiento, grupo familiar
visitante(eusebio, 80, 3000, 50, 0, viejitos).
visitante(carmela, 80,    0,  0, 25, viejitos).

% Dos personas que vinieron solas
visitante(sofi,    25, 1200, 20, 30, sofi).
visitante(tomi,    10,  800, 10, 10, tomi).

% Otros grupos (mencionados en el enunciado, sin detalle de integrantes)
% familiar(Persona, Grupo) lo inferimos desde visitante/6

familiar(Persona, Grupo) :- visitante(Persona, _, _, _, _, Grupo).

edad(Persona, Edad) :- visitante(Persona, Edad, _, _, _, _).
dinero(Persona, Dinero) :- visitante(Persona, _, Dinero, _, _, _).
hambre(Persona, Hambre) :- visitante(Persona, _, _, Hambre, _, _).
aburrimiento(Persona, Aburr) :- visitante(Persona, _, _, _, Aburr, _).

chico(Persona) :- edad(Persona, E), E < 13.
adulto(Persona) :- edad(Persona, E), E >= 13.

grupo_de(Persona, Grupo) :- familiar(Persona, Grupo).

viene_solo(Persona) :-
    grupo_de(Persona, Grupo),
    \+ (grupo_de(Otra, Grupo), Otra \= Persona).


% ----- Punto 2: Estado de bienestar -----

suma_malestar(Persona, Total) :-
    hambre(Persona, H), aburrimiento(Persona, A),
    Total is H + A.

bienestar(Persona, felicidad_plena) :-
    \+ viene_solo(Persona),
    suma_malestar(Persona, 0).

bienestar(Persona, podria_estar_mejor) :-
    suma_malestar(Persona, Total),
    Total >= 0, Total =< 50.

bienestar(Persona, necesita_entretenerse) :-
    suma_malestar(Persona, Total),
    Total >= 51, Total =< 99.

bienestar(Persona, se_quiere_ir_a_casa) :-
    suma_malestar(Persona, Total),
    Total >= 100.


% ----- Punto 3: Satisfacer el hambre de un grupo con una comida -----

precio_comida(Comida, Precio) :- comida(Comida, Precio).

puede_pagar(Persona, Comida) :-
    precio_comida(Comida, Precio),
    dinero(Persona, Dinero),
    Dinero >= Precio.

% Regla de satisfacción por comida
satisface(hamburguesa, Persona) :- hambre(Persona, H), H < 50.
satisface(panchito_con_papas, Persona) :- chico(Persona).
satisface(lomito_completo, _).
satisface(caramelos, Persona) :-
    % Sólo satisface si no puede pagar ninguna otra comida del dominio
    \+ (comida(Com, _), Com \= caramelos, puede_pagar(Persona, Com)).

% Todos los integrantes del grupo pueden pagar y la comida los satisface
grupo_puede_satisfacer_hambre(Grupo, Comida) :-
    % Asegura que el grupo tenga al menos un integrante y que todos cumplan
    grupo_de(_, Grupo),
    forall(grupo_de(Persona, Grupo), (puede_pagar(Persona, Comida), satisface(Comida, Persona))).


% ----- Punto 4: Lluvia de hamburguesas -----

% Atracción es intensa con coef > 10
atraccion_lluvia_intensa(Atraccion) :- intensa(Atraccion, Coef), Coef > 10.

% Peligrosidad de montañas rusas
% Máximo de giros usando universalidad: Max es un valor de giros tal que
% todas las montañas tienen giros <= Max. Se hace determinista con once/1.
max_giros(Max) :-
    once(( montana_rusa(_, Max, _),
           forall(montana_rusa(_, G, _), G =< Max) )).

peligrosa_para(Persona, Montania) :-
    adulto(Persona),
    bienestar(Persona, Estado), Estado \= necesita_entretenerse,
    max_giros(Max),
    montana_rusa(Montania, G, _), G =:= Max.

peligrosa_para(Persona, Montania) :-
    chico(Persona),
    montana_rusa(Montania, _, Dur), Dur > 60.

puede_pagar_hamburguesa(Persona) :- puede_pagar(Persona, hamburguesa).

lluvia_de_hamburguesas(Persona, Atraccion) :-
    puede_pagar_hamburguesa(Persona),
    atraccion_lluvia_intensa(Atraccion).

lluvia_de_hamburguesas(Persona, Atraccion) :-
    puede_pagar_hamburguesa(Persona),
    montana_rusa(Atraccion, _, _),
    peligrosa_para(Persona, Atraccion).

lluvia_de_hamburguesas(Persona, tobogan) :-
    puede_pagar_hamburguesa(Persona).


% ----- Punto 5: Opciones de entretenimiento por mes -----

abierta_en_mes(Atr, Mes) :- acuatico(Atr), mes_habilitado_acuatico(Mes).
abierta_en_mes(Atr, Mes) :- \+ acuatico(Atr), mes(Mes).

opcion_comida(Persona, comida(Comida)) :-
    comida(Comida, Precio),
    dinero(Persona, D), D >= Precio.

opcion_tranquila(Persona, tranquila(Atr)) :-
    tranquila(Atr, adultos_y_chicos).

opcion_tranquila(Persona, tranquila(Atr)) :-
    tranquila(Atr, solo_chicos), chico(Persona).

opcion_tranquila(Persona, tranquila(Atr)) :-
    tranquila(Atr, solo_chicos), adulto(Persona),
    grupo_de(Persona, Grupo),
    (grupo_de(Otro, Grupo), chico(Otro)).

opcion_intensa(intensa(Atr)) :- intensa(Atr, _).

opcion_montana(Persona, montana(Atr)) :-
    montana_rusa(Atr, _, _),
    \+ peligrosa_para(Persona, Atr).

opcion_acuatica(acuatico(Atr)) :- acuatico(Atr).

% Opciones de entretenimiento (evitamos arg/3 usando patrones explícitos)
opcion_entretenimiento(Persona, Mes, comida(Comida)) :-
    mes(Mes),
    opcion_comida(Persona, comida(Comida)).

opcion_entretenimiento(Persona, Mes, tranquila(Atr)) :-
    mes(Mes),
    opcion_tranquila(Persona, tranquila(Atr)),
    abierta_en_mes(Atr, Mes).

opcion_entretenimiento(_Persona, Mes, intensa(Atr)) :-
    mes(Mes),
    opcion_intensa(intensa(Atr)),
    abierta_en_mes(Atr, Mes).

opcion_entretenimiento(Persona, Mes, montana(Atr)) :-
    mes(Mes),
    opcion_montana(Persona, montana(Atr)),
    abierta_en_mes(Atr, Mes).

opcion_entretenimiento(_Persona, Mes, acuatico(Atr)) :-
    mes(Mes),
    opcion_acuatica(acuatico(Atr)),
    abierta_en_mes(Atr, Mes).
