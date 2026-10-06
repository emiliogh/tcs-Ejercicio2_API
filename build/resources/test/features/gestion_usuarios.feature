Feature: Pruebas de API para Autenticación y Registro en DemoBlaze
  Como QA Engineer
  Quiero validar las operaciones de signup y login en DemoBlaze
  Para garantizar el comportamiento funcional, respuestas de error, tiempos de respuesta, contratos y tipos de datos.

  Background:
    * url baseUrl
    * configure headers = headers
    * def randomUser = 'user_' + java.util.UUID.randomUUID().toString()
    * def maxResponseTime = 5000

  @SignUp
  Scenario Outline: Registro - <caso>
    * def requestUsername = username == null ? randomUser : username
    Given path 'signup'
    And request { "username": '#(requestUsername)', "password": '#(password)' }
    When method POST
    Then status 200
    And assert responseTime < maxResponseTime
    And match response == responseSchema
    * def normalizedResponse = karate.typeOf(response) == 'string' ? response.trim() : response
    And match normalizedResponse == expectedResponse

    Examples:
      | read('classpath:data/usuarios_data.json').registro |

  @Login
  Scenario Outline: Autenticación - <caso>
    Given path 'login'
    And request { "username": '#(username)', "password": '#(password)' }
    When method POST
    Then status 200
    And assert responseTime < maxResponseTime
    And match response == responseSchema
    And match response contains expectedContent

    Examples:
      | read('classpath:data/usuarios_data.json').login |
