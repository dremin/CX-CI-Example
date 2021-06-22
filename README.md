# CX-CI-Example

This repository is a basic example of how the [Genesys Cloud Terraform provider ("CX as Code")](https://developer.genesys.cloud/api/rest/CX-as-Code) can be used with CI such as GitHub Actions. In this example, Terraform state is stored within an AWS S3 bucket, using DynamoDB as a locking mechanism.

## Setup

### Credentials

In this example, Terraform state is stored in AWS. Each environment has its own S3 bucket for state storage and DynamoDB table for state locking, with a dedicated user per environment. The account access key ID and secret for these accounts are stored as GitHub secrets.

Terraform uses a client ID and secret, stored as GitHub secrets, to authenticate with Genesys Cloud. These can be created in Genesys Cloud by navigating to Admin > Integrations > OAuth.

To create a GitHub secret, navigate within your repository to Settings > Secrets > New repository secret. The following secrets are used in this example:

| Secret                | Purpose                                                                       |
| --------------------- | ----------------------------------------------------------------------------- |
| `DEV_AWS_KEY_ID`      | The AWS IAM user access key ID for the development/staging environment.       |
| `DEV_AWS_KEY_SECRET`  | The AWS IAM user access secret for the development/staging environment.       |
| `DEV_CLIENT_ID`       | The Genesys Cloud OAuth client ID to use for the development/staging org.     |
| `DEV_CLIENT_SECRET`   | The Genesys Cloud OAuth client secret to use for the development/staging org. |
| `PROD_AWS_KEY_ID`     | The AWS IAM user access key ID for the production environment.                |
| `PROD_AWS_KEY_SECRET` | The AWS IAM user access secret for the production environment.                |
| `PROD_CLIENT_ID`      | The Genesys Cloud OAuth client ID to use for the production org.              |
| `PROD_CLIENT_SECRET`  | The Genesys Cloud OAuth client secret to use for the production org.          |

### Other Configuration

Apart from credentials, the CI needs to know which AWS region(s), state storage bucket, and state lock table to use for each environment. By default, the GitHub action in this repository uses `us-east-1`. This configuration is set for each environment within the workflow file:

| Environment Variable  | Purpose                                                               |
| --------------------- | --------------------------------------------------------------------- |
| `AWS_REGION`          | The AWS region that hosts the state storage bucket and locking table. |
| `GENESYSCLOUD_REGION` | The AWS region that hosts the Genesys Cloud org.                      |
| `STATE_BUCKET`        | The S3 bucket name for state storage.                                 |
| `STATE_TABLE`         | The DynamoDB table name for the state lock.                           |

## Promotion Workflow

This repository contains two branches: `main` and `develop`. The GitHub action is configured to apply configuration to a different Genesys Cloud organization depending on the branch that is pushed. A basic code elevation process might look like this:

1. A developer works within their own branch.
2. The developer opens a pull request to merge into the `develop` branch, which will automatically validate their configuration.
3. After the PR is merged and pushed to `develop`, Terraform will apply the configuration to the configured development/staging Genesys Cloud org.
4. After functionality is verified in the dev org and ready to deploy to production, a pull request is opened to merge from the `develop` branch to the `main` branch.
5. After the PR is merged and pushed to `main`, Terraform will apply the configuration to the production Genesys Cloud org.
6. The new configuration is now in production.
