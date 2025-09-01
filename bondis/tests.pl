% Tests para bondis.pl
:- consult(bondis).

% Tests para pueden_combinarse/2
test_pueden_combinarse :-
    pueden_combinarse(17, 152),  % ambas pasan por santaFe en caba
    pueden_combinarse(152, 10),  % ambas pasan por santaFe en caba
    \+ pueden_combinarse(17, 24), % no comparten calles
    writeln('✓ pueden_combinarse tests passed').

% Tests para jurisdiccion/2
test_jurisdiccion :-
    jurisdiccion(17, nacional),  % pasa por caba y gba
    jurisdiccion(152, nacional), % pasa por caba y gba
    jurisdiccion(10, provincial(caba)),     % solo caba
    jurisdiccion(160, provincial(caba)),    % solo caba
    jurisdiccion(24, nacional),             % pasa por caba y gba
    jurisdiccion(247, provincial(buenosAires)), % solo gba
    jurisdiccion(60, provincial(buenosAires)),  % solo gba
    writeln('✓ jurisdiccion tests passed').

% Tests para mas_transitada_que/3
test_mas_transitada :-
    mas_transitada_que(caba, santaFe, corrientes), % santaFe: 3 líneas, corrientes: 1
    mas_transitada_que(caba, santaFe, medrano),    % santaFe: 3 líneas, medrano: 1
    \+ mas_transitada_que(caba, corrientes, santaFe), % corrientes: 1, santaFe: 3
    writeln('✓ mas_transitada_que tests passed').

% Tests para calle_mas_transitada/2
test_calle_mas_transitada :-
    calle_mas_transitada(caba, santaFe), % santaFe es la más transitada en caba
    \+ calle_mas_transitada(caba, corrientes), % corrientes no es la más transitada
    writeln('✓ calle_mas_transitada tests passed').

% Tests para transbordo/2
test_transbordo :-
    transbordo(caba, santaFe), % 3 líneas nacionales: 17, 152, 10
    \+ transbordo(caba, corrientes), % solo 1 línea
    \+ transbordo(caba, medrano),    % solo 1 línea
    writeln('✓ transbordo tests passed').

% Tests para costo_normal/2
test_costo_normal :-
    costo_normal(17, 500),   % nacional
    costo_normal(152, 500),  % nacional
    costo_normal(10, 350),   % provincial(caba)
    costo_normal(160, 350),  % provincial(caba)
    costo_normal(247, 25),   % provincial(buenosAires): 1 calle, 1 zona
    costo_normal(60, 25),    % provincial(buenosAires): 1 calle, 1 zona
    writeln('✓ costo_normal tests passed').

% Tests para costo_para/3
test_costo_para :-
    costo_para(juanita, 17, 50),    % estudiantil: $50
    costo_para(marta, 17, 250),     % jubilado: 500/2 = 250
    costo_para(pepito, 17, 500),    % sin beneficio aplicable para línea nacional
    costo_para(marta, 10, 0),       % casas_particulares(caba) + línea pasa por caba = gratis
    writeln('✓ costo_para tests passed').

% Ejecutar todos los tests
run_tests :-
    writeln('Ejecutando tests...'),
    test_pueden_combinarse,
    test_jurisdiccion,
    test_mas_transitada,
    test_calle_mas_transitada,
    test_transbordo,
    test_costo_normal,
    test_costo_para,
    writeln('✓ Todos los tests pasaron!').