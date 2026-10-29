:- encoding(utf8).

% =============================================================================
% MOTOR EXPERTO GENÉRICO INTERACTIVO CON ATRIBUTO-VALOR, SCORING Y EXPLICACIÓN
% =============================================================================
% Características principales:
% 1. Razonamiento estructurado mediante modelo Atributo-Valor (categorías y booleanas).
% 2. Scoring de incertidumbre y afinidad porcentual por estrategia.
% 3. Justificación interactiva "Why": Explica por qué se solicita un atributo.
% 4. Trazabilidad "How": Desglosa los valores registrados vs valores aceptados.
% 5. Memoria de trabajo dinámica (conocido/2) para evitar preguntas repetidas.
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
    verificar_condicion(Condicion, Hipotesis),
    !,
    evaluar_lista_condiciones(Resto, Hipotesis, CumplidasResto, NoCumplidasResto).
evaluar_lista_condiciones([Condicion | Resto], Hipotesis, CumplidasResto, [Condicion | NoCumplidasResto]) :-
    evaluar_lista_condiciones(Resto, Hipotesis, CumplidasResto, NoCumplidasResto).

% -----------------------------------------------------------------------------
% verificar_condicion(+Condicion, +HipotesisActual)
% Evalúa si la condición condicion(Atributo, ValoresPermitidos) se satisface.
% Si el atributo no se conoce en memoria, se le pregunta al usuario.
% -----------------------------------------------------------------------------
verificar_condicion(condicion(Atributo, ValoresPermitidos), _) :-
    conocido(Atributo, ValorActual),
    !,
    member(ValorActual, ValoresPermitidos).

verificar_condicion(condicion(Atributo, ValoresPermitidos), Hipotesis) :-
    definicion_pregunta(Atributo, Tipo, TextoPregunta, Ayuda, Opciones),
    solicitar_respuesta(Atributo, Tipo, TextoPregunta, Ayuda, Opciones, Hipotesis, condicion(Atributo, ValoresPermitidos), ValorElegido),
    assertz(conocido(Atributo, ValorElegido)),
    member(ValorElegido, ValoresPermitidos).

% -----------------------------------------------------------------------------
% solicitar_respuesta(+Atributo, +Tipo, +Texto, +Ayuda, +Opciones, +Hipotesis, +Condicion, -ValorElegido)
% Formatea la pregunta y opciones según sea booleana o selección única.
% -----------------------------------------------------------------------------
solicitar_respuesta(Atributo, booleana, TextoPregunta, _, Opciones, Hipotesis, Condicion, ValorElegido) :-
    format('~w [si/no/porque]: ', [TextoPregunta]),
    flush_output,
    read_line_to_string(user_input, RawInput),
    procesar_lectura_booleana(RawInput, Atributo, TextoPregunta, Opciones, Hipotesis, Condicion, ValorElegido).

solicitar_respuesta(Atributo, seleccion_unica, TextoPregunta, _, Opciones, Hipotesis, Condicion, ValorElegido) :-
    nl,
    writeln(TextoPregunta),
    mostrar_opciones_numeradas(Opciones, 1),
    length(Opciones, TotalOpciones),
    format('Selecciona una opción [1-~w o "porque"]: ', [TotalOpciones]),
    flush_output,
    read_line_to_string(user_input, RawInput),
    procesar_lectura_seleccion(RawInput, Atributo, TextoPregunta, Opciones, Hipotesis, Condicion, ValorElegido).

mostrar_opciones_numeradas([], _) :- !.
mostrar_opciones_numeradas([opcion(_, Texto, _) | Resto], Indice) :-
    format('  [~w] ~w~n', [Indice, Texto]),
    Siguiente is Indice + 1,
    mostrar_opciones_numeradas(Resto, Siguiente).

% -----------------------------------------------------------------------------
% Procesamiento de entrada booleana
% -----------------------------------------------------------------------------
procesar_lectura_booleana(end_of_file, _, _, _, _, _, no) :- !.
procesar_lectura_booleana(Raw, Atributo, Texto, Opciones, Hipotesis, Condicion, Valor) :-
    limpiar_texto_entrada(Raw, Limpio),
    (   Limpio == ''
    ->  solicitar_respuesta(Atributo, booleana, Texto, '', Opciones, Hipotesis, Condicion, Valor)
    ;   es_consulta_why(Limpio)
    ->  explicar_why(Hipotesis, Condicion),
        solicitar_respuesta(Atributo, booleana, Texto, '', Opciones, Hipotesis, Condicion, Valor)
    ;   clasificar_en_opciones(Limpio, Opciones, Valor)
    ->  true
    ;   writeln('>> Opción no reconocida. Ingresa "si", "no" o "porque".'),
        solicitar_respuesta(Atributo, booleana, Texto, '', Opciones, Hipotesis, Condicion, Valor)
    ).

% -----------------------------------------------------------------------------
% Procesamiento de entrada de selección múltiple/única
% -----------------------------------------------------------------------------
procesar_lectura_seleccion(end_of_file, _, _, [opcion(PrimerId, _, _) | _], _, _, PrimerId) :- !.
procesar_lectura_seleccion(Raw, Atributo, Texto, Opciones, Hipotesis, Condicion, Valor) :-
    limpiar_texto_entrada(Raw, Limpio),
    (   Limpio == ''
    ->  solicitar_respuesta(Atributo, seleccion_unica, Texto, '', Opciones, Hipotesis, Condicion, Valor)
    ;   es_consulta_why(Limpio)
    ->  explicar_why(Hipotesis, Condicion),
        solicitar_respuesta(Atributo, seleccion_unica, Texto, '', Opciones, Hipotesis, Condicion, Valor)
    ;   buscar_por_indice_o_sinonimo(Limpio, Opciones, 1, Valor)
    ->  true
    ;   writeln('>> Opción no válida. Ingresa el número correspondiente o escribe "porque".'),
        solicitar_respuesta(Atributo, seleccion_unica, Texto, '', Opciones, Hipotesis, Condicion, Valor)
    ).

buscar_por_indice_o_sinonimo(Input, [opcion(Id, _, _) | _], Indice, Id) :-
    atom_number(Input, Num),
    Num == Indice,
    !.
buscar_por_indice_o_sinonimo(Input, [opcion(Id, _, Sinonimos) | _], _, Id) :-
    (   Input == Id
    ;   member(Input, Sinonimos)
    ),
    !.
buscar_por_indice_o_sinonimo(Input, [_ | Resto], Indice, IdEncontrado) :-
    Siguiente is Indice + 1,
    buscar_por_indice_o_sinonimo(Input, Resto, Siguiente, IdEncontrado).

clasificar_en_opciones(Input, [opcion(Id, _, Sinonimos) | _], Id) :-
    (   Input == Id
    ;   member(Input, Sinonimos)
    ),
    !.
clasificar_en_opciones(Input, [_ | Resto], IdEncontrado) :-
    clasificar_en_opciones(Input, Resto, IdEncontrado).

es_consulta_why(A) :-
    member(A, ['porque', 'por que', 'porqué', 'por qué', 'why', 'w', '?', 'p', 'explicar']).

limpiar_texto_entrada(Raw, Limpio) :-
    normalize_space(atom(Atom), Raw),
    downcase_atom(Atom, Lower),
    remover_puntuacion(Lower, Limpio).

remover_puntuacion(Atom, Limpio) :-
    (   member(Atom, ['?', '¿?', '¿', 'why', 'porque'])
    ->  Limpio = 'porque'
    ;   atom_chars(Atom, Chars),
        exclude(es_puntuacion, Chars, CharsLimpios),
        atom_chars(Limpio, CharsLimpios)
    ).

es_puntuacion('.').
es_puntuacion(',').
es_puntuacion(';').
es_puntuacion('!').
es_puntuacion('¡').

% -----------------------------------------------------------------------------
% MECANISMO DE EXPLICACIÓN "WHY" (¿Por qué me preguntas esto?)
% -----------------------------------------------------------------------------
explicar_why(Hipotesis, condicion(Atributo, ValoresPermitidos)) :-
    nl,
    writeln('-------------------- [JUSTIFICACIÓN "WHY"] --------------------'),
    (   descripcion_estrategia(Hipotesis, NombreHipotesis, _)
    ->  format('Estoy evaluando la viabilidad de la estrategia:~n   "~w"~n', [NombreHipotesis])
    ;   format('Estoy evaluando la viabilidad de la hipótesis: "~w"~n', [Hipotesis])
    ),
    (   definicion_pregunta(Atributo, _, TextoPregunta, Ayuda, _)
    ->  format('Se necesita determinar el parámetro: "~w"~n', [Atributo]),
        format('Pregunta asociada: ~w~n', [TextoPregunta]),
        format('Contexto: ~w~n', [Ayuda])
    ;   format('Se necesita evaluar la condición sobre: "~w"~n', [Atributo])
    ),
    format('Para que esta estrategia sea viable, los valores requeridos son: ~w~n', [ValoresPermitidos]),
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
    ->  writeln('  [-] Criterios no satisfechos o incompatibles:'),
        imprimir_lista_how(NoCumplidas, '     ✗ ')
    ;   writeln('  [!] Se cumplió el 100% de los criterios ideales.')
    ),
    nl.

imprimir_lista_how([], _) :- !.
imprimir_lista_how([condicion(Atributo, ValoresPermitidos) | Resto], Prefijo) :-
    (   conocido(Atributo, ValorActual)
    ->  descripcion_valor(Atributo, ValorActual, TextoValor),
        format('~w~w: Registrado = "~w" (Requerido: ~w)~n', [Prefijo, Atributo, TextoValor, ValoresPermitidos])
    ;   format('~w~w (No evaluado, Requerido: ~w)~n', [Prefijo, Atributo, ValoresPermitidos])
    ),
    imprimir_lista_how(Resto, Prefijo).

reiniciar_memoria :-
    retractall(conocido(_, _)).
