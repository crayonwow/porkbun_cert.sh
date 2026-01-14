source .env

if [ $# -eq 0 ]; then
  echo "Err: no domain in argument"
  exit 1
fi

domain=$1

curl \
  --request POST \
  --header "Content-Type: application/json" \
  --data '{"secretapikey": "'"$SK"'","apikey": "'"$AK"'"}' \
  https://api.porkbun.com/api/json/v3/ssl/retrieve/$domain >res

if [ $(jq .status res | sed -e "s/^\"//" -e "s/\"$//") != "SUCCESS" ]; then
  echo "Err: bad status from porkbun"
  jq . res
  exit 1
fi

pk=$(jq .publickey res | sed -e "s/^\"//" -e "s/\"$//")
sk=$(jq .privatekey res | sed -e "s/^\"//" -e "s/\"$//")

echo $pk >pub.cert
echo $sk >private.cert

rm res
echo "✅Successfyly got certs!!!!"
