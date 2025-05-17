#!/data/data/com.termux/files/usr/bin/bash


# Requiere curl y jq (instálalos con: pkg install curl jq)

clear


echo -e "\e[31m
╭━━━┳╮╱╭┳━━━┳━━━┳━━━┳╮╭╮╭╮
┃╭━╮┃┃╱┃┃╭━╮┣╮╭╮┃╭━╮┃┃┃┃┃┃
┃╰━━┫╰━╯┃┃╱┃┃┃┃┃┃┃╱┃┃┃┃┃┃┃
╰━━╮┃╭━╮┃╰━╯┃┃┃┃┃┃╱┃┃╰╯╰╯┃
┃╰━╯┃┃╱┃┃╭━╮┣╯╰╯┃╰━╯┣╮╭╮╭╯
╰━━━┻╯╱╰┻╯╱╰┻━━━┻━━━╯╰╯╰╯\e[0m"

echo -e "\e[1;30mTester de bins\e[0m"

echo "=============================="
echo "   Consultar BIN y Generar CC"
echo "=============================="
read -p "Introduce el BIN (6-8 dígitos): " BIN

# Validar el BIN
if [[ ! "$BIN" =~ ^[0-9]{6,8}$ ]]; then
  echo "BIN inválido. Debe tener entre 6 y 8 dígitos numéricos."
  exit 1
fi

# Obtener datos del BIN desde binlist.net
echo -e "\n[+] Consultando BIN..."
RESPONSE=$(curl -s "https://lookup.binlist.net/$BIN")

if echo "$RESPONSE" | grep -q "error"; then
  echo "No se encontraron datos para ese BIN."
  exit 1
fi

# Parsear datos
PAIS=$(echo "$RESPONSE" | jq -r '.country.name')
BANDERA=$(echo "$RESPONSE" | jq -r '.country.emoji')
ESQUEMA=$(echo "$RESPONSE" | jq -r '.scheme')
TIPO=$(echo "$RESPONSE" | jq -r '.type')
BANCO=$(echo "$RESPONSE" | jq -r '.bank.name')

# Mostrar datos
echo -e "\n[+] Datos del BIN:"
echo "Banco   : $BANCO"
echo "Esquema : $ESQUEMA"
echo "Tipo    : $TIPO"
echo "País    : $PAIS $BANDERA"

# Generar 10 tarjetas
echo -e "\n[+] Generando 10 tarjetas con el BIN $BIN..."

for i in $(seq 1 10); do
  RESTO=$((16 - ${#BIN}))
  RANDOM_NUM=$(cat /dev/urandom | tr -dc '0-9' | head -c "$RESTO")
  CC="$BIN$RANDOM_NUM"
  echo "$i) $CC"
done

echo -e "\n[!] Script finalizado."