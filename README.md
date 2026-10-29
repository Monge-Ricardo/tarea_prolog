# Sistema Experto de Estrategias de Marketing Digital (Prolog)

Este proyecto implementa un sistema interactivo de inferencia lógica basado en el modelo **Atributo-Valor** para la recomendación de estrategias de marketing digital, con soporte para consola (SWI-Prolog) y frontend web interactivo (Tau-Prolog).

---

## 📁 Estructura del Proyecto

1. **[preguntas_marketing.json](file:///c:/Users/quiro/Documents/ESPE/SextoSemestre/ApplicacionesBasadasConocimiento/tarea_prolog/preguntas_marketing.json)**:
   - Definición estructurada de preguntas en 3ª persona, responsabilidades atómicas y opciones categóricas.
2. **[conocimiento_marketing.pl](file:///c:/Users/quiro/Documents/ESPE/SextoSemestre/ApplicacionesBasadasConocimiento/tarea_prolog/conocimiento_marketing.pl)**: 
   - Base de conocimiento declarativa con reglas `condicion(Atributo, ValoresPermitidos)`, descripciones y definiciones de preguntas (`definicion_pregunta/5`).
3. **[motor_experto.pl](file:///c:/Users/quiro/Documents/ESPE/SextoSemestre/ApplicacionesBasadasConocimiento/tarea_prolog/motor_experto.pl)**:
   - Motor genérico con scoring porcentual de incertidumbre, memoria de trabajo dinámica (`conocido(Atributo, Valor)`), selección múltiple y mecanismos de auditoría ("Why" / "How").
4. **[main.pl](file:///c:/Users/quiro/Documents/ESPE/SextoSemestre/ApplicacionesBasadasConocimiento/tarea_prolog/main.pl)**:
   - Orquestador y punto de entrada para ejecución por terminal/consola.
5. **[index.html](file:///c:/Users/quiro/Documents/ESPE/SextoSemestre/ApplicacionesBasadasConocimiento/tarea_prolog/index.html)**:
   - Frontend web conversacional (interfaz de chat) que ejecuta el motor de Prolog en el navegador mediante **Tau-Prolog** con botones de opción dinámicos.
6. **`js/`**:
   - Librerías locales de Tau-Prolog (`tau-prolog.js` y `lists.js`).

---

## 🌐 Uso del Frontend Web (Chat Conversacional)

Para iniciar el servidor local en cualquier momento:
```powershell
python -m http.server 8000
```
Y abre tu navegador en:
👉 **[http://localhost:8000/index.html](http://localhost:8000/index.html)**

### Características del Chat:
- **Botones dinámicos:** Muestra botones para cada opción disponible (ej. *Alto*, *Medio*, *Bajo* o *Sí*, *No*) y botón de auditoría *¿Por qué?*.
- **Motor Prolog local:** Inferencia directa mediante Tau-Prolog sin depender de servidores externos.
- **Justificación "Why":** Audita en tiempo real qué hipótesis se evalúa y qué valores son requeridos.
- **Reporte "How":** Desglose detallado de afinidad porcentual, coincidencias (`✓`) e incompatibilidades (`✗`).

---

## 💻 Ejecución por Terminal (SWI-Prolog)

```powershell
swipl -s main.pl -g main -t halt
```
O dentro de SWI-Prolog interactivo:
```prolog
?- [main].
?- main.
```
