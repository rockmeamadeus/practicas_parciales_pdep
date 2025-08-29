% Improlog (parcial MiT 2023)

% ----- Base de conocimiento de ejemplo -----

% integrante(Grupo, Persona, Instrumento)
integrante(sophieTrio, sophie, violin).
integrante(sophieTrio, santi, guitarra).
integrante(vientosDelEste, lisa, saxo).
integrante(vientosDelEste, santi, voz).
integrante(vientosDelEste, santi, guitarra).
integrante(jazzmin, santi, bateria).

% nivelQueTiene(Persona, Instrumento, Nivel 1..5)
nivelQueTiene(sophie, violin, 5).
nivelQueTiene(santi, guitarra, 2).
nivelQueTiene(santi, voz, 3).
nivelQueTiene(santi, bateria, 4).
nivelQueTiene(lisa, saxo, 4).
nivelQueTiene(lore, violin, 4).
nivelQueTiene(luis, trompeta, 1).
nivelQueTiene(luis, contrabajo, 4).

% instrumento(Nombre, Rol)
% Rol: ritmico | armonico | melodico(Tipo)
instrumento(violin, melodico(cuerdas)).
instrumento(guitarra, armonico).
instrumento(bateria, ritmico).
instrumento(saxo, melodico(viento)).
instrumento(trompeta, melodico(viento)).
instrumento(contrabajo, armonico).
instrumento(bajo, armonico).
instrumento(piano, armonico).
instrumento(pandereta, ritmico).
instrumento(voz, melodico(vocal)).

% ----- Punto 3: grupos y tipos -----

% grupo(Grupo, Tipo)
% Tipo: bigBand ; formacion([Insts]) ; ensamble(NivelMin)
grupo(vientosDelEste, bigBand).
grupo(sophieTrio, formacion([contrabajo, guitarra, violin])).
grupo(jazzmin, formacion([bateria, bajo, trompeta, piano, guitarra])).


% ----- Punto 1: buena base -----

toca_con_rol(Grupo, Persona, Rol) :-
    integrante(Grupo, Persona, Inst),
    instrumento(Inst, Rol).

buena_base(Grupo) :-
    toca_con_rol(Grupo, P1, ritmico),
    toca_con_rol(Grupo, P2, armonico),
    P1 \= P2.


% ----- Punto 2: se destaca en un grupo -----

nivel_en_grupo(Persona, Grupo, Nivel) :-
    integrante(Grupo, Persona, Inst),
    nivelQueTiene(Persona, Inst, Nivel).

se_destaca(Persona, Grupo) :-
    nivel_en_grupo(Persona, Grupo, NivelPropio),
    forall((integrante(Grupo, Otro, InstOtro), Otro \= Persona,
            nivelQueTiene(Otro, InstOtro, NivelOtro)),
           NivelPropio >= NivelOtro + 2).


% ----- Punto 4: hay cupo para un instrumento -----

hay_cupo(Grupo, Instrumento) :-
    grupo(Grupo, Tipo),
    sirve_para(Tipo, Instrumento),
    \+ integrante(Grupo, _, Instrumento).

% Caso especial big band: siempre hay cupo para melódicos de viento
hay_cupo(Grupo, Instrumento) :-
    grupo(Grupo, bigBand),
    instrumento(Instrumento, melodico(viento)).

sirve_para(formacion(Insts), Instrumento) :- member(Instrumento, Insts).
sirve_para(bigBand, Instrumento) :-
    instrumento(Instrumento, melodico(viento)).
sirve_para(bigBand, bateria).
sirve_para(bigBand, bajo).
sirve_para(bigBand, piano).
sirve_para(ensamble(_), _). % cualquier instrumento sirve en ensambles


% ----- Punto 5: puede incorporarse -----

minimo_esperado(bigBand, 1).
minimo_esperado(formacion(Insts), Min) :- length(Insts, N), Min is 7 - N.
minimo_esperado(ensamble(N), N).

puede_incorporarse(Persona, Grupo, Instrumento) :-
    grupo(Grupo, Tipo),
    \+ integrante(Grupo, Persona, _),
    hay_cupo(Grupo, Instrumento),
    nivelQueTiene(Persona, Instrumento, Nivel),
    minimo_esperado(Tipo, Min),
    Nivel >= Min.


% ----- Punto 6: se quedó en banda -----

forma_parte(Persona, Grupo) :- integrante(Grupo, Persona, _).

se_quedo_en_banda(Persona) :-
    \+ forma_parte(Persona, _),
    \+ (grupo(G, _), puede_incorporarse(Persona, G, _)).


% ----- Punto 7: puede tocar -----

% BigBand puede tocar si tiene buena base y al menos 5 personas distintas
% que toquen instrumentos melódicos de viento (sin setof: findall + sort)
puede_tocar(Grupo) :-
    grupo(Grupo, bigBand),
    buena_base(Grupo),
    findall(Persona, (integrante(Grupo, Persona, Inst), instrumento(Inst, melodico(viento))), PersonasDup),
    sort(PersonasDup, Personas),
    length(Personas, Cant), Cant >= 5.

puede_tocar(Grupo) :-
    grupo(Grupo, formacion(Insts)),
    forall(member(Inst, Insts), integrante(Grupo, _, Inst)).

% Ensambles se agregan en el punto 8, ver regla más abajo


% ----- Punto 8: ensambles -----

% Agregar grupo de ejemplo
grupo(estudio1, ensamble(3)).

puede_tocar(Grupo) :-
    grupo(Grupo, ensamble(_)),
    buena_base(Grupo),
    % al menos alguna persona melódica (cualquier tipo)
    (integrante(Grupo, _, Inst), instrumento(Inst, melodico(_))).
