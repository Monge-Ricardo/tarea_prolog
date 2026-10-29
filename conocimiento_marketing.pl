:- encoding(utf8).

% =============================================================================
% BASE DE CONOCIMIENTO: ESTRATEGIAS Y RECOMENDACIONES DE MARKETING DIGITAL
% =============================================================================
% Hechos declarativos puros basados en el modelo Atributo-Valor.
% Opciones de respuesta atómicas y libres de conectores disyuntivos.
% =============================================================================

% -----------------------------------------------------------------------------
% regla(IdEstrategia, ListaCondiciones)
% Cada condición se expresa como: condicion(IdAtributo, ListaValoresAceptables)
% -----------------------------------------------------------------------------
regla(campanas_google_search_y_sem, [
    condicion(objetivo_principal, [ventas_directas]),
    condicion(presupuesto, [medio, alto]),
    condicion(publico_con_alta_intencion_compra, [si]),
    condicion(comportamiento_descubrimiento, [busqueda_racional])
]).

regla(publicidad_redes_sociales_meta_ads, [
    condicion(objetivo_principal, [visibilidad_marca, ventas_directas]),
    condicion(comportamiento_descubrimiento, [descubrimiento_visual]),
    condicion(audiencia_en_redes_sociales, [si])
]).

regla(marketing_de_contenidos_y_seo, [
    condicion(objetivo_principal, [posicionamiento_largo_plazo]),
    condicion(presupuesto, [bajo, medio]),
    condicion(capacidad_creacion_contenido, [si]),
    condicion(comportamiento_descubrimiento, [busqueda_racional])
]).

regla(email_marketing_y_fidelizacion, [
    condicion(objetivo_principal, [retencion_clientes]),
    condicion(posee_base_datos_clientes, [si]),
    condicion(producto_recompra_recurrente, [si])
]).

regla(marketing_de_influencers_microinfluencers, [
    condicion(objetivo_principal, [visibilidad_marca]),
    condicion(comportamiento_descubrimiento, [descubrimiento_visual]),
    condicion(presupuesto, [medio, alto]),
    condicion(audiencia_en_redes_sociales, [si])
]).

regla(inbound_marketing_y_lead_nurturing, [
    condicion(objetivo_principal, [ventas_directas, posicionamiento_largo_plazo]),
    condicion(ciclo_de_decision, [largo_evaluativo]),
    condicion(capacidad_creacion_contenido, [si])
]).

% -----------------------------------------------------------------------------
% descripcion_estrategia(IdEstrategia, NombreLegible, GuiaDeAccion)
% -----------------------------------------------------------------------------
descripcion_estrategia(
    campanas_google_search_y_sem,
    'Google Ads (Búsqueda / SEM)',
    'Qué hacer: Configura anuncios orientados a términos exactos de compra (ej. "comprar [producto]") y dirige a los usuarios a una página de aterrizaje clara con llamada a la acción directa.'
).

descripcion_estrategia(
    publicidad_redes_sociales_meta_ads,
    'Social Ads (Meta / Instagram & Facebook)',
    'Qué hacer: Diseña anuncios en video e imágenes mostrando tu producto en acción, segmenta tu audiencia por intereses y lanza promociones directas con enlace a tu tienda o WhatsApp.'
).

descripcion_estrategia(
    marketing_de_contenidos_y_seo,
    'SEO Orgánico y Marketing de Contenidos',
    'Qué hacer: Publica artículos o videos resolviendo las dudas más habituales de tus clientes, optimiza los títulos con palabras clave de búsqueda y atrae tráfico orgánico continuo sin costo de pauta.'
).

descripcion_estrategia(
    email_marketing_y_fidelizacion,
    'Email Marketing y Fidelización',
    'Qué hacer: Envía a tus contactos de clientes una publicidad, novedad o promoción exclusiva sobre tu producto para incentivar compras repetidas y reactivar clientes inactivos.'
).

descripcion_estrategia(
    marketing_de_influencers_microinfluencers,
    'Marketing con Micro-Influencers de Nicho',
    'Qué hacer: Contacta a 5-10 creadores de contenido de tu sector, envíales muestras de tu producto y pídeles reseñas auténticas y demostraciones en video para generar confianza rápida.'
).

descripcion_estrategia(
    inbound_marketing_y_lead_nurturing,
    'Inbound Marketing y Nutrición de Prospectos (Leads)',
    'Qué hacer: Diseña un recurso descargable gratuito (guía, plantilla o caso de estudio) para captar correos de prospectos y envíales una secuencia automatizada de valor antes de ofertarles.'
).

% -----------------------------------------------------------------------------
% definicion_pregunta(IdAtributo, Tipo, TextoPregunta, Ayuda, Opciones)
% Cada opción: opcion(IdValor, TextoPresentable, Sinonimos)
% -----------------------------------------------------------------------------
definicion_pregunta(
    presupuesto,
    seleccion_unica,
    '¿Cuál es el nivel de presupuesto para inversión publicitaria en esta campaña?',
    'Capacidad financiera destinada a pauta publicitaria.',
    [
        opcion(alto, 'Alto (inversión publicitaria amplia)', ['alto', '1', 'a']),
        opcion(medio, 'Medio (inversión publicitaria moderada)', ['medio', '2', 'm']),
        opcion(bajo, 'Bajo (inversión publicitaria mínima)', ['bajo', 'minima', '3', 'b'])
    ]
).

definicion_pregunta(
    objetivo_principal,
    seleccion_unica,
    '¿Cuál es el objetivo principal de esta campaña de marketing?',
    'Meta estratégica prioritaria del negocio.',
    [
        opcion(ventas_directas, 'Generar conversiones directas', ['conversiones', 'ventas', '1']),
        opcion(visibilidad_marca, 'Aumentar el reconocimiento de marca', ['marca', 'reconocimiento', '2']),
        opcion(posicionamiento_largo_plazo, 'Posicionamiento orgánico en buscadores', ['posicionamiento', 'buscadores', 'seo', '3']),
        opcion(retencion_clientes, 'Fidelizar a los clientes existentes', ['fidelizar', 'retencion', 'clientes', '4'])
    ]
).

definicion_pregunta(
    ciclo_de_decision,
    seleccion_unica,
    '¿Cómo se caracteriza el proceso de decisión de compra del cliente objetivo?',
    'Tiempo y esfuerzo cognitivo requerido antes de la compra.',
    [
        opcion(corto_impulso, 'Decisión rápida (compra inmediata)', ['rapida', 'inmediata', 'corto', '1']),
        opcion(largo_evaluativo, 'Decisión evaluativa (requiere análisis previo)', ['evaluativa', 'analisis', 'largo', '2'])
    ]
).

definicion_pregunta(
    comportamiento_descubrimiento,
    seleccion_unica,
    '¿Cómo decide el cliente habitual la compra de esta oferta?',
    'Estímulo que detona el interés de compra.',
    [
        opcion(descubrimiento_visual, 'Por atracción visual (demostración del producto)', ['visual', 'atraccion', 'demostracion', '1']),
        opcion(busqueda_racional, 'Por búsqueda activa (investigación de soluciones)', ['busqueda', 'investigacion', 'racional', '2'])
    ]
).

definicion_pregunta(
    publico_con_alta_intencion_compra,
    booleana,
    '¿El público objetivo busca activamente una solución en internet ante la necesidad?',
    'Existencia de demanda previa en canales de búsqueda.',
    [
        opcion(si, 'Sí', ['si', 's', 'yes', 'y', 'sí', '1', 'true']),
        opcion(no, 'No', ['no', 'n', 'nel', 'nop', '2', '0', 'false'])
    ]
).

definicion_pregunta(
    audiencia_en_redes_sociales,
    booleana,
    '¿El perfil de cliente habitual utiliza redes sociales cotidianamente?',
    'Presencia habitual del cliente en plataformas sociales.',
    [
        opcion(si, 'Sí', ['si', 's', 'yes', 'y', 'sí', '1', 'true']),
        opcion(no, 'No', ['no', 'n', 'nel', 'nop', '2', '0', 'false'])
    ]
).

definicion_pregunta(
    capacidad_creacion_contenido,
    booleana,
    '¿La organización dispone de recursos humanos para la creacion de contenidos?',
    'Disponibilidad de equipo para generar piezas informativas.',
    [
        opcion(si, 'Sí', ['si', 's', 'yes', 'y', 'sí', '1', 'true']),
        opcion(no, 'No', ['no', 'n', 'nel', 'nop', '2', '0', 'false'])
    ]
).

definicion_pregunta(
    posee_base_datos_clientes,
    booleana,
    '¿La empresa cuenta con un registro estructurado de contactos de posibles clientes?',
    'Disponibilidad de correos o números para contacto directo.',
    [
        opcion(si, 'Sí', ['si', 's', 'yes', 'y', 'sí', '1', 'true']),
        opcion(no, 'No', ['no', 'n', 'nel', 'nop', '2', '0', 'false'])
    ]
).

definicion_pregunta(
    producto_recompra_recurrente,
    booleana,
    '¿El modelo comercial contempla compras repetidas?',
    'Generación de ingresos recurrentes por cliente.',
    [
        opcion(si, 'Sí', ['si', 's', 'yes', 'y', 'sí', '1', 'true']),
        opcion(no, 'No', ['no', 'n', 'nel', 'nop', '2', '0', 'false'])
    ]
).

% -----------------------------------------------------------------------------
% descripcion_valor(IdAtributo, IdValor, TextoAmigable)
% Para formato amigable en auditoría "How"
% -----------------------------------------------------------------------------
descripcion_valor(Atributo, Valor, Texto) :-
    definicion_pregunta(Atributo, _, _, _, Opciones),
    member(opcion(Valor, Texto, _), Opciones),
    !.
descripcion_valor(_, Valor, Valor).
