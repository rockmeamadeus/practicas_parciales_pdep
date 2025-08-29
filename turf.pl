% Base de conocimientos y consultas para el parcial "Turf!"

% ----- Punto 1: Hechos y preferencias -----

% Personas (jockeys): nombre, altura en cm, peso en kg
jockey(valdivieso, 155, 52).
jockey(leguisamo, 161, 49).
jockey(lezcano,   149, 50).
jockey(baratucci, 153, 55).
jockey(falero,    157, 52).

% Caballos del dominio
caballo(botafogo).
caballo(old_man).
caballo(energica).
caballo(mat_boy).
caballo(yatasto).

% Afiliación a stud/caballeriza
stud(valdivieso, el_tute).
stud(falero,     el_tute).
stud(lezcano,    las_hormigas).
stud(baratucci,  el_charabon).
stud(leguisamo,  el_charabon).

% Ganadores de premios
gano(botafogo, gran_premio_nacional).
gano(botafogo, gran_premio_republica).
gano(old_man,  gran_premio_republica).
gano(old_man,  campeonato_palermo_de_oro).
% energica y yatasto no ganaron ninguno segun enunciado
gano(mat_boy,  gran_premio_criadores).

% Preferencias de cada caballo por jockey
% Botafogo: le gusta que el jockey pese menos de 52 kg
prefiere(botafogo, Jugador) :-
    jockey(Jugador, _, Peso),
    Peso < 52.
% ...o que sea Baratucci
prefiere(botafogo, baratucci).

% Old Man: le gustan personas con nombre de más de 7 letras
prefiere(old_man, Jugador) :-
    jockey(Jugador, _, _),
    atom_length(Jugador, Longitud),
    Longitud > 7.

% Enérgica: le gustan todes les jockeys que NO le gustan a Botafogo
prefiere(energica, Jugador) :-
    jockey(Jugador, _, _),
    \+ prefiere(botafogo, Jugador).

% Mat Boy: le gustan jockeys que midan más de 170 cms
prefiere(mat_boy, Jugador) :-
    jockey(Jugador, Altura, _),
    Altura > 170.

% Yatasto: no le gusta ningún jockey (no definimos casos positivos)


% ----- Punto 2: Caballos que prefieren a más de un jockey (inversible) -----

prefiere_mas_de_un_jockey(Caballo) :-
    caballo(Caballo),
    prefiere(Caballo, Jugador1),
    prefiere(Caballo, Jugador2),
    Jugador1 \= Jugador2.


% ----- Punto 3: Caballos que no prefieren a ningun jockey de un stud (inversible) -----

% Dominio de caballerizas conocidas
caballeriza(Stud) :- stud(_, Stud).

aborrece(Caballo, Stud) :-
    caballo(Caballo),
    caballeriza(Stud),
    \+ (stud(Jugador, Stud), prefiere(Caballo, Jugador)).


% ----- Punto 4: Jockeys "piolines" (inversible) -----

premio_importante(gran_premio_nacional).
premio_importante(gran_premio_republica).

piolin(Jugador) :-
    jockey(Jugador, _, _),
    forall((gano(Caballo, Premio), premio_importante(Premio)), prefiere(Caballo, Jugador)).


% ----- Punto 5: Apuestas y resultados -----

% Representación de apuestas:
%   ganador(Caballo)
%   segundo(Caballo)
%   exacta(Primero, Segundo)
%   imperfecta(Caballo1, Caballo2)
% El resultado de la carrera es una lista [Primero, Segundo | _]

gana_apuesta(ganador(Caballo), [Caballo | _]).
gana_apuesta(segundo(Caballo), [_, Caballo | _]).
gana_apuesta(exacta(Caballo1, Caballo2), [Caballo1, Caballo2 | _]).
gana_apuesta(imperfecta(Caballo1, Caballo2), [Caballo1, Caballo2 | _]).
gana_apuesta(imperfecta(Caballo1, Caballo2), [Caballo2, Caballo1 | _]).


% ----- Punto 6: Colores de pelaje y opciones de compra -----

% Pelaje y su descomposición en colores base
pelaje(botafogo, tordo).
pelaje(old_man,  alazan).
pelaje(energica, ratonero).
pelaje(mat_boy,  palomino).
pelaje(yatasto,  pinto).

compone_color(tordo,    negro).
compone_color(alazan,   marron).
compone_color(ratonero, gris).
compone_color(ratonero, negro).
compone_color(palomino, marron).
compone_color(palomino, blanco).
compone_color(pinto,    blanco).
compone_color(pinto,    marron).

tiene_color(Caballo, Color) :-
    pelaje(Caballo, Pelaje),
    compone_color(Pelaje, Color).

% Posibles compras: todas las listas no vacías de caballos que tengan el color indicado
puede_comprar(Color, Caballos) :-
    findall(Caballo, (caballo(Caballo), tiene_color(Caballo, Color)), Todos),
    Todos \= [],
    subset_de(Todos, Caballos),
    Caballos \= [].

% Generador de subconjuntos (lista) del segundo argumento, sin repetir
subset_de([], []).
subset_de([X|Xs], [X|Ys]) :- subset_de(Xs, Ys).
subset_de([_|Xs], Ys)      :- subset_de(Xs, Ys).
