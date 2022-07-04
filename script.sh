
flux bootstrap git \
--url "https://github.com/$GITOPS_REPO" \
--branch "$GITOPS_BRANCH" \
--password "$GITOPS_PAT" \
--token-auth true \
--path "./deploy/bootstrap/$GITOPS_CLUSTER"

flux create secret git gitops \
--url "https://github.com/$GITOPS_REPO" \
--password "$GITOPS_PAT" \
--username gitops

flux create source git gitops \
--url "https://github.com/$GITOPS_REPO" \
--branch "$GITOPS_BRANCH" \
--secret-ref gitops

flux create kustomization bootstrap \
--source GitRepository/gitops \
--path "./deploy/bootstrap/$GITOPS_CLUSTER" \
--prune true \
--interval 1m

flux create kustomization apps \
--source GitRepository/gitops \
--path "./deploy/apps/$GITOPS_CLUSTER" \
--prune true \
--interval 1m
