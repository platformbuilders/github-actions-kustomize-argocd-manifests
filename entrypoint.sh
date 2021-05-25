#!/bin/sh -l
          
if [[ "$GITOPS_BRANCH" == "develop" ]]; then
    printf "\033[0;32m============> Cloning $1 - Branch: $GITOPS_BRANCH \033[0m\n"
    GITOPS_REPO_FULL_URL="https://$3:x-oauth-basic@$2"
    git clone $GITOPS_REPO_FULL_URL -b $GITOPS_BRANCH
    cd $1
    git config --local user.email "action@github.com"
    git config --local user.name "GitHub Action"
    echo "Repo $1 cloned!!!"

    printf "\033[0;32m============> Develop Kustomize step \033[0m\n"
    cd k8s/$5/overlays/dev
    sed -i "s/version:.*/version: $RELEASE_VERSION/g" datadog-env-patch.yaml
    kustomize edit set image IMAGE=gcr.io/$4$5:$RELEASE_VERSION
    cat kustomization.yaml

    printf "\033[0;32m============> Git push: Branch develop \033[0m\n"
    cd ../..
    git commit -am "$6 has Built: $7 - $RELEASE_VERSION"
    git push 

    printf "\033[0;32m============> Homolog Kustomize step \033[0m\n"
    cd overlays/dev
    git checkout release
    sed -i "s/version:.*/version: $RELEASE_VERSION/g" datadog-env-patch.yaml
    kustomize edit set image IMAGE=gcr.io/$4$5:$RELEASE_VERSION
    cat kustomization.yaml

    printf "\033[0;32m============> Git push: Branch release \033[0m\n"
    cd ../..
    git commit -am "$6 has Built: $7 - $RELEASE_VERSION"
    git push 
    
# elif [[ "$BRANCH" == "develop" ]]; then
#     cd $1/k8s$5/overlays/homolog
#     sed -i "s/version:.*/version: $RELEASE_VERSION/g" datadog-env-patch.yaml
#     kustomize edit set image IMAGE=gcr.io/$4$5:$RELEASE_VERSION

#     cd ..
#     cd prod
#     sed -i "s/version:.*/version: $RELEASE_VERSION/g" datadog-env-patch.yaml
#     kustomize edit set image IMAGE=gcr.io/$4$5:$RELEASE_VERSION
fi