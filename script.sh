export AKDC_CLUSTER=store_dir
export AKDC_REPO=aniccadeveloper/Gitops-pipeline
export AKDC_PAT=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
export AKDC_BRANCH=voe-app

flux bootstrap git \
--url "https://github.com/$AKDC_REPO" \
--branch "$AKDC_BRANCH" \
--password "$AKDC_PAT" \
--token-auth true \
--path "./deploy/bootstrap/$AKDC_CLUSTER"

flux create secret git gitops \
--url "https://github.com/$AKDC_REPO" \
--password "$AKDC_PAT" \
--username gitops

flux create source git gitops \
--url "https://github.com/$AKDC_REPO" \
--branch "$AKDC_BRANCH" \
--secret-ref gitops

flux create kustomization bootstrap \
--source GitRepository/gitops \
--path "./deploy/bootstrap/$AKDC_CLUSTER" \
--prune true \
--interval 1m

flux create kustomization apps \
--source GitRepository/gitops \
--path "./deploy/services/$AKDC_CLUSTER" \
--prune true \
--interval 1m
