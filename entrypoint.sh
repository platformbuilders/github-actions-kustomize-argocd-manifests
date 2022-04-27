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
    git clone $GITOPS_REPO_FULL_URL -b release
    cd $1
    git config --local user.email "action@github.com"
    git config --local user.name "GitHub Action"
    echo "Repo $1 cloned!!!"

    printf "\033[0;32m============> Develop branch Kustomize step - HML Overlay \033[0m\n"
    cd k8s/$5/overlays/hml
    kustomize edit set image IMAGE=gcr.io/$4/$5:$RELEASE_VERSION
    echo "Done!!"

    printf "\033[0;32m============> Git commit and push \033[0m\n"
    cd ../..
    git commit -am "$6 has Built a new version: $RELEASE_VERSION"
    git push origin release
    git checkout homolog
    git merge release
    git push origin homolog

elif [[ "$GITOPS_BRANCH" == "main" ]]; then
    printf "\033[0;36m================================================================================================================> Condition 3: New release PRD environment \033[0m\n"
    printf "\033[0;32m============> Cloning $1 - Branch: $GITOPS_BRANCH \033[0m\n"
    GITOPS_REPO_FULL_URL="https://$3:x-oauth-basic@$2"
    git clone $GITOPS_REPO_FULL_URL -b release
    cd $1
    git config --local user.email "action@github.com"
    git config --local user.name "GitHub Action"
    echo "Repo $1 cloned!!!"

    printf "\033[0;32m============> Kustomize step - PRD Overlay \033[0m\n"
    cd k8s/$5/overlays/prd
    kustomize edit set image IMAGE=gcr.io/$4/$5:$RELEASE_VERSION
    echo "Done!!"

    cd ../..
    git commit -am "$6 has Built a new version: $RELEASE_VERSION"
    git push origin release
    git checkout master
    git merge release
    git push origin master
else
    printf "\033[0;32m============> No Way \033[0m\n"
fi
