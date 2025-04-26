#!/bin/bash

# Endpoint a probar
ENDPOINT="https://crudcrud.com/api/a8432d716d454b6ab80e8921f881be9f/noticias"

# Contador de solicitudes
COUNT=0

echo "Iniciando pruebas al endpoint: $ENDPOINT"

# Bucle infinito para realizar solicitudes
while true; do
  # Incrementa el contador
  COUNT=$((COUNT + 1))

  # Realiza la solicitud GET al endpoint
  RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" "$ENDPOINT")

  echo "Solicitud #$COUNT: Código de respuesta HTTP: $RESPONSE"

  # Verifica si el código de respuesta es un error 4xx
  if [[ $RESPONSE == 4* ]]; then
    echo "Se recibió un código de error 4xx: $RESPONSE. Deteniendo pruebas."
    break
  fi

  # Pausa opcional entre solicitudes (por ejemplo, 1 segundo)
  sleep 1
done