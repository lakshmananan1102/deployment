microk8s kubectl create secret docker-registry regcred --docker-server=ghcr.io --docker-username=aniccadeveloper --docker-password=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 --docker-email=anicca.developer@aniccadata.in

microk8s kubectl get secret regcred --output="jsonpath={.data.\.dockerconfigjson}" | base64 --decode