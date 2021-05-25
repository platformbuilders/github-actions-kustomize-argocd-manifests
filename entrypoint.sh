#!/bin/sh -l
          
if [[ "$GITOPS_BRANCH" == "develop" ]]; then
    printf "============> Cloning $1 - Branch: $GITOPS_BRANCH \n"
    GITOPS_REPO_FULL_URL="https://$3:x-oauth-basic@$2"
    git clone $GITOPS_REPO_FULL_URL -b $GITOPS_BRANCH
    cd $1
    
    printf "============> Git config step \n"
    git config --local user.email "action@github.com"
    git config --local user.name "GitHub Action"

    printf "============> Develop Kustomize step \n"
    cd k8s/$5/overlays/dev
    sed -i "s/version:.*/version: $RELEASE_VERSION/g" datadog-env-patch.yaml
    kustomize edit set image IMAGE=gcr.io/$4$5:$RELEASE_VERSION
    cat kustomization.yaml

    printf "============> Homolog Kustomize step \n"
    git checkout release
    sed -i "s/version:.*/version: $RELEASE_VERSION/g" datadog-env-patch.yaml
    kustomize edit set image IMAGE=gcr.io/$4$5:$RELEASE_VERSION
    cat kustomization.yaml
    ## GIT PUSH STEPS

# elif [[ "$BRANCH" == "develop" ]]; then
#     cd $1/k8s$5/overlays/homolog
#     sed -i "s/version:.*/version: $RELEASE_VERSION/g" datadog-env-patch.yaml
#     kustomize edit set image IMAGE=gcr.io/$4$5:$RELEASE_VERSION

#     cd ..
#     cd prod
#     sed -i "s/version:.*/version: $RELEASE_VERSION/g" datadog-env-patch.yaml
#     kustomize edit set image IMAGE=gcr.io/$4$5:$RELEASE_VERSION
fi