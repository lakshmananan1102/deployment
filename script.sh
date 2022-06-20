export AKDC_CLUSTER=ch-bradenton-6489
export AKDC_REPO=aniccadeveloper/Gitops-pipeline
export AKDC_PAT=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
export AKDC_BRANCH=voe-app

flux bootstrap git \
--url "https://github.com/$AKDC_REPO" \
--branch main \
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
--path "./deploy/apps/$AKDC_CLUSTER" \
--prune true \
--interval 1m

flux reconcile source git gitops