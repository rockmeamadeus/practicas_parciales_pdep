% Improlog (parcial MiT 2023)

% ----- Modelado -----

% Persona: átomo que representa el nombre de una persona
% Grupo: átomo que representa el nombre de un grupo musical
% Instrumento: átomo que representa el nombre de un instrumento
% Nivel: número entero del 1 al 5 que representa el nivel de habilidad
% Rol: puede ser ritmico, armonico o melodico(Tipo)
%   donde Tipo puede ser: cuerdas, viento, vocal
% TipoGrupo: puede ser:
%   - bigBand: grupo de jazz grande
%   - formacion([Instrumentos]): grupo con instrumentos específicos
%   - ensamble(NivelMinimo): grupo flexible con nivel mínimo requerido

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

% ----- Punto 1: buena base -----

toca_con_rol(Grupo, Persona, Rol) :-
    integrante(Grupo, Persona, Instrumento),
    instrumento(Instrumento, Rol).

buenaBase(Grupo) :-
    toca_con_rol(Grupo, PersonaRitmica, ritmico),
    toca_con_rol(Grupo, PersonaArmonica, armonico),
    PersonaRitmica \= PersonaArmonica.

% ----- Punto 2: se destaca en un grupo -----

nivel_en_grupo(Persona, Grupo, Nivel) :-
    integrante(Grupo, Persona, Instrumento),
    nivelQueTiene(Persona, Instrumento, Nivel).

seDestaca(Persona, Grupo) :-
    nivel_en_grupo(Persona, Grupo, NivelPropio),
    forall((nivel_en_grupo(OtraPersona, Grupo, NivelOtraPersona), OtraPersona \= Persona),
           NivelPropio >= NivelOtraPersona + 2).

% ----- Punto 3: grupos y tipos -----

% grupo(Grupo, TipoGrupo)
% TipoGrupo: bigBand ; formacion([InstrumentosRequeridos]) ; ensamble(NivelMinimo)
grupo(vientosDelEste, bigBand).
grupo(sophieTrio, formacion([contrabajo, guitarra, violin])).
grupo(jazzmin, formacion([bateria, bajo, trompeta, piano, guitarra])).
grupo(estudio1, ensamble(3)).

% Predicados auxiliares
sirve_para(formacion(InstrumentosRequeridos), Instrumento) :- member(Instrumento, InstrumentosRequeridos).
sirve_para(bigBand, Instrumento) :-
    instrumento(Instrumento, melodico(viento)).
sirve_para(bigBand, bateria).
sirve_para(bigBand, bajo).
sirve_para(bigBand, piano).
sirve_para(ensamble(_), _). % cualquier instrumento sirve en ensambles

minimo_esperado(bigBand, 1).
minimo_esperado(formacion(InstrumentosRequeridos), NivelMinimo) :-
    length(InstrumentosRequeridos, CantidadInstrumentos),
    NivelMinimo is 7 - CantidadInstrumentos.
minimo_esperado(ensamble(NivelMinimo), NivelMinimo).

forma_parte(Persona, Grupo) :- integrante(Grupo, Persona, _).

toca_melodico_viento(Grupo, Persona) :-
    integrante(Grupo, Persona, Instrumento),
    instrumento(Instrumento, melodico(viento)).

tiene_minimo_melodicos_viento(Grupo, MinimoRequerido) :-
    findall(Persona, toca_melodico_viento(Grupo, Persona), PersonasConDuplicados),
    sort(PersonasConDuplicados, PersonasUnicas),
    length(PersonasUnicas, CantidadPersonas),
    CantidadPersonas >= MinimoRequerido.

% ----- Punto 4: hay cupo para un instrumento -----

hayCupo(Grupo, Instrumento) :-
    grupo(Grupo, Tipo),
    sirve_para(Tipo, Instrumento),
    \+ integrante(Grupo, _, Instrumento).

% Caso especial big band: siempre hay cupo para melódicos de viento
hayCupo(Grupo, Instrumento) :-
    grupo(Grupo, bigBand),
    instrumento(Instrumento, melodico(viento)).

% ----- Punto 5: puede incorporarse -----

puedeIncorporarse(Persona, Grupo, Instrumento) :-
    grupo(Grupo, TipoGrupo),
    \+ integrante(Grupo, Persona, _),
    hayCupo(Grupo, Instrumento),
    nivelQueTiene(Persona, Instrumento, NivelPersona),
    minimo_esperado(TipoGrupo, NivelMinimo),
    NivelPersona >= NivelMinimo.

% ----- Punto 6: se quedó en banda -----

seQuedoEnBanda(Persona) :-
    nivelQueTiene(Persona, _, _),
    \+ forma_parte(Persona, _),
    \+ (grupo(Grupo, _), puedeIncorporarse(Persona, Grupo, _)).

% ----- Punto 7: puede tocar -----

% BigBand puede tocar si tiene buena base y al menos 5 personas distintas
% que toquen instrumentos melódicos de viento
puedeTocar(Grupo) :-
    grupo(Grupo, bigBand),
    buenaBase(Grupo),
    tiene_minimo_melodicos_viento(Grupo, 5).

% Formacion puede tocar si tiene todos los instrumentos requeridos
puedeTocar(Grupo) :-
    grupo(Grupo, formacion(InstrumentosRequeridos)),
    forall(member(Instrumento, InstrumentosRequeridos), integrante(Grupo, _, Instrumento)).

% Ensamble puede tocar si tiene buena base y al menos una persona melódica
puedeTocar(Grupo) :-
    grupo(Grupo, ensamble(_)),
    buenaBase(Grupo),
    integrante(Grupo, _, Instrumento),
    instrumento(Instrumento, melodico(_)).