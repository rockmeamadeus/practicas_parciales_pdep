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
%   - formacion([InstrumentosRequeridos]): grupo con instrumentos específicos
%   - ensamble(NivelMinimo): grupo flexible con nivel mínimo requerido

% ----- Base de conocimiento -----

% integrante(Grupo, Persona, Instrumento)
integrante(sophieTrio, sophie, violin).
integrante(sophieTrio, santi, guitarra).
integrante(vientosDelEste, lisa, saxo).
integrante(vientosDelEste, santi, voz).
integrante(vientosDelEste, santi, guitarra).
integrante(jazzmin, santi, bateria).

% nivelQueTiene(Persona, Instrumento, Nivel)
nivelQueTiene(sophie, violin, 5).
nivelQueTiene(santi, guitarra, 2).
nivelQueTiene(santi, voz, 3).
nivelQueTiene(santi, bateria, 4).
nivelQueTiene(lisa, saxo, 4).
nivelQueTiene(lore, violin, 4).
nivelQueTiene(luis, trompeta, 1).
nivelQueTiene(luis, contrabajo, 4).

% instrumento(Instrumento, Rol)
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

% grupo(Grupo, TipoGrupo) - Punto 3
grupo(vientosDelEste, bigBand).
grupo(sophieTrio, formacion([contrabajo, guitarra, violin])).
grupo(jazzmin, formacion([bateria, bajo, trompeta, piano, guitarra])).
grupo(estudio1, ensamble(3)).

% ----- Punto 1: buena base -----

% Un grupo tiene buena base si tiene alguien que toque rítmico y alguien más que toque armónico
buenaBase(Grupo) :-
    integrante(Grupo, PersonaRitmica, InstrumentoRitmico),
    instrumento(InstrumentoRitmico, ritmico),
    integrante(Grupo, PersonaArmonica, InstrumentoArmonico),
    instrumento(InstrumentoArmonico, armonico),
    PersonaRitmica \= PersonaArmonica.

% ----- Punto 2: se destaca en un grupo -----

% Una persona se destaca si su nivel es al menos 2 puntos mayor que todos los demás integrantes
seDestaca(Persona, Grupo) :-
    integrante(Grupo, Persona, InstrumentoPersona),
    nivelQueTiene(Persona, InstrumentoPersona, NivelPersona),
    forall((integrante(Grupo, OtraPersona, InstrumentoOtraPersona), 
            OtraPersona \= Persona,
            nivelQueTiene(OtraPersona, InstrumentoOtraPersona, NivelOtraPersona)),
           NivelPersona >= NivelOtraPersona + 2).

% ----- Punto 4: hay cupo para un instrumento -----

% Predicados auxiliares para determinar qué instrumentos sirven para cada tipo de grupo
sirveParaGrupo(formacion(InstrumentosRequeridos), Instrumento) :- 
    member(Instrumento, InstrumentosRequeridos).

sirveParaGrupo(bigBand, Instrumento) :-
    instrumento(Instrumento, melodico(viento)).
sirveParaGrupo(bigBand, bateria).
sirveParaGrupo(bigBand, bajo).
sirveParaGrupo(bigBand, piano).

sirveParaGrupo(ensamble(_), _). % cualquier instrumento sirve en ensambles

% Hay cupo si el instrumento sirve para el grupo y nadie lo toca ya
hayCupo(Grupo, Instrumento) :-
    grupo(Grupo, TipoGrupo),
    sirveParaGrupo(TipoGrupo, Instrumento),
    \+ integrante(Grupo, _, Instrumento).

% Caso especial: en big bands siempre hay cupo para melódicos de viento
hayCupo(Grupo, Instrumento) :-
    grupo(Grupo, bigBand),
    instrumento(Instrumento, melodico(viento)).

% ----- Punto 5: puede incorporarse -----

% Nivel mínimo esperado según el tipo de grupo
nivelMinimoEsperado(bigBand, 1).
nivelMinimoEsperado(formacion(InstrumentosRequeridos), NivelMinimo) :-
    length(InstrumentosRequeridos, CantidadInstrumentos),
    NivelMinimo is 7 - CantidadInstrumentos.
nivelMinimoEsperado(ensamble(NivelMinimo), NivelMinimo).

% Una persona puede incorporarse si no está en el grupo, hay cupo y tiene el nivel mínimo
puedeIncorporarse(Persona, Grupo, Instrumento) :-
    grupo(Grupo, TipoGrupo),
    \+ integrante(Grupo, Persona, _),
    hayCupo(Grupo, Instrumento),
    nivelQueTiene(Persona, Instrumento, NivelPersona),
    nivelMinimoEsperado(TipoGrupo, NivelMinimo),
    NivelPersona >= NivelMinimo.

% ----- Punto 6: se quedó en banda -----

% Una persona se quedó en banda si toca algún instrumento, no forma parte de ningún grupo
% y no puede incorporarse a ningún grupo existente
seQuedoEnBanda(Persona) :-
    nivelQueTiene(Persona, _, _),
    \+ integrante(Grupo, Persona, _),
    \+ (grupo(Grupo, _), puedeIncorporarse(Persona, Grupo, _)).

% ----- Punto 7: puede tocar -----

% Predicado auxiliar para contar personas únicas que tocan instrumentos melódicos de viento
tocaMelodicoViento(Grupo, Persona) :-
    integrante(Grupo, Persona, Instrumento),
    instrumento(Instrumento, melodico(viento)).

tieneMinimoPeersonasMelodicoViento(Grupo, MinimoRequerido) :-
    findall(Persona, tocaMelodicoViento(Grupo, Persona), PersonasConDuplicados),
    sort(PersonasConDuplicados, PersonasUnicas),
    length(PersonasUnicas, CantidadPersonas),
    CantidadPersonas >= MinimoRequerido.

% Big band puede tocar si tiene buena base y al menos 5 personas que toquen melódicos de viento
puedeTocar(Grupo) :-
    grupo(Grupo, bigBand),
    buenaBase(Grupo),
    tieneMinimoPeersonasMelodicoViento(Grupo, 5).

% Formación puede tocar si tiene todos los instrumentos requeridos
puedeTocar(Grupo) :-
    grupo(Grupo, formacion(InstrumentosRequeridos)),
    forall(member(Instrumento, InstrumentosRequeridos), 
           integrante(Grupo, _, Instrumento)).

% Ensamble puede tocar si tiene buena base y al menos una persona melódica
puedeTocar(Grupo) :-
    grupo(Grupo, ensamble(_)),
    buenaBase(Grupo),
    integrante(Grupo, _, Instrumento),
    instrumento(Instrumento, melodico(_)).