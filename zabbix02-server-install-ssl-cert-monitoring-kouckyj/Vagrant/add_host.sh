#!/bin/bash

# Přihlašovací údaje k Zabbix API
ZBX_URL="http://localhost/zabbix/api_jsonrpc.php"
ZBX_USER="Admin"
ZBX_PASS="zabbix"

# Získání API tokenu
AUTH_TOKEN=$(curl -s -X POST -H 'Content-Type: application/json' \
  -d "{
    \"jsonrpc\": \"2.0\",
    \"method\": \"user.login\",
    \"params\": {
      \"username\": \"${ZBX_USER}\",
      \"password\": \"${ZBX_PASS}\"
    },
    \"id\": 1
  }" $ZBX_URL | jq -r '.result')

echo "Auth token: $AUTH_TOKEN"

# Přidání hosta sposdk.cz
curl -s -X POST -H 'Content-Type: application/json' \
  -d "{
    \"jsonrpc\": \"2.0\",
    \"method\": \"host.create\",
    \"params\": {
      \"host\": \"sposdk.cz\",
      \"interfaces\": [
        {
          \"type\": 1,
          \"main\": 1,
          \"useip\": 1,
          \"ip\": \"127.0.0.1\",
          \"dns\": \"sposdk.cz\",
          \"port\": \"10050\"
        }
      ],
      \"groups\": [
        {\"groupid\": \"22\"}
      ],
      \"templates\": [
        {\"templateid\": \"10413\"}
      ],
      \"macros\": [
        {
          \"macro\": \"{\$CERT.WEBSITE.HOSTNAME}\",
          \"value\": \"sposdk.cz\",
          \"description\": \"The website DNS name for the connection.\"
        }
      ]
    },
    \"auth\": \"${AUTH_TOKEN}\",
    \"id\": 2
  }" $ZBX_URL | jq .
