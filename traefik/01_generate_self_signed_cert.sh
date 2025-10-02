#!/bin/sh

openssl req -x509 -newkey rsa:4096 -sha256 -days 365 -nodes \
  -keyout certs/wildcard.key -out certs/wildcard.crt \
  -subj "/CN=*.internal" \
  -addext "subjectAltName=DNS:*.internal,DNS:internal"
