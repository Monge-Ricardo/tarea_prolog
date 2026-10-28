# Informe Técnico: Evolución del Sistema Experto en Prolog
**Dominio:** Recomendación de Estrategias de Marketing Digital  
**Materia:** Inteligencia Artificial / Sistemas Expertos  

---

## 1. Resumen Ejecutivo
El sistema original presentaba dos limitaciones críticas identificadas en el diagnóstico inicial:
1. **Acoplamiento Monolítico:** Reglas de negocio, memoria de trabajo e interfaz estaban fusionadas en un solo archivo.
2. **Rigidez Booleana Categórica:** El uso de encadenamiento booleano estricto provocaba que, si un usuario negaba una sola condición de tres, la hipótesis se descartaba totalmente, arrojando con frecuencia el mensaje *"No se pudo determinar un diagnóstico"*.
3. **Caja Negra (Falta de Explicación):** El usuario no podía conocer la razón de las preguntas formuladas ni auditar el proceso deductivo completo.

Para superar estas limitaciones, se implementó una **solución integral** estructurada en tres módulos con **razonamiento basado en Scoring de Afinidad** y subsistema de **auditoría y justificación (Why / How)**.

---

## 2. Separación Modular y Estructura de Archivos

La arquitectura se dividió siguiendo el principio de responsabilidad única:

```
tarea_prolog/
│
├── conocimiento_marketing.pl   # Base de Hechos y Reglas (Negocio puro)
├── motor_experto.pl            # Motor de Inferencia, Scoring, Memoria Dinámica y Explicación
├── main.pl                     # Punto de Entrada, Orquestador y Formato de Salida
└── README.md                   # Documentación y Guía de Ejecución
```

### Detalle de cada módulo:
* **[conocimiento_marketing.pl](file:///c:/Users/andre/Documents/ESPE/ESPE/SEMESTRE6/ABC/Tarea_Prolog/tarea_prolog/conocimiento_marketing.pl):**
  - Contiene exclusivamente predicados declarativos: `regla/2`, `descripcion_estrategia/3` y `pregunta/2`.
  - Cero dependencias de lectura de consola o manipulación de estado. Esto permite reutilizar la base con cualquier otro motor o interfaz web/gráfica.
* **[motor_experto.pl](file:///c:/Users/andre/Documents/ESPE/ESPE/SEMESTRE6/ABC/Tarea_Prolog/tarea_prolog/motor_experto.pl):**
  - Motor genérico con memoria de trabajo dinámica (`conocido/2`).
  - Implementación del algoritmo de cálculo de afinidad porcentual.
  - Gestión de comandos interactivos para interrupciones justificativas.
* **[main.pl](file:///c:/Users/andre/Documents/ESPE/ESPE/SEMESTRE6/ABC/Tarea_Prolog/tarea_prolog/main.pl):**
  - Carga modular mediante directivas `consult/1`.
  - Coordina el flujo principal, clasifica la estrategia óptima vs. alternativas viables ($\ge 50\%$) y renderiza la trazabilidad deductiva.

---

## 3. Razonamiento con Incertidumbre: Scoring de Afinidad

### Limitación previa
Anteriormente se evaluaba mediante conjunción estricta:
```prolog
% Antes: si una sola condición fallaba, fallaba la estrategia completa
diagnostico(D, Sintomas) :- regla(D, Sintomas), confirmar(Sintomas).
```

### Solución Implementada
Se sustituyó el rechazo binario por un cálculo de **grado de coincidencia porcentual** ($\text{Score} \in [0, 100\%]$):

$$\text{Score} = \text{round}\left(\frac{|\text{Condiciones Afirmativas}|}{|\text{Condiciones Totales}|} \times 100\right)$$

En [motor_experto.pl](file:///c:/Users/andre/Documents/ESPE/ESPE/SEMESTRE6/ABC/Tarea_Prolog/tarea_prolog/motor_experto.pl):
```prolog
evaluar_estrategia(Estrategia, Score, Cumplidas, NoCumplidas) :-
    regla(Estrategia, Condiciones),
    evaluar_lista_condiciones(Condiciones, Estrategia, Cumplidas, NoCumplidas),
    length(Condiciones, Total),
    length(Cumplidas, Positivas),
    ( Total > 0 -> Score is round((Positivas / Total) * 100) ; Score = 0 ).
```

### Beneficios Técnicos:
1. **Tolerancia a fallos:** Si un negocio tiene 2 de 3 condiciones, recibe una calificación del $67\%$, permitiendo al sistema ofrecerla como alternativa viable.
2. **Priorización inteligente:** El motor clasifica automáticamente las alternativas mediante `sort(1, @>=, Resultados, RankingOrdenado)`, entregando primero la estrategia con mayor idoneidad.

---

## 4. Subsistema de Explicación y Auditoría ("Why" y "How")

### A. Justificación "Why" (¿Por qué me preguntas esto?)
Permite al usuario detener el flujo de preguntas para conocer qué hipótesis se está contrastando y qué condición exige.

* **Activación:** El usuario escribe `porque`, `por que`, `why` o `?`.
* **Comportamiento:**
  1. El motor intercepta la respuesta sin alterar la memoria de trabajo.
  2. Muestra el bloque explicativo con el nombre descriptivo de la estrategia en evaluación y el criterio técnico requerido.
  3. Vuelve a solicitar la respuesta sin perder el estado.

```
-------------------- [JUSTIFICACIÓN "WHY"] --------------------
Estoy evaluando la viabilidad de la estrategia:
   "Social Ads (Meta / Instagram & Facebook)"
Para poder determinar su idoneidad, necesito verificar si aplica el criterio:
   "producto_visualmente_atractivo".
---------------------------------------------------------------
```

### B. Trazabilidad "How" (¿Cómo se llegó a esta conclusión?)
Al finalizar la consulta, el sistema no se limita a mostrar un nombre aislado; presenta un reporte de auditoría deductiva desglosando los hechos confirmados y descartados almacenados en la memoria de trabajo:

```
=================================================================
             AUDITORÍA Y TRAZABILIDAD DEDUCTIVA ("HOW")          
=================================================================
TRAZABILIDAD "HOW" para [Social Ads (Meta / Instagram & Facebook)] (100% de afinidad):
  [+] Evidencias afirmativas confirmadas en memoria:
     ✓ ¿El objetivo principal es aumentar el alcance y reconocimiento de marca en el mercado? (objetivo_visibilidad_y_alcance)
     ✓ ¿Tu producto o servicio destaca de manera visual (fotografía, video, demostración)? (producto_visualmente_atractivo)
     ✓ ¿Tu audiencia objetivo suele consumir redes sociales de forma cotidiana? (audiencia_joven_o_general)
  [!] Se cumplió el 100% de los criterios ideales.

TRAZABILIDAD "HOW" para [Marketing con Micro-Influencers de Nicho] (67% de afinidad):
  [+] Evidencias afirmativas confirmadas en memoria:
     ✓ ¿El objetivo principal es aumentar el alcance...? (objetivo_visibilidad_y_alcance)
     ✓ ¿Tu producto destaca de manera visual...? (producto_visualmente_atractivo)
  [-] Evidencias no satisfechas o ausentes:
     ✗ ¿Cuentas con un presupuesto de inversión publicitaria medio o alto? (presupuesto_medio_o_alto)
```

---

## 5. Tabla Comparativa: Antes vs. Después

| Característica | Sistema Inicial Monolítico | Sistema Evolucionado Actual |
| :--- | :--- | :--- |
| **Arquitectura** | Monolítico en `experto.pl` | 3 capas desacopladas ([conocimiento](file:///c:/Users/andre/Documents/ESPE/ESPE/SEMESTRE6/ABC/Tarea_Prolog/tarea_prolog/conocimiento_marketing.pl), [motor](file:///c:/Users/andre/Documents/ESPE/ESPE/SEMESTRE6/ABC/Tarea_Prolog/tarea_prolog/motor_experto.pl), [main](file:///c:/Users/andre/Documents/ESPE/ESPE/SEMESTRE6/ABC/Tarea_Prolog/tarea_prolog/main.pl)) |
| **Inferencia** | Binaria rígida (Todo o Nada) | Grado de afinidad y ranking porcentual ($0 - 100\%$) |
| **Resiliencia** | Un solo "no" anulaba la recomendación | Presenta estrategia principal y alternativas viables ($\ge 50\%$) |
| **Mecanismo "Why"** | Inexistente | Interactivo en consola con `porque` o `?` |
| **Mecanismo "How"** | Mensaje plano de síntomas confirmados | Auditoría formal con evidencias afirmativas ($+$) y ausentes ($-$) |
| **Memoria de trabajo** | Básica (`conocido/2`) | Optimizada, normalizada e integrable en la auditoría |

---

## 6. Conclusiones
La combinación de **Scoring de Afinidad** y **Auditoría Why/How** transforma el prototipo en un sistema experto de grado profesional: elimina el problema de respuestas vacías ante condiciones parciales y convierte al motor en una herramienta transparente y auditable para la toma de decisiones estratégicas.
