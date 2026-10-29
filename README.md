# Sistema Experto de Estrategias de Marketing Digital (Prolog)

Este proyecto implementa un sistema experto interactivo por consola en **Prolog** (SWI-Prolog) basado en el modelo **Atributo-Valor**, con scoring de incertidumbre y mecanismos de auditoría ("Why" y "How").

---

## 📁 Estructura del Proyecto

1. **[conocimiento_marketing.pl](file:///c:/Users/andre/Documents/ESPE/ESPE/SEMESTRE6/ABC/workspace/tarea_prolog/conocimiento_marketing.pl)**: 
   - Base de conocimiento puramente declarativa.
   - Reglas de negocio con estructura: `condicion(IdAtributo, ListaValoresAceptables)`.
   - Definiciones formales de preguntas y opciones atómicas (`definicion_pregunta/5`).
   - Guías de acción y descripciones de estrategias (`descripcion_estrategia/3`).

2. **[motor_experto.pl](file:///c:/Users/andre/Documents/ESPE/ESPE/SEMESTRE6/ABC/workspace/tarea_prolog/motor_experto.pl)**:
   - Motor interactivo de inferencia y scoring de coincidencia porcentual.
   - Memoria de trabajo dinámica no redundante (`conocido(Atributo, Valor)`).
   - Manejo de entradas numéricas, cadenas y sinónimos.
   - Subsistema de explicación:
     - **Why:** Justificación contextual al ingresar `porque` o `?`.
     - **How:** Trazabilidad deductiva de evidencias cumplidas y no cumplidas.

3. **[main.pl](file:///c:/Users/andre/Documents/ESPE/ESPE/SEMESTRE6/ABC/workspace/tarea_prolog/main.pl)**:
   - Orquestador del flujo y punto de entrada por consola.
   - Presenta **únicamente la recomendación principal** ganadora y su respectiva justificación.

---

## 💻 Cómo Ejecutar el Sistema en Consola (SWI-Prolog)

Abre una terminal de PowerShell o CMD en la carpeta del proyecto:
```powershell
cd "c:\Users\andre\Documents\ESPE\ESPE\SEMESTRE6\ABC\workspace\tarea_prolog"
```

### Opción 1: Ejecución Directa
```powershell
swipl -s main.pl
```

### Opción 2: Modo Interactivo
```powershell
swipl
```
Y dentro del entorno Prolog:
```prolog
?- [main].
?- iniciar.
```

---

## 📝 Modo de Uso en Consola

* **Preguntas de selección única (menú numérico):** Escribe el número correspondiente a tu opción (ej. `1`, `2` o `3`) y presiona Enter.
* **Preguntas de Sí/No:** Escribe `si` o `no`.
* **Auditoría "Why":** En cualquier pregunta puedes escribir `porque` o `?` antes de responder para que el sistema te indique qué estrategia está evaluando y qué valor necesita.
