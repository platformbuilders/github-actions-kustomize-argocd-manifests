#!/bin/sh -l
          
if [[ "$GITOPS_BRANCH" == "develop" ]]; then
    printf "\033[0;36m================================================================================================================> Condition 1: Develop environment \033[0m\n"
    printf "\033[0;32m============> Cloning $1 - Branch: develop \033[0m\n"
    GITOPS_REPO_FULL_URL="https://$3:x-oauth-basic@$2"
    git clone $GITOPS_REPO_FULL_URL -b develop
    cd $1
    git config --local user.email "action@github.com"
    git config --local user.name "GitHub Action"
    echo "Repo $1 cloned!!!"

    printf "\033[0;32m============> Develop branch Kustomize step - DEV Overlay \033[0m\n"
    cd k8s/$5/overlays/dev
    sed -i "s/version:.*/version: '$RELEASE_VERSION'/g" datadog-env-patch.yaml
    kustomize edit set image IMAGE=gcr.io/$4/$5:$RELEASE_VERSION
    echo "Done!!"

    printf "\033[0;32m============> Git push: Branch develop \033[0m\n"
    cd ../..
    git commit -am "$6 has Built a new version: $RELEASE_VERSION"
    git push origin develop

    printf "\033[0;32m============> Merge develop in to release branch \033[0m\n"
    git checkout release
    git merge develop
    git push origin release

elif [[ "$GITOPS_BRANCH" == "homolog" ]]; then    
    printf "\033[0;36m================================================================================================================> Condition 2: Homolog environment \033[0m\n"
    printf "\033[0;32m============> Cloning $1 - Branch: release \033[0m\n"
    GITOPS_REPO_FULL_URL="https://$3:x-oauth-basic@$2"
    git clone $GITOPS_REPO_FULL_URL -b develop
    cd $1
    git config --local user.email "action@github.com"
    git config --local user.name "GitHub Action"    
    echo "Repo $1 cloned!!!"

    printf "\033[0;32m============> Develop branch Kustomize step - HML Overlay \033[0m\n"
    cd k8s/$5/overlays/homolog
    sed -i "s/version:.*/version: '$RELEASE_VERSION'/g" datadog-env-patch.yaml
    kustomize edit set image IMAGE=gcr.io/$4/$5:$RELEASE_VERSION
    echo "Done!!"

    printf "\033[0;32m============> Git commit and push \033[0m\n"
    cd ../..
    git commit -am "$6 has Built a new version: $RELEASE_VERSION"
    git push origin develop

    printf "\033[0;32m============> Merge develop in to release branch \033[0m\n"
    git checkout release
    git merge develop
    git push origin release

elif [[ "$GITOPS_BRANCH" == "release" ]]; then    
    printf "\033[0;36m================================================================================================================> Condition 3: New release (HML and PRD environment) \033[0m\n"
    printf "\033[0;32m============> Cloning $1 - Branch: $GITOPS_BRANCH \033[0m\n"
    GITOPS_REPO_FULL_URL="https://$3:x-oauth-basic@$2"
    git clone $GITOPS_REPO_FULL_URL -b develop
    cd $1
    git config --local user.email "action@github.com"
    git config --local user.name "GitHub Action"    
    echo "Repo $1 cloned!!!"

    printf "\033[0;32m============> Develop branch Kustomize step - HML Overlay \033[0m\n"
    cd k8s/$5/overlays/homolog
    sed -i "s/version:.*/version: '$RELEASE_VERSION'/g" datadog-env-patch.yaml
    kustomize edit set image IMAGE=gcr.io/$4/$5:$RELEASE_VERSION
    echo "Done!!"

    printf "\033[0;32m============> Develop branch Kustomize step - PRD Overlay \033[0m\n"
    cd ../prod
    sed -i "s/version:.*/version: '$RELEASE_VERSION'/g" datadog-env-patch.yaml
    kustomize edit set image IMAGE=gcr.io/$4/$5:$RELEASE_VERSION
    echo "Done!!"

    printf "\033[0;32m============> Git commit and push: Branch develop \033[0m\n"
    cd ../..
    git commit -am "$6 has Built a new version: $RELEASE_VERSION"
    git push origin develop

    printf "\033[0;32m============> Merge develop in to release branch \033[0m\n"
    git checkout release
    git merge develop
    git push origin release

    printf "\033[0;32m============> Open PR: release -> master \033[0m\n"
    export GITHUB_TOKEN=$3
    gh pr create --head release --base master -t "GitHub Actions: Automatic PR opened by $6 - $RELEASE_VERSION" --body "GitHub Actions: Automatic PR opened by $6 - $RELEASE_VERSION"
else
     printf "\033[0;32m============> OUTRO ERRO \033[0m\n"
fi
