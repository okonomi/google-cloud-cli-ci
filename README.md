# Google Cloud CLI for CI/CD

Google Cloud CLI container image for CI/CD.

## Example

In `.gitlab-ci.yml`:

```yml
gcloud_test:
  stage: test
  image: ghcr.io/okonomi/google-cloud-cli-ci:latest
  script:
    - gcloud version
```
