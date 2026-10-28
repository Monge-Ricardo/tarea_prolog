# Sistema Experto de Estrategias de Marketing Digital (Prolog)

Este proyecto implementa un sistema interactivo de inferencia lógica basado en reglas para la recomendación de estrategias de marketing digital, con soporte para consola y frontend web.

---

## 📁 Estructura del Proyecto

1. **[conocimiento_marketing.pl](file:///c:/Users/andre/Documents/ESPE/ESPE/SEMESTRE6/ABC/Tarea_Prolog/tarea_prolog/conocimiento_marketing.pl)**: 
   - Hechos declarativos y reglas del negocio puras (`regla/2`, `descripcion_estrategia/3`, `pregunta/2`).
2. **[motor_experto.pl](file:///c:/Users/andre/Documents/ESPE/ESPE/SEMESTRE6/ABC/Tarea_Prolog/tarea_prolog/motor_experto.pl)**:
   - Motor genérico con scoring de incertidumbre, memoria dinámica (`conocido/2`) y mecanismos de auditoría ("Why" / "How").
3. **[main.pl](file:///c:/Users/andre/Documents/ESPE/ESPE/SEMESTRE6/ABC/Tarea_Prolog/tarea_prolog/main.pl)**:
   - Punto de entrada para ejecución por terminal/consola.
4. **[index.html](file:///c:/Users/andre/Documents/ESPE/ESPE/SEMESTRE6/ABC/Tarea_Prolog/tarea_prolog/index.html)**:
   - Frontend web conversacional (interfaz de chat) que ejecuta el motor de Prolog en el navegador mediante **Tau-Prolog**.
5. **`js/`**:
   - Binarios locales de Tau-Prolog (`tau-prolog.js` y `lists.js`).

---

## 🌐 Uso del Frontend Web (Chat Conversacional)

El servidor local ya se encuentra disponible en:
👉 **[http://localhost:8000/index.html](http://localhost:8000/index.html)**

### Características del Chat:
- **Interacción fluida:** Botones de respuesta rápida (`Sí`, `No`, `¿Por qué?`) y campo de texto libre.
- **Motor Prolog local:** Inferencia directa mediante Tau-Prolog sin depender de APIs externas.
- **Justificación "Why":** Botón para auditar qué hipótesis se está contrastando en tiempo real.
- **Reporte "How":** Desglose visual de afinidad porcentual, evidencias confirmadas (`✓`) y criterios no cumplidos (`✗`).

Para iniciar el servidor manualmente en cualquier momento:
```powershell
python -m http.server 8000
```

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
