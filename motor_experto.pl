:- encoding(utf8).

% =============================================================================
% MOTOR EXPERTO GENÉRICO INTERACTIVO CON SCORING Y EXPLICACIÓN (WHY / HOW)
% =============================================================================
% Características principales:
% 1. Razonamiento con incertidumbre mediante scoring porcentual de afinidad.
% 2. Justificación "Why": Explica por qué se realiza una pregunta al escribir 'porque'.
% 3. Trazabilidad "How": Registra evidencias afirmativas y negativas para auditar deducciones.
% 4. Memoria de trabajo dinámica (conocido/2) para evitar preguntas repetidas.
% =============================================================================

:- dynamic conocido/2.

% -----------------------------------------------------------------------------
% evaluar_todas_las_estrategias(-Ranking)
% Evalúa todas las reglas disponibles y retorna una lista ordenada por afinidad
% descendente: [resultado(Score, Estrategia, Cumplidas, NoCumplidas) | ...]
% -----------------------------------------------------------------------------
evaluar_todas_las_estrategias(RankingOrdenado) :-
    findall(
        resultado(Score, Estrategia, Cumplidas, NoCumplidas),
        evaluar_estrategia(Estrategia, Score, Cumplidas, NoCumplidas),
        Resultados
    ),
    sort(1, @>=, Resultados, RankingOrdenado).

% -----------------------------------------------------------------------------
% evaluar_estrategia(+Estrategia, -Score, -Cumplidas, -NoCumplidas)
% Recorre las condiciones de la estrategia acumulando las que se confirman
% y las que se rechazan, calculando el porcentaje de coincidencia.
% -----------------------------------------------------------------------------
evaluar_estrategia(Estrategia, Score, Cumplidas, NoCumplidas) :-
    regla(Estrategia, Condiciones),
    evaluar_lista_condiciones(Condiciones, Estrategia, Cumplidas, NoCumplidas),
    length(Condiciones, Total),
    length(Cumplidas, Positivas),
    (   Total > 0
    ->  Score is round((Positivas / Total) * 100)
    ;   Score = 0
    ).

% -----------------------------------------------------------------------------
% evaluar_lista_condiciones(+Condiciones, +HipotesisActual, -Cumplidas, -NoCumplidas)
% -----------------------------------------------------------------------------
evaluar_lista_condiciones([], _, [], []).
evaluar_lista_condiciones([Condicion | Resto], Hipotesis, [Condicion | CumplidasResto], NoCumplidasResto) :-
    verificar_condicion(Condicion, Hipotesis, si),
    !,
    evaluar_lista_condiciones(Resto, Hipotesis, CumplidasResto, NoCumplidasResto).
evaluar_lista_condiciones([Condicion | Resto], Hipotesis, CumplidasResto, [Condicion | NoCumplidasResto]) :-
    evaluar_lista_condiciones(Resto, Hipotesis, CumplidasResto, NoCumplidasResto).

% -----------------------------------------------------------------------------
% verificar_condicion(+Condicion, +HipotesisActual, -EstadoRespuesta)
% Consulta la memoria dinámica o interroga al usuario con soporte "Why".
% -----------------------------------------------------------------------------
verificar_condicion(Condicion, _, si) :-
    conocido(Condicion, si),
    !.
verificar_condicion(Condicion, _, no) :-
    conocido(Condicion, no),
    !,
    fail.
verificar_condicion(Condicion, Hipotesis, RespuestaFinal) :-
    obtener_texto_pregunta(Condicion, TextoPregunta),
    solicitar_respuesta(TextoPregunta, Hipotesis, Condicion, RespuestaFinal),
    assertz(conocido(Condicion, RespuestaFinal)),
    RespuestaFinal == si.

% -----------------------------------------------------------------------------
% solicitar_respuesta(+TextoPregunta, +Hipotesis, +Condicion, -Respuesta)
% Lee la respuesta. Si el usuario ingresa 'porque' o 'why', explica la razón
% de la pregunta e insiste por la respuesta 'si' o 'no'.
% -----------------------------------------------------------------------------
solicitar_respuesta(TextoPregunta, Hipotesis, Condicion, Respuesta) :-
    format('~w [si/no/porque]: ', [TextoPregunta]),
    flush_output,
    read_line_to_string(user_input, RawInput),
    normalizar_entrada(RawInput, Entrada),
    procesar_entrada(Entrada, TextoPregunta, Hipotesis, Condicion, Respuesta).

procesar_entrada(si, _, _, _, si) :- !.
procesar_entrada(no, _, _, _, no) :- !.
procesar_entrada(porque, TextoPregunta, Hipotesis, Condicion, Respuesta) :-
    !,
    explicar_why(Hipotesis, Condicion),
    solicitar_respuesta(TextoPregunta, Hipotesis, Condicion, Respuesta).
procesar_entrada(_, TextoPregunta, Hipotesis, Condicion, Respuesta) :-
    writeln('>> Opción no reconocida. Ingresa "si", "no" o "porque" (seguido de Enter).'),
    solicitar_respuesta(TextoPregunta, Hipotesis, Condicion, Respuesta).

% -----------------------------------------------------------------------------
% MECANISMO DE EXPLICACIÓN "WHY" (¿Por qué me preguntas esto?)
% -----------------------------------------------------------------------------
explicar_why(Hipotesis, Condicion) :-
    nl,
    writeln('-------------------- [JUSTIFICACIÓN "WHY"] --------------------'),
    (   descripcion_estrategia(Hipotesis, NombreHipotesis, _)
    ->  format('Estoy evaluando la viabilidad de la estrategia:~n   "~w"~n', [NombreHipotesis])
    ;   format('Estoy evaluando la viabilidad de la hipótesis: "~w"~n', [Hipotesis])
    ),
    format('Para poder determinar su idoneidad, necesito verificar si aplica el criterio:~n   "~w".~n', [Condicion]),
    writeln('---------------------------------------------------------------'),
    nl.

% -----------------------------------------------------------------------------
% MECANISMO DE EXPLICACIÓN "HOW" (¿Cómo se llegó a esta conclusión?)
% -----------------------------------------------------------------------------
explicar_how(resultado(Score, Estrategia, Cumplidas, NoCumplidas)) :-
    (   descripcion_estrategia(Estrategia, NombreEstrategia, _)
    ->  format('TRAZABILIDAD "HOW" para [~w] (~w% de afinidad):~n', [NombreEstrategia, Score])
    ;   format('TRAZABILIDAD "HOW" para [~w] (~w% de afinidad):~n', [Estrategia, Score])
    ),
    writeln('  [+] Evidencias afirmativas confirmadas en memoria:'),
    imprimir_lista_how(Cumplidas, '     ✓ '),
    (   NoCumplidas \== []
    ->  writeln('  [-] Evidencias no satisfechas o ausentes:'),
        imprimir_lista_how(NoCumplidas, '     ✗ ')
    ;   writeln('  [!] Se cumplió el 100% de los criterios ideales.')
    ),
    nl.

imprimir_lista_how([], _) :- !.
imprimir_lista_how([C | Resto], Prefijo) :-
    (   pregunta(C, Texto)
    ->  format('~w~w (~w)~n', [Prefijo, Texto, C])
    ;   format('~w~w~n', [Prefijo, C])
    ),
    imprimir_lista_how(Resto, Prefijo).

% -----------------------------------------------------------------------------
% Auxiliares de texto y memoria
% -----------------------------------------------------------------------------
obtener_texto_pregunta(Condicion, Texto) :-
    pregunta(Condicion, Texto),
    !.
obtener_texto_pregunta(Condicion, Texto) :-
    format(atom(Texto), '¿Aplica el criterio "~w"?', [Condicion]).

normalizar_entrada(Input, si) :-
    normalize_space(atom(Str), Input),
    downcase_atom(Str, Lower),
    member(Lower, ['si', 's', 'yes', 'y', 'sí']),
    !.
normalizar_entrada(Input, no) :-
    normalize_space(atom(Str), Input),
    downcase_atom(Str, Lower),
    member(Lower, ['no', 'n']),
    !.
normalizar_entrada(Input, porque) :-
    normalize_space(atom(Str), Input),
    downcase_atom(Str, Lower),
    member(Lower, ['porque', 'por que', 'porqué', 'por qué', 'why', 'w', '?']),
    !.
normalizar_entrada(_, invalido).

reiniciar_memoria :-
    retractall(conocido(_, _)).
