# Conclusiones y Hallazgos Técnicos - Ejercicio 2 API

## 1. Automatización con Karate

Karate permitió automatizar los cuatro casos de registro y autenticación de DemoBlaze con validaciones de estado HTTP, mensajes funcionales, tipos de datos y tiempos inferiores a 5000 ms. La última ejecución verificada aprobó los cuatro escenarios, sin fallos.

## 2. Externalización de datos y reutilización

Se implementaron dos `Scenario Outline`, uno para signup y otro para login, con dos ejemplos cada uno. Ambos consumen `usuarios_data.json` mediante `Examples` y `read()`. Las credenciales, contratos y resultados esperados quedan separados de los pasos; `Background` centraliza la URL, las cabeceras y el límite de tiempo, reduciendo duplicación.

## 3. Particularidades de las respuestas de DemoBlaze

La API devuelve HTTP 200 también ante errores funcionales, por lo que fue necesario comprobar los mensajes `This user already exist.` y `Wrong password.`. El registro exitoso devuelve una cadena con `""` y un salto de línea; se valida su tipo y se normaliza con `trim()` para compararla. El login válido exige una cadena que contenga `Auth_token:`.

## 4. Reportes y trazabilidad

`ApiRunner` genera HTML y JUnit XML de Karate en `build/karate-reports/`. El reporte principal es `karate-summary.html` y cada ejemplo aparece como un caso independiente. El runner comprueba que no existan escenarios fallidos y propaga cualquier fallo a JUnit y Gradle, facilitando la evaluación automatizada.

## 5. Portabilidad y reproducibilidad

Gradle Wrapper 8.5 y la toolchain Java 17 permiten ejecutar la suite con:

```powershell
.\gradlew.bat clean test
```

El registro exitoso utiliza un UUID para evitar colisiones entre ejecuciones. Los otros tres casos requieren el usuario base `testuser_existente` con contraseña `password123`; su preparación está documentada en `README.md`. La evaluación requiere JDK 17, conexión a internet y ese usuario disponible.
