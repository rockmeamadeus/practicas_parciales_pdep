% Tests para el parcial Improlog

:- include('improlog.pl').

% ----- Tests Punto 1: buena base -----

test_buena_base :-
    % sophieTrio tiene buena base (santi guitarra=armonico, no hay ritmico... debería fallar)
    \+ buenaBase(sophieTrio),
    
    % vientosDelEste no tiene buena base (no tiene ritmico)
    \+ buenaBase(vientosDelEste),
    
    % jazzmin tiene buena base (santi bateria=ritmico, pero necesita alguien armonico)
    \+ buenaBase(jazzmin),
    
    write('Test buena base: PASSED'), nl.

% ----- Tests Punto 2: se destaca -----

test_se_destaca :-
    % sophie se destaca en sophieTrio (nivel 5 vs santi guitarra nivel 2)
    seDestaca(sophie, sophieTrio),
    
    % santi no se destaca en vientosDelEste (nivel 3 voz, 2 guitarra vs lisa saxo nivel 4)
    \+ seDestaca(santi, vientosDelEste),
    
    % nadie se destaca en vientosDelEste según el enunciado
    \+ seDestaca(lisa, vientosDelEste),
    
    write('Test se destaca: PASSED'), nl.

% ----- Tests Punto 3: grupos -----

test_grupos :-
    % Verificar que los grupos están definidos correctamente
    grupo(vientosDelEste, bigBand),
    grupo(sophieTrio, formacion([contrabajo, guitarra, violin])),
    grupo(jazzmin, formacion([bateria, bajo, trompeta, piano, guitarra])),
    grupo(estudio1, ensamble(3)),
    
    write('Test grupos: PASSED'), nl.

% ----- Tests Punto 4: hay cupo -----

test_hay_cupo :-
    % En vientosDelEste (bigBand) siempre hay cupo para melódicos de viento
    hayCupo(vientosDelEste, trompeta),
    
    % En sophieTrio no hay cupo para violin (ya lo toca sophie)
    \+ hayCupo(sophieTrio, violin),
    
    % En sophieTrio hay cupo para contrabajo (está en la formación pero nadie lo toca)
    hayCupo(sophieTrio, contrabajo),
    
    % En estudio1 (ensamble) hay cupo para cualquier instrumento que nadie toque
    hayCupo(estudio1, piano),
    
    write('Test hay cupo: PASSED'), nl.

% ----- Tests Punto 5: puede incorporarse -----

test_puede_incorporarse :-
    % luis puede incorporarse a sophieTrio con contrabajo (nivel 4 >= 4 requerido)
    puedeIncorporarse(luis, sophieTrio, contrabajo),
    
    % luis no puede incorporarse a sophieTrio con trompeta (no está en la formación)
    \+ puedeIncorporarse(luis, sophieTrio, trompeta),
    
    % luis puede incorporarse a vientosDelEste con trompeta (bigBand, nivel 1 >= 1 requerido)
    puedeIncorporarse(luis, vientosDelEste, trompeta),
    
    % lore puede incorporarse a estudio1 con violin (ensamble nivel 3, lore tiene nivel 4)
    puedeIncorporarse(lore, estudio1, violin),
    
    write('Test puede incorporarse: PASSED'), nl.

% ----- Tests Punto 6: se quedó en banda -----

test_se_quedo_en_banda :-
    % lore se quedó en banda (no está en ningún grupo)
    seQuedoEnBanda(lore),
    
    % luis se quedó en banda (no está en ningún grupo)
    seQuedoEnBanda(luis),
    
    % sophie no se quedó en banda (está en sophieTrio)
    \+ seQuedoEnBanda(sophie),
    
    write('Test se quedo en banda: PASSED'), nl.

% ----- Tests Punto 7: puede tocar -----

test_puede_tocar :-
    % sophieTrio no puede tocar (le falta contrabajo)
    \+ puedeTocar(sophieTrio),
    
    % vientosDelEste no puede tocar (no tiene suficientes melódicos de viento)
    \+ puedeTocar(vientosDelEste),
    
    % jazzmin no puede tocar (le faltan instrumentos)
    \+ puedeTocar(jazzmin),
    
    write('Test puede tocar: PASSED'), nl.

% ----- Tests auxiliares -----

test_minimo_esperado :-
    minimo_esperado(bigBand, 1),
    minimo_esperado(formacion([a]), 6),
    minimo_esperado(formacion([a,b]), 5),
    minimo_esperado(formacion([a,b,c]), 4),
    minimo_esperado(ensamble(3), 3),
    
    write('Test minimo esperado: PASSED'), nl.

test_sirve_para :-
    sirve_para(bigBand, saxo),
    sirve_para(bigBand, bateria),
    sirve_para(formacion([violin, piano]), violin),
    \+ sirve_para(formacion([violin, piano]), guitarra),
    sirve_para(ensamble(2), cualquier_instrumento),
    
    write('Test sirve para: PASSED'), nl.

% ----- Ejecutar todos los tests -----

run_tests :-
    write('=== EJECUTANDO TESTS IMPROLOG ==='), nl,
    test_grupos,
    test_minimo_esperado,
    test_sirve_para,
    test_hay_cupo,
    test_puede_incorporarse,
    test_se_quedo_en_banda,
    test_buena_base,
    test_se_destaca,
    test_puede_tocar,
    write('=== TODOS LOS TESTS COMPLETADOS ==='), nl.