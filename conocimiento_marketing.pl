:- encoding(utf8).

% =============================================================================
% BASE DE CONOCIMIENTO: ESTRATEGIAS Y RECOMENDACIONES DE MARKETING DIGITAL
% =============================================================================
% Hechos declarativos puros y reglas de negocio sobre marketing digital.
% Desacoplado de la lógica de inferencia, scoring o interacción de usuario.
% =============================================================================

% -----------------------------------------------------------------------------
% regla(IdEstrategia, ListaCriterios)
% Cada estrategia define los criterios ideales requeridos para su aplicación.
% -----------------------------------------------------------------------------
regla(campanas_google_search_y_sem, [
    objetivo_ventas_directas,
    presupuesto_medio_o_alto,
    publico_con_alta_intencion_compra
]).

regla(publicidad_redes_sociales_meta_ads, [
    objetivo_visibilidad_y_alcance,
    producto_visualmente_atractivo,
    audiencia_joven_o_general
]).

regla(marketing_de_contenidos_y_seo, [
    objetivo_posicionamiento_largo_plazo,
    presupuesto_bajo_o_limitado,
    capacidad_creacion_contenido
]).

regla(email_marketing_y_fidelizacion, [
    objetivo_retencion_y_recompra,
    posee_base_datos_clientes,
    producto_recompra_recurrente
]).

regla(marketing_de_influencers_microinfluencers, [
    objetivo_visibilidad_y_alcance,
    producto_visualmente_atractivo,
    presupuesto_medio_o_alto
]).

regla(inbound_marketing_y_lead_nurturing, [
    objetivo_ventas_directas,
    ciclo_de_venta_largo,
    capacidad_creacion_contenido
]).

% -----------------------------------------------------------------------------
% descripcion_estrategia(IdEstrategia, NombreLegible, AccionRecomendada)
% -----------------------------------------------------------------------------
descripcion_estrategia(
    campanas_google_search_y_sem,
    'Google Ads (Búsqueda / SEM)',
    'Capturar clientes que ya están buscando activamente tus productos o servicios mediante anuncios en motores de búsqueda.'
).

descripcion_estrategia(
    publicidad_redes_sociales_meta_ads,
    'Social Ads (Meta / Instagram & Facebook)',
    'Generar demanda y reconocimiento de marca a través de campañas segmentadas de imágenes y videos cortos.'
).

descripcion_estrategia(
    marketing_de_contenidos_y_seo,
    'SEO Orgánico y Marketing de Contenidos',
    'Crear artículos de blog, videos educativos y optimización web para atraer tráfico continuo con bajo costo de pauta.'
).

descripcion_estrategia(
    email_marketing_y_fidelizacion,
    'Email Marketing y Automatización de Retención',
    'Diseñar flujos automáticos de nutrición, ofertas personalizadas y campañas de fidelización para clientes existentes.'
).

descripcion_estrategia(
    marketing_de_influencers_microinfluencers,
    'Marketing con Micro-Influencers de Nicho',
    'Colaborar con creadores de contenido especializados para construir confianza rápida y prueba social de tu producto.'
).

descripcion_estrategia(
    inbound_marketing_y_lead_nurturing,
    'Inbound Marketing y Nutrición de Prospectos (Leads)',
    'Ofrecer recursos descargables (lead magnets) y embudos automatizados de valor para productos o servicios complejos.'
).

% -----------------------------------------------------------------------------
% pregunta(IdCriterio, TextoPregunta)
% -----------------------------------------------------------------------------
pregunta(objetivo_ventas_directas,
    '¿El objetivo principal del negocio es conseguir ventas o conversiones directas inmediatas?').

pregunta(objetivo_visibilidad_y_alcance,
    '¿El objetivo principal es aumentar el alcance y reconocimiento de marca en el mercado?').

pregunta(objetivo_posicionamiento_largo_plazo,
    '¿El objetivo es construir una presencia sólida y sostenible a mediano o largo plazo?').

pregunta(objetivo_retencion_y_recompra,
    '¿El objetivo principal es fidelizar y maximizar el valor de los clientes actuales?').

pregunta(presupuesto_medio_o_alto,
    '¿Cuentas con un presupuesto de inversión publicitaria medio o alto?').

pregunta(presupuesto_bajo_o_limitado,
    '¿Cuentas con un presupuesto publicitario bajo o limitado?').

pregunta(publico_con_alta_intencion_compra,
    '¿Tu público objetivo busca activamente una solución inmediata a una necesidad clara?').

pregunta(producto_visualmente_atractivo,
    '¿Tu producto o servicio destaca de manera visual (fotografía, video, demostración)?').

pregunta(audiencia_joven_o_general,
    '¿Tu audiencia objetivo suele consumir redes sociales de forma cotidiana?').

pregunta(capacidad_creacion_contenido,
    '¿El equipo tiene tiempo o capacidad para redactar o producir contenido de valor?').

pregunta(posee_base_datos_clientes,
    '¿Cuentas actualmente con correos electrónicos o contactos registrados de clientes o prospectos?').

pregunta(producto_recompra_recurrente,
    '¿Tu modelo de negocio o producto permite compras repetidas o suscripciones recurrentes?').

pregunta(ciclo_de_venta_largo,
    '¿El proceso de decisión de compra del cliente requiere evaluación previa o es de alto valor (B2B/servicios)?').
