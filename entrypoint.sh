#!/bin/sh -l
          
if [[ "$GITOPS_BRANCH" == "develop" ]]; then
    printf "\033[0;32m============> Cloning $1 - Branch: $GITOPS_BRANCH \033[0m\n"
    GITOPS_REPO_FULL_URL="https://$3:x-oauth-basic@$2"
    git clone $GITOPS_REPO_FULL_URL -b $GITOPS_BRANCH
    cd $1
    git config --local user.email "action@github.com"
    git config --local user.name "GitHub Action"
    echo "Repo $1 cloned!!!"

    ############################################################################################## Develop Kustomize - DEV Overlays
    printf "\033[0;32m============> Develop branch Kustomize step - DEV Overlay \033[0m\n"
    cd k8s/$5/overlays/dev
    sed -i "s/version:.*/version: $RELEASE_VERSION/g" datadog-env-patch.yaml
    kustomize edit set image IMAGE=gcr.io/$4$5:$RELEASE_VERSION
    echo "Done!!"

    printf "\033[0;32m============> Git push: Branch develop \033[0m\n"
    cd ../..
    git commit -am "$6 has Built a new version: $RELEASE_VERSION"
    git push 

    ############################################################################################## Release Kustomize - DEV Overlays
    printf "\033[0;32m============> Release branch Kustomize step - DEV Overlay \033[0m\n"
    cd overlays/dev
    git checkout release
    sed -i "s/version:.*/version: $RELEASE_VERSION/g" datadog-env-patch.yaml
    kustomize edit set image IMAGE=gcr.io/$4$5:$RELEASE_VERSION
    echo "Done!!"

    printf "\033[0;32m============> Git push: Branch release \033[0m\n"
    cd ../..
    git commit -am "$6 has Built a new version: $RELEASE_VERSION"
    git push 
    
elif [[ "$GITOPS_BRANCH" == "release" ]]; then    
    printf "\033[0;32m============> Cloning $1 - Branch: $GITOPS_BRANCH \033[0m\n"
    GITOPS_REPO_FULL_URL="https://$3:x-oauth-basic@$2"
    git clone $GITOPS_REPO_FULL_URL -b $GITOPS_BRANCH
    cd $1
    git checkout release
    git config --local user.email "action@github.com"
    git config --local user.name "GitHub Action"    
    echo "Repo $1 cloned!!!"

    ############################################################################################## Release Kustomize - HML and PRD Overlays
    printf "\033[0;32m============> Release branch Kustomize step - HML Overlay \033[0m\n"
    cd k8s/$5/overlays/homolog
    sed -i "s/version:.*/version: $RELEASE_VERSION/g" datadog-env-patch.yaml
    kustomize edit set image IMAGE=gcr.io/$4$5:$RELEASE_VERSION
    echo "Done!!"

    printf "\033[0;32m============> Release branch Kustomize step - PRD Overlay \033[0m\n"
    cd ../prod
    sed -i "s/version:.*/version: $RELEASE_VERSION/g" datadog-env-patch.yaml
    kustomize edit set image IMAGE=gcr.io/$4$5:$RELEASE_VERSION
    echo "Done!!"

    printf "\033[0;32m============> Git commit,push and open PR to Master: Branch release \033[0m\n"
    cd ../..
    git commit -am "$6 has Built a new version: $RELEASE_VERSION"
    git push

    export GITHUB_TOKEN=$3
    gh pr create --head release --base master -t "GitHub Actions: Automatic PR opened by $6 - $RELEASE_VERSION" --body "GitHub Actions: Automatic PR opened by $6 - $RELEASE_VERSION"

    ############################################################################################## Develop Kustomize - HML Overlays
    printf "\033[0;32m============> Develop branch Kustomize step - HML Overlay \033[0m\n"
    cd overlays/homolog
    git checkout develop
    sed -i "s/version:.*/version: $RELEASE_VERSION/g" datadog-env-patch.yaml
    kustomize edit set image IMAGE=gcr.io/$4$5:$RELEASE_VERSION
    echo "Done!!"

    printf "\033[0;32m============> Develop branch Kustomize step - PRD Overlay \033[0m\n"
    cd ../prod
    sed -i "s/version:.*/version: $RELEASE_VERSION/g" datadog-env-patch.yaml
    kustomize edit set image IMAGE=gcr.io/$4$5:$RELEASE_VERSION
    echo "Done!!"

    git commit -am "$6 has Built a new version: $RELEASE_VERSION"
    git push

    printf "\033[0;32m============> GOING BACK TO RELEASE \033[0m\n"
    git checkout release
fi