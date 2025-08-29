
% Punto 1: 2 puntos
% Les jockeys son personas que monta el caballo en la carrera
% Tenemos a
% - Valdivieso, que mide 155 cms y pesa 52 kilos
% - Leguisamo, que mide 161 cms y pesa 49 kilos
% - Lezcano, que mide 149 cms y pesa 50 kilos
% - Baratucci, que mide 153 cms y pesa 55 kilos
% - Falero, que mide 157 cms y pesa 52 kilos
% 
% También tenemos a los caballos, 
% - Botafogo
% - Old Man
% - Enérgica
% - Mat Boy
% - Yatasto
% entre otros
% 
% Cada caballo tiene sus preferencias:
% - a Botafogo le gusta que le jockey pese menos de 52 kilos o que sea Baratucci
% - a Old Man le gusta que le jockey sea alguna persona de muchas letras (más de 7), existe el predicado atom_length/2
% - a Enérgica le gustan todes les jockeys que no le gusten a Botafogo
% - a Mat Boy le gusta les jockeys que midan mas de 170 cms
% - a Yatasto no le gusta ningún jockey
%
% Por otra parte, sabemos que
% Botafogo ganó el Gran Premio Nacional y el Gran Premio República
% Old Man ganó el Gran Premio República y el Campeonato Palermo de Oro
% Enérgica y Yatasto no ganaron ningún campeonato
% Mat Boy ganó el Gran Premio Criadores
%
% Modelar estos hechos en la base de conocimientos e indicar en caso de ser necesario si algún concepto interviene
% a la hora de hacer dicho diseño justificando su decisión.
%
jockey(valdivieso, 155, 52).
jockey(leguisamo, 161, 49).
jockey(lezcano, 149, 50).
jockey(baratucci, 153, 55).
jockey(falero, 157, 52).

% También sabemos el Stud o la caballeriza al que representa cada jockey
% Valdivieso y Falero son del stud El Tute
% Lezcano representa a Las Hormigas
% Y Baratucci y Leguisamo a El Charabón
representa(valdivieso, elTute).
representa(falero, elTute).
representa(lezcano, lasHormigas).
representa(baratucci, elCharabon).
representa(leguisamo, elCharabon).
%

caballo(botafogo).
caballo(old_man).
caballo(energica).
caballo(mat_boy).
caballo(yatasto).

prefiere(botafogo, Jockey):-jockey(Jockey, _, Peso), Peso < 52.
prefiere(botafogo, baratucci).
prefiere(old_man, Jockey):-jockey(Jockey, _, _), atom_length(Jockey, CantidadLetras), CantidadLetras > 7.
prefiere(energica, Jockey):-jockey(Jockey, _, _), not(prefiere(botafogo, Jockey)).
prefiere(mat_boy, Jockey):-jockey(Jockey, Altura, _), Altura > 170.
% por universo cerrado no tiene sentido escribir una cláusula para Yatasto dado que lo que no está en la base de conocimientos se presume falso

gano(botafogo, granPremioNacional).
gano(botafogo, granPremioRepublica).
gano(old_man, granPremioRepublica).
gano(old_man, campeonatoPalermoOro).
gano(mat_boy, granPremioCriadores).

% Punto 2: 2 puntos
% Para mí, para vos
% Queremos saber quiénes son los caballos que prefieren a más de un jockey.
% Ej: Botafogo, Old Man y Enérgica son ejemplos que cumplen esta condición según la base de conocimiento planteada.
masDeUnJockey(Caballo):-
  distinct(Caballo, (
    prefiere(Caballo, Jockey1),
    prefiere(Caballo, Jockey2),
    Jockey1 \= Jockey2
  )).

% Punto 3: 2 puntos
% No se llama Amor
% Queremos saber quiénes son los caballos que no prefieren a ningún jockey de una caballeriza. El predicado debe ser inversible.
% Ej: Botafogo aborrece a El Tute y Old Man aborrece a Las Hormigas, además de que Mat Boy aborrece a todos los studs.
aborrece(Caballo, Stud):-
  stud(Stud),
  caballo(Caballo),
  not((prefiere(Caballo, Jockey), representa(Jockey, Stud))).

stud(Stud):-
  distinct(Stud, representa(_, Stud)).

% Punto 4: 2 puntos
% Piolines
% Queremos saber quiénes son les jockeys "piolines", que son las personas preferidas por todos los caballos que ganaron
% un premio importante. El Gran Premio Nacional y el Gran Premio República son premios importantes.
%
% Por ejemplo, Leguisamo y Baratucci son piolines, no así Lezcano que es preferida por Botafogo pero no por Old Man.
premio_importante(granPremioNacional).
premio_importante(granPremioRepublica).

gano_premio_importante(Caballo):-gano(Caballo, Premio), premio_importante(Premio).

piolin(Jockey):-jockey(Jockey, _, _), forall(gano_premio_importante(Caballo), prefiere(Caballo, Jockey)).


% Punto 5: El jugador
% Apuestas (2 puntos)
% Queremos registrar las apuestas que hacen ciertas personas, una persona puede apostar 
% a ganador por un caballo => gana si el caballo resulta ganador
% a segundo por un caballo => gana si el caballo sale primero o segundo
% exacta => apuesta por dos caballos, y gana si el primer caballo sale primero y el segundo caballo sale segundo
% imperfecta => apuesta por dos caballos y gana si los caballos terminan primero y segundo sin importar el orden
% Queremos saber, dada una apuesta y el resultado de una carrera de caballos si la apuesta resultó ganadora.
% El predicado no debe ser inversible.
ganadora(ganador(Caballo), Resultado):-salioPrimero(Caballo, Resultado).
ganadora(segundo(Caballo), Resultado):-salioPrimero(Caballo, Resultado).
ganadora(segundo(Caballo), Resultado):-salioSegundo(Caballo, Resultado).
ganadora(exacta(Caballo1, Caballo2),Resultado):-salioPrimero(Caballo1, Resultado), salioSegundo(Caballo2, Resultado).
ganadora(imperfecta(Caballo1, Caballo2),Resultado):-salioPrimero(Caballo1, Resultado), salioSegundo(Caballo2, Resultado).
ganadora(imperfecta(Caballo1, Caballo2),Resultado):-salioPrimero(Caballo2, Resultado), salioSegundo(Caballo1, Resultado).

salioPrimero(Caballo, [Caballo|_]).
salioSegundo(Caballo, [_|[Caballo|_]]).

% Punto 6: Los colores
% Sabiendo que cada caballo tiene un color de crin:
% - Botafogo es tordo (negro)
% - Old Man es alazán (marrón)
% - Enérgica es ratonero (gris y negro) 
% - Mat Boy es palomino (marrón y blanco)
% - Yatasto es pinto (blanco y marrón)
% queremos saber qué caballos podría comprar una persona que tiene preferencia
% por caballos de un color específico. Tiene que poder comprar por lo menos un caballo para que
% la solución sea válida.
%
% Esperamos que no haya una única solución, sino que se pueda conocer todas las alternativas válidas posibles.
crin(botafogo, tordo).
crin(oldMan, alazan).
crin(energica, ratonero).
crin(matBoy, palomino).
crin(yatasto, pinto).

color(tordo, negro).
color(alazan, marron).
color(ratonero, gris).
color(ratonero, negro).
color(palomino, marron).
color(palomino, blanco).
color(pinto, blanco).
color(pinto, marron).

comprar(Color, Caballos):-
  findall(Caballo, (crin(Caballo, Crin), color(Crin, Color)), CaballosPosibles),
  combinar(CaballosPosibles, Caballos),
  Caballos \= [].

combinar([], []).
combinar([Caballo|CaballosPosibles], [Caballo|Caballos]):-combinar(CaballosPosibles, Caballos).
combinar([_|CaballosPosibles], Caballos):-combinar(CaballosPosibles, Caballos).

% DESCARTADO
% Punto 6 (2 puntos): Panorama
% Dada una lista de caballos y una apuesta, queremos saber cuáles son los resultados posibles que hagan
% que resulte ganadora esa apuesta. El predicado debe ser inversible para los resultados posibles y debe
% considerar como opciones válidas únicamente si todos los caballos terminan la carrera.
%
% Tip: existe el predicado permutation/2.
%
% Por ejemplo: si se apuesta a segundo por Enérgica y tenemos a Yatasto, Energica y Old Man, la apuesta
% es ganadora si salen alguna de estas variantes
% Yatasto primero, Enérgica segunda, Old Man tercero
% Enérgica primera, Yatasto segunda, Old Man tercero
% Enérgica primera, Old Man segunda, Yatasto tercero
% Old Man primero, Enérgica segunda, Yatasto tercero
% panorama(Caballos, Apuesta, Resultado):-
%   permutation(Caballos, Resultado),
%   ganadora(Apuesta, Resultado),
%   length(Resultado, CantidadCaballos),
%   length(Caballos, CantidadCaballos).

% quedan 12 puntos
