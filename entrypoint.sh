#!/bin/sh -l

gitops-repo-name=$1
gitops-repo-url=$2


printf "============> Git config step"
git config --local user.email "action@github.com"
git config --local user.name "GitHub Action"
          
if [[ "$BRANCH" == "develop" ]]; then
    printf "============> Cloning $gitops-repo-name - Branch: $BRANCH"
    git clone https://${{ secrets.GH_ACCESS_TOKEN }}:x-oauth-basic@$gitops-repo-url -b $BRANCH
    
    printf "============> Develop Kustomize step"
    cd $gitops-repo-name/k8s/${{ secrets.APP_ID }}/overlays/dev
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
#     cd $gitops-repo-name/k8s/${{ secrets.APP_ID }}/overlays/homolog
#     sed -i "s/version:.*/version: ${{ env.RELEASE_VERSION }}/g" datadog-env-patch.yaml
#     kustomize edit set image IMAGE=gcr.io/${{ secrets.GCP_PROJECT_ID_PROD }}/${{ secrets.APP_ID }}:${{ env.RELEASE_VERSION }}

#     cd ..
#     cd prod
#     sed -i "s/version:.*/version: ${{ env.RELEASE_VERSION }}/g" datadog-env-patch.yaml
#     kustomize edit set image IMAGE=gcr.io/${{ secrets.GCP_PROJECT_ID_PROD }}/${{ secrets.APP_ID }}:${{ env.RELEASE_VERSION }}
fi