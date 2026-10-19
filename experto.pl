:- encoding(utf8).
:- dynamic conocido/2.

% ===== Base de conocimiento =====
% regla(Diagnóstico, Síntomas que deben cumplirse)
regla(fuente_de_poder,     [no_enciende, sin_luces]).
regla(memoria_ram,         [enciende, emite_pitidos]).
regla(disco_duro,          [enciende, muy_lento, ruido_en_disco]).
regla(sobrecalentamiento,  [enciende, se_apaga_solo]).

% Texto de cada pregunta
pregunta(no_enciende,    '¿El equipo NO enciende?').
pregunta(sin_luces,      '¿No hay luces ni ventiladores?').
pregunta(enciende,       '¿El equipo enciende?').
pregunta(emite_pitidos,  '¿Emite pitidos al arrancar?').
pregunta(muy_lento,      '¿Funciona muy lento?').
pregunta(ruido_en_disco, '¿Se oyen ruidos en el disco?').
pregunta(se_apaga_solo,  '¿Se apaga solo después de un rato?').

% ===== Motor de inferencia (encadenamiento hacia atrás) =====
diagnostico(D, Sintomas) :-
    regla(D, Sintomas),
    confirmar(Sintomas).

confirmar([]).
confirmar([S|Resto]) :- verificar(S), confirmar(Resto).

% ===== Memoria de trabajo: no repetir preguntas =====
verificar(S) :- conocido(S, si), !.
verificar(S) :- conocido(S, no), !, fail.
verificar(S) :-
    pregunta(S, Texto),
    format('~w (si/no): ', [Texto]),
    read(R),
    assertz(conocido(S, R)),
    R == si.

% ===== Interfaz y explicación =====
iniciar :-
    retractall(conocido(_, _)),
    writeln('=== Sistema experto: diagnóstico de PC ==='),
    (   diagnostico(D, Sintomas)
    ->  format('Diagnóstico: ~w~n', [D]),
        format('Porque se confirmaron: ~w~n', [Sintomas])
    ;   writeln('No se pudo determinar un diagnóstico.')
    ).
