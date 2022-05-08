microk8s kubectl create secret docker-registry regcred --docker-server=ghcr.io --docker-username=aniccadeveloper --docker-password=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 --docker-email=anicca.developer@aniccadata.in

microk8s kubectl get secret regcred --output="jsonpath={.data.\.dockerconfigjson}" | base64 --decode