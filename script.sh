AUTH=`echo -n aniccadeveloper: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 | base64`
echo $AUTH
echo '{"auths":{"ghcr.io":{"auth":$AUTH}}}' | kubectl create secret generic dockerconfigjson-github-com --from-file=.dockerconfigjson=/dev/stdin
