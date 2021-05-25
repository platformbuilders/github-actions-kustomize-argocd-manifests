#!/bin/sh -l

#gitops-repo-name="$1"
#gitops-repo-url="$2"
          
if [[ "$BRANCH" == "develop" ]]; then
    printf "============> Cloning $1 - Branch: $BRANCH"
    git clone https://${{ secrets.GH_ACCESS_TOKEN }}:x-oauth-basic@$$2 -b $BRANCH    
    cd $1
    
    printf "============> Git config step"
    git config --local user.email "action@github.com"
    git config --local user.name "GitHub Action"

    printf "============> Develop Kustomize step"
    cd k8s/${{ secrets.APP_ID }}/overlays/dev
    sed -i "s/version:.*/version: ${{ env.RELEASE_VERSION }}/g" datadog-env-patch.yaml
    kustomize edit set image IMAGE=gcr.io/${{ secrets.GCP_PROJECT_ID_PROD }}/${{ secrets.APP_ID }}:${{ env.RELEASE_VERSION }}
    cat kustomization.yaml

    printf "============> Homolog Kustomize step"
    git checkout release
    sed -i "s/version:.*/version: ${{ env.RELEASE_VERSION }}/g" datadog-env-patch.yaml
    kustomize edit set image IMAGE=gcr.io/${{ secrets.GCP_PROJECT_ID_PROD }}/${{ secrets.APP_ID }}:${{ env.RELEASE_VERSION }}
    cat kustomization.yaml
    ## GIT PUSH STEPS

# elif [[ "$BRANCH" == "develop" ]]; then
#     cd $1/k8s/${{ secrets.APP_ID }}/overlays/homolog
#     sed -i "s/version:.*/version: ${{ env.RELEASE_VERSION }}/g" datadog-env-patch.yaml
#     kustomize edit set image IMAGE=gcr.io/${{ secrets.GCP_PROJECT_ID_PROD }}/${{ secrets.APP_ID }}:${{ env.RELEASE_VERSION }}

#     cd ..
#     cd prod
#     sed -i "s/version:.*/version: ${{ env.RELEASE_VERSION }}/g" datadog-env-patch.yaml
#     kustomize edit set image IMAGE=gcr.io/${{ secrets.GCP_PROJECT_ID_PROD }}/${{ secrets.APP_ID }}:${{ env.RELEASE_VERSION }}
fi