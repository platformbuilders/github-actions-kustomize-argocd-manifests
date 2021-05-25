#!/bin/sh -l

echo $1
echo $2

# printf "============> Git config step"
# git config --local user.email "action@github.com"
# git config --local user.name "GitHub Action"
          
# if [[ "$BRANCH" == "develop" ]]; then
#     printf "============> Cloning ${gitops-repo-url} - Branch: $BRANCH"
#     git clone https://${TOKENNNN}:x-oauth-basic@${gitops-repo-url} -b $BRANCH
    
#     printf "============> Develop Kustomize step"
#     cd <TROCAR>/k8s/${{ secrets.APP_ID }}/overlays/dev
#     sed -i "s/version:.*/version: ${{ env.RELEASE_VERSION }}/g" datadog-env-patch.yaml
#     kustomize edit set image IMAGE=gcr.io/${{ secrets.GCP_PROJECT_ID_PROD }}/${{ secrets.APP_ID }}:${{ env.RELEASE_VERSION }}

#     printf "============> Homolog Kustomize step"
#     git checkout homolog
#     sed -i "s/version:.*/version: ${{ env.RELEASE_VERSION }}/g" datadog-env-patch.yaml
#     kustomize edit set image IMAGE=gcr.io/${{ secrets.GCP_PROJECT_ID_PROD }}/${{ secrets.APP_ID }}:${{ env.RELEASE_VERSION }}


# elif [[ "$BRANCH" == "develop" ]]; then
#     cd <TROCAR>/k8s/${{ secrets.APP_ID }}/overlays/homolog
#     sed -i "s/version:.*/version: ${{ env.RELEASE_VERSION }}/g" datadog-env-patch.yaml
#     kustomize edit set image IMAGE=gcr.io/${{ secrets.GCP_PROJECT_ID_PROD }}/${{ secrets.APP_ID }}:${{ env.RELEASE_VERSION }}

#     cd ..
#     cd prod
#     sed -i "s/version:.*/version: ${{ env.RELEASE_VERSION }}/g" datadog-env-patch.yaml
#     kustomize edit set image IMAGE=gcr.io/${{ secrets.GCP_PROJECT_ID_PROD }}/${{ secrets.APP_ID }}:${{ env.RELEASE_VERSION }}
# fi