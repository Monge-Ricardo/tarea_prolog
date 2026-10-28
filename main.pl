:- encoding(utf8).

% =============================================================================
% PUNTO DE ENTRADA PRINCIPAL (MAIN)
% =============================================================================
% Orquesta la interacción, evalúa las hipótesis con scoring y presenta
% el diagnóstico y la trazabilidad "How" al usuario.
% =============================================================================

:- consult('conocimiento_marketing.pl').
:- consult('motor_experto.pl').

main :-
    iniciar.

iniciar :-
    reiniciar_memoria,
    imprimir_banner,
    evaluar_todas_las_estrategias(Ranking),
    presentar_resultados(Ranking).

imprimir_banner :-
    writeln('================================================================='),
    writeln('       SISTEMA EXPERTO DE ESTRATEGIAS DE MARKETING DIGITAL       '),
    writeln('             (Con Scoring de Afinidad y Auditoría)               '),
    writeln('================================================================='),
    writeln('Instrucciones:'),
    writeln('  * Responde "si" o "no" a las preguntas formuladas.'),
    writeln('  * Puedes escribir "porque" o "?" en cualquier momento para saber'),
    writeln('    qué hipótesis está evaluando el motor y por qué te pregunta eso.'),
    writeln('-----------------------------------------------------------------'),
    nl.

% -----------------------------------------------------------------------------
% Presentación de resultados y trazabilidad "How"
% -----------------------------------------------------------------------------
presentar_resultados([]) :-
    nl,
    writeln('No se evaluaron estrategias en la base de conocimiento.'),
    nl.

presentar_resultados([Mejor | Otras]) :-
    Mejor = resultado(Score, _, _, _),
    Score > 0,
    !,
    imprimir_estrategia_ganadora(Mejor),
    imprimir_alternativas(Otras),
    imprimir_seccion_auditoria([Mejor | Otras]).

presentar_resultados(_) :-
    nl,
    writeln('================================================================='),
    writeln('                      RESULTADO                                  '),
    writeln('================================================================='),
    writeln('Todas las respuestas registradas fueron negativas (0% afinidad). '),
    writeln('No fue posible identificar ninguna estrategia compatible.        '),
    writeln('================================================================='),
    nl.

imprimir_estrategia_ganadora(resultado(Score, Estrategia, _, _)) :-
    nl,
    writeln('================================================================='),
    writeln('                   ESTRATEGIA RECOMENDADA                        '),
    writeln('================================================================='),
    (   descripcion_estrategia(Estrategia, Nombre, Accion)
    ->  format('Estrategia:  ~w~n', [Nombre]),
        format('Afinidad:    ~w% de coincidencia~n~n', [Score]),
        format('Plan de Acción Recomendado:~n  ~w~n', [Accion])
    ;   format('Estrategia: ~w (~w% de afinidad)~n', [Estrategia, Score])
    ),
    writeln('================================================================='),
    nl.

imprimir_alternativas(Otras) :-
    include(es_alternativa_viable, Otras, Viables),
    (   Viables \== []
    ->  writeln('-------------------- OTRAS OPCIONES VIABLES --------------------'),
        listar_otras_opciones(Viables),
        writeln('----------------------------------------------------------------'),
        nl
    ;   true
    ).

es_alternativa_viable(resultado(Score, _, _, _)) :-
    Score >= 50.

listar_otras_opciones([]).
listar_otras_opciones([resultado(Score, Estrategia, _, _) | Resto]) :-
    (   descripcion_estrategia(Estrategia, Nombre, _)
    ->  format('  * ~w (~w% de coincidencia)~n', [Nombre, Score])
    ;   format('  * ~w (~w% de coincidencia)~n', [Estrategia, Score])
    ),
    listar_otras_opciones(Resto).

imprimir_seccion_auditoria(ListaResultados) :-
    writeln('================================================================='),
    writeln('             AUDITORÍA Y TRAZABILIDAD DEDUCTIVA ("HOW")          '),
    writeln('================================================================='),
    writeln('A continuación se detalla la justificación deductiva de cada     '),
    writeln('estrategia calculada a partir de la memoria de trabajo:          '),
    nl,
    include(tiene_score_positivo, ListaResultados, Relevantes),
    (   Relevantes \== []
    ->  forall(member(R, Relevantes), explicar_how(R))
    ;   forall(member(R, ListaResultados), explicar_how(R))
    ),
    writeln('================================================================='),
    nl.

tiene_score_positivo(resultado(Score, _, _, _)) :- Score > 0.

:- initialization(main, main).
