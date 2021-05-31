# Kustomize ArgoCD manifests

GitHub action used kustomize applications manifests

## Inputs

- **gitops-repo-name:** The name of GitOps git repository;
- **gitops-repo-url:** The URL of GitOps repository;
- **gh_access_token:** The access token of GitOps repository;
- **gcp_project_id_prod**: The GCP project ID;
- **app_id:** The App ID;
- **github_actor:** The github commit actor ID;

**OBS.:** All inputs are **required** 

## Outputs

There are no outputs for this action

## Example usage

```yaml
      - name: Kustomize step
        uses: platformbuilders/github-actions-kustomize-argocd-manifests@master
        with:
          gitops-repo-name: '<gitops-repo-name>'
          gitops-repo-url: '< gitops-repo-url >'
          gh_access_token: ${{ secrets.GH_ACCESS_TOKEN }}
          gcp_project_id_prod: ${{ secrets.GCP_PROJECT_ID_PROD }}
          app_id: ${{ secrets.APP_ID }}
          github_actor: ${{ github.actor }}
```

