# Ejercicio 2: Automatización API - DemoBlaze (Karate + JUnit 5)

Este proyecto automatiza cuatro casos de registro y autenticación contra la API pública de DemoBlaze, con URL base `https://api.demoblaze.com`.

La suite utiliza dos `Scenario Outline` con datos externos en JSON: uno para `POST /signup` y otro para `POST /login`. Cada outline ejecuta dos ejemplos, para un total de cuatro escenarios. Las pruebas verifican el estado HTTP, los tipos o contratos de respuesta, los mensajes funcionales y el tiempo de respuesta.

| Caso del examen | Operación | Resultado funcional esperado |
| --- | --- | --- |
| Registro exitoso de un usuario nuevo | `POST /signup` | Cadena que contiene literalmente `""`, después de eliminar espacios y saltos de línea externos. |
| Registro de un usuario duplicado | `POST /signup` | `errorMessage: 'This user already exist.'` |
| Inicio de sesión con credenciales correctas | `POST /login` | Cadena que contiene `Auth_token:`. |
| Inicio de sesión con contraseña incorrecta | `POST /login` | `errorMessage: 'Wrong password.'` |

Los cuatro casos esperan HTTP **200**, incluso los errores funcionales de DemoBlaze, y un tiempo de respuesta **inferior a 5000 ms**.

## 🛠️ Tecnologías y frameworks

- **Lenguaje:** Java 17; requiere un JDK que incluya `java` y `javac`.
- **Herramienta de construcción:** Gradle 8.5 mediante Gradle Wrapper.
- **Framework de automatización y BDD:** Karate 1.4.1.
- **Ejecución:** JUnit 5, integrado mediante `com.intuit.karate:karate-junit5`.
- **Definición de escenarios:** Gherkin con `Scenario Outline` y `Examples`.
- **Datos de prueba:** JSON, leído con la función nativa `read()` de Karate.
- **Reportes:** HTML de Karate, JUnit XML de Karate y reportes de Gradle/JUnit.
- **Servicio probado:** API REST pública de DemoBlaze.

La versión de Karate se declara en `build.gradle`. El mismo archivo configura la toolchain de Java 17 y la ejecución con JUnit Platform.

## 📁 Estructura del proyecto

```text
Ejercicio2_API_Karate/
├── README.md
├── HANDOFF.md                         # Contexto técnico para continuar el trabajo
├── build.gradle                       # Dependencias, Java 17 y tarea test
├── settings.gradle                    # Nombre del proyecto
├── gradlew                            # Wrapper para Linux/macOS
├── gradlew.bat                        # Wrapper para Windows
├── gradle/
│   └── wrapper/
│       ├── gradle-wrapper.jar
│       └── gradle-wrapper.properties   # Distribución de Gradle 8.5
└── src/
    └── test/
        ├── java/com/tcs/certificacion/api/
        │   └── ApiRunner.java         # Runner JUnit 5 y generación de reportes
        └── resources/
            ├── karate-config.js       # URL base, cabeceras y timeouts
            ├── data/
            │   └── usuarios_data.json # Dos ejemplos de registro y dos de login
            ├── features/
            │   └── gestion_usuarios.feature
            └── schemas/
                └── usuario_schema.json
```

`schemas/usuario_schema.json` es un archivo de una iteración anterior y no se utiliza en las pruebas vigentes de DemoBlaze. Los contratos actuales se declaran en `responseSchema`, dentro del JSON de datos.

## 📊 Datos de prueba

El archivo consumido por la suite es:

```text
src/test/resources/data/usuarios_data.json
```

Contiene un objeto con dos listas: `registro` y `login`. Cada lista tiene dos filas y cada fila genera un escenario independiente en Karate.

| Campo | Uso |
| --- | --- |
| `caso` | Nombre del ejemplo, visible en los reportes. |
| `username` | Usuario enviado a la API. En registro, `null` genera un usuario nuevo con prefijo `user_` y UUID. |
| `password` | Contraseña enviada a la API. |
| `responseSchema` | Tipo o contrato esperado: `"#string"` o `{ "errorMessage": "#string" }`. |
| `expectedResponse` | Resultado funcional exacto de los ejemplos de registro. |
| `expectedContent` | Contenido esperado de los ejemplos de login: prefijo del token o mensaje de error. |

Ejemplo de una fila de registro exitoso:

```json
{
  "caso": "Crear un nuevo usuario en signup",
  "username": null,
  "password": "Password123!",
  "responseSchema": "#string",
  "expectedResponse": "\"\""
}
```

En el feature, los datos se consumen directamente en las tablas `Examples`:

```gherkin
Examples:
  | read('classpath:data/usuarios_data.json').registro |
```

```gherkin
Examples:
  | read('classpath:data/usuarios_data.json').login |
```

`Background` comparte `baseUrl`, las cabeceras, la generación del usuario único y `maxResponseTime = 5000`. Los pasos de cada operación se reutilizan; las credenciales, esquemas y resultados esperados se obtienen de cada fila JSON.

El registro exitoso normaliza la respuesta con `trim()` antes de compararla con `expectedResponse`. DemoBlaze devuelve una cadena con `""` y un salto de línea, por lo que esperar un objeto `{}` produciría un fallo de tipos.

Para añadir ejemplos, agregar filas a la lista correspondiente conservando sus campos. No se necesita un lector de datos adicional. El JSON debe conservar los cuatro casos originales para la evaluación de esta práctica.

## 🚀 Prerrequisitos

1. Instalar **JDK 17** y comprobar que incluye el compilador `javac`.
2. Configurar `JAVA_HOME` apuntando al directorio del JDK, sin incluir `bin`, y agregar su carpeta `bin` al `PATH`.
3. Tener conexión a internet y acceso HTTPS a la distribución de Gradle (`services.gradle.org` y sus destinos de descarga), Maven Central y `api.demoblaze.com`.
4. Tener permisos de escritura en el proyecto y en la caché de Gradle del usuario. La primera ejecución descarga Gradle y las dependencias.
5. Disponer del usuario base de prueba en DemoBlaze, con las credenciales indicadas abajo.

No es necesario instalar Gradle globalmente. Deben conservarse `gradlew`, `gradlew.bat`, `gradle-wrapper.jar` y `gradle-wrapper.properties` en la entrega.

Los casos de usuario duplicado y login utilizan:

```text
Usuario: testuser_existente
Contraseña: password123
```

La suite no crea automáticamente este usuario base. El usuario nuevo generado por UUID corresponde únicamente al caso de registro exitoso. Si los datos del servicio público se reinician, preparar el usuario base antes de ejecutar la evaluación.

## 🧪 Ejecución paso a paso

### 1. Abrir una terminal en la raíz del proyecto

Ubicarse en `Ejercicio2_API_Karate`, donde están `build.gradle`, `gradlew` y `gradlew.bat`. Todos los comandos siguientes parten de esa carpeta.

### 2. Comprobar Java

En PowerShell:

```powershell
java -version
javac -version
$env:JAVA_HOME
```

`java` y `javac` deben indicar versión 17. Si la terminal utiliza otra versión o `JAVA_HOME` está vacío, configurar la sesión antes de continuar. Este es un ejemplo con la instalación utilizada durante la validación; adaptar la ruta al JDK 17 de la máquina evaluadora:

```powershell
$env:JAVA_HOME = 'C:\Program Files\Eclipse Adoptium\jdk-17.0.19.10-hotspot'
$env:PATH = "$env:JAVA_HOME\bin;$env:PATH"
java -version
javac -version
```

Estas asignaciones aplican a la sesión actual. Para conservarlas entre terminales, configurar las variables de entorno del sistema operativo y abrir una terminal nueva.

### 3. Comprobar el Gradle Wrapper

```powershell
.\gradlew.bat --version
```

La salida debe indicar **Gradle 8.5** y una **JVM 17**.

### 4. Preparar o verificar el usuario base

Antes de una evaluación en un entorno nuevo, este bloque de PowerShell intenta registrar el usuario base y comprueba que sus credenciales permiten iniciar sesión:

```powershell
$apiBase = 'https://api.demoblaze.com'
$usuarioBase = @{
    username = 'testuser_existente'
    password = 'password123'
} | ConvertTo-Json -Compress

$registroBase = Invoke-RestMethod -Method Post -Uri "$apiBase/signup" `
    -ContentType 'application/json' -Body $usuarioBase
$registroBase

$loginBase = Invoke-RestMethod -Method Post -Uri "$apiBase/login" `
    -ContentType 'application/json' -Body $usuarioBase

if ($loginBase -isnot [string] -or $loginBase -notlike '*Auth_token:*') {
    throw 'El usuario base no permite login. Revisar su existencia y contraseña antes de ejecutar la suite.'
}

Write-Host 'Usuario base verificado.'
```

Una respuesta vacía de PowerShell para el registro exitoso es esperable porque `Invoke-RestMethod` interpreta la cadena JSON vacía. Si el usuario ya existe, signup devuelve `This user already exist.`; la comprobación de login confirma que la contraseña también es correcta. Esta preparación es independiente de los cuatro escenarios evaluados.

Si el nombre está ocupado con otra contraseña, utilizar un usuario de prueba propio: crearlo con credenciales conocidas y actualizar de forma consistente el caso de duplicado y ambos casos de login en `usuarios_data.json`. En el caso de login fallido, conservar una contraseña distinta de la válida.

### 5. Ejecutar la suite y generar los reportes

En Windows/PowerShell:

```powershell
.\gradlew.bat clean test
```

En Linux/macOS, con JDK 17 configurado en `JAVA_HOME` y `PATH`:

```sh
sh ./gradlew clean test
```

El comando realiza las siguientes acciones:

1. Elimina resultados anteriores con `clean`.
2. Compila las pruebas con la toolchain de Java 17.
3. Ejecuta `ApiRunner.testApi()` mediante JUnit 5.
4. Ejecuta `classpath:features/gestion_usuarios.feature` con Karate, secuencialmente mediante `.parallel(1)`.
5. Expande las dos listas JSON en cuatro escenarios y realiza las solicitudes HTTP.
6. Genera los reportes HTML y JUnit XML de Karate y los reportes de Gradle/JUnit.
7. Falla el test JUnit si Karate registra algún escenario fallido.

Resultado esperado:

```text
> Task :test
BUILD SUCCESSFUL
```

Karate debe registrar **4 escenarios aprobados y 0 fallidos**. Gradle/JUnit registra **1 test**, correspondiente al método del runner que ejecuta los cuatro escenarios Karate.

La última validación realizada el **4 de octubre de 2026** utilizó Java 17.0.19, Gradle 8.5 y Karate 1.4.1, y terminó con `BUILD SUCCESSFUL in 9s`, cuatro escenarios aprobados y cero fallidos. La duración puede variar según la red y el servicio.

## 📄 Ubicación de reportes

| Artefacto | Ruta desde la raíz del proyecto |
| --- | --- |
| Resumen HTML de Karate | `build/karate-reports/karate-summary.html` |
| Detalle HTML de los cuatro ejemplos | `build/karate-reports/features.gestion_usuarios.html` |
| JUnit XML de Karate, con los cuatro casos | `build/karate-reports/features.gestion_usuarios.xml` |
| Resumen de Karate en formato JSON | `build/karate-reports/karate-summary-json.txt` |
| Detalle estructurado de Karate en JSON | `build/karate-reports/features.gestion_usuarios.karate-json.txt` |
| HTML de Gradle/JUnit | `build/reports/tests/test/index.html` |
| JUnit XML de Gradle, con el método del runner | `build/test-results/test/TEST-com.tcs.certificacion.api.ApiRunner.xml` |

Los archivos con sufijo `-json.txt` contienen JSON y pueden procesarse de forma automatizada.

Para abrir el reporte principal desde PowerShell:

```powershell
Start-Process .\build\karate-reports\karate-summary.html
```

Al compartir o recolectar el reporte de Karate, conservar **todo el directorio `build/karate-reports/`**, incluidos sus recursos y reportes detallados. Recolectar los artefactos antes de otra ejecución con `clean`.

## 🔍 Evidencias y diagnóstico

Los reportes detallados de Karate muestran los pasos, las solicitudes, las respuestas, los tiempos y los errores de validación. Si un escenario falla durante la ejecución, el runner genera sus reportes antes de propagar el fallo a JUnit. Un fallo de configuración, descarga o compilación anterior a Karate puede impedir que se generen esos reportes.

Para obtener más información:

```powershell
.\gradlew.bat clean test --info --stacktrace
```

| Síntoma | Comprobación o acción |
| --- | --- |
| `No matching toolchains found` para Java 17 | Verificar `java -version`, `javac -version` y `JAVA_HOME`; seleccionar un JDK 17 antes de volver a ejecutar. |
| `AssertionFailedError` en `ApiRunner.java` | Abrir el HTML detallado de Karate. La línea del runner refleja un escenario fallido; el reporte identifica su causa. |
| `This user already exist.` en el caso de usuario nuevo | Mantener `username: null` en esa fila JSON para generar un UUID en cada ejecución. |
| Falla el caso duplicado o el login válido | Preparar/verificar el usuario base y confirmar las credenciales del JSON. |
| `Wrong password.` o `User does not exist.` cuando se esperaba un token | Revisar el usuario base; HTTP 200 por sí solo no indica login exitoso. |
| Diferencia de tipos `STRING:MAP` en signup exitoso | Conservar `responseSchema: "#string"` y `expectedResponse: "\"\""`; signup exitoso no devuelve `{}`. |
| Timeout o respuesta de 5000 ms o más | Revisar conexión, disponibilidad de DemoBlaze y tiempo registrado. Los timeouts de conexión y lectura están en `karate-config.js`; el límite de la aserción está en el `Background` del feature. |
| No se descargan Gradle o dependencias | Verificar acceso HTTPS, proxy y certificados del entorno de evaluación. |
| Advertencia sobre funciones obsoletas para Gradle 9 | Usar el Wrapper 8.5 incluido. En las ejecuciones verificadas esta advertencia no impidió el resultado exitoso. |

La suite utiliza un servicio público externo: cada ejecución crea un usuario nuevo para el caso exitoso y los otros tres casos dependen del estado del usuario base.

## ✅ Compatibilidad

Para evaluar este proyecto mediante **EvalIA**, configurar el entorno con JDK 17, acceso de red, permisos de escritura y el usuario base preparado. La raíz de trabajo debe ser `Ejercicio2_API_Karate`.

El comando de evaluación recomendado en Windows es:

```powershell
.\gradlew.bat clean test
```

En un evaluador Linux/macOS:

```sh
sh ./gradlew clean test
```

El proceso devuelve código **0** si la construcción y las pruebas terminan correctamente, y un código **distinto de cero** si hay un fallo. `ApiRunner` comprueba explícitamente que `results.getFailCount()` sea cero.

Para la recolección de resultados, configurar estos directorios como artefactos, también cuando fallen las pruebas:

- `build/karate-reports/`: HTML, resultados detallados y JUnit XML de los cuatro escenarios.
- `build/test-results/test/`: resultado estándar JUnit del runner.
- `build/reports/tests/test/`: reporte HTML de Gradle.

En `build/karate-reports/karate-summary-json.txt`, los valores esperados para el JSON original son `scenariosPassed: 4` y `scenariosfailed: 0`. En el XML de Karate se esperan `tests="4"` y `failures="0"`. El XML de Gradle corresponde a un único test JUnit y se esperan `tests="1"`, `failures="0"`, `errors="0"` y `skipped="0"`.

| Requisito de la práctica | Implementación y evidencia |
| --- | --- |
| Todos los tests corren correctamente | Cuatro casos de signup/login verificados; el runner propaga los fallos a Gradle. |
| Generación de informes Karate | `.outputHtmlReport(true)` y `.outputJunitXml(true)`; artefactos bajo `build/karate-reports/`. |
| Features optimizados y utilización de variables | `Background`, pasos compartidos por operación, usuario con UUID y datos/expectativas parametrizados. |
| Scenario Outline con CSV o JSON | Dos `Scenario Outline` con `Examples` que consumen las listas `registro` y `login` del JSON. |

