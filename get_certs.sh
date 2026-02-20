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

pk=$(jq .publickey res | xargs printf "%b" >pub.cert)
sk=$(jq .privatekey res | xargs printf "%b" >private.cert)
fc=$(jq .certificatechain res | xargs printf "%b" >chain.cert)

rm res
echo "✅Successfyly got certs!!!!"
