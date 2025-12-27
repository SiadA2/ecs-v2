# ECS URL-Shortener

![Terraform](https://img.shields.io/badge/Terraform-7B42BC?style=flat&logo=terraform&logoColor=white)
![Docker](https://img.shields.io/badge/Docker-2496ED?style=flat&logo=docker&logoColor=white)
![AWS](https://img.shields.io/badge/AWS-232F3E?style=flat&logo=amazon-aws&logoColor=white)

 
## Contents

- [Overview](#overview)
- [Key Features](#vision)
- [GitLab Flow](#branching-strategies)
- [Directory Structure](#directory-structure)


## Overview

This is an end-to-end, multi-cloud deployment of a URL-shortener. This URL-shortener takes a long url, shortens it and stores the shortened url in DynamoDB to be reused. 

It runs on AWS Fargate, deployed via blue/green. 


## Key features

- **CodeDeploy:** Automates **Blue/Green** deployment, facilitating seamless rollover/rollback.
- **Web App Firewall (WAF):** Placed infront of the ALB, filtering inbound HTTP/S traffic, hardening the cloud against OSI Layer 7 attacks such as DDoS.
- **Open ID Connect (OIDC):** Replaces long-lived access keys and removes the risk of credential-based attacks. Also enforces privellege of least-access.
- **Cloud-native DNS:** Root domain handled by CloudFlare with subdomain delegation to Amazon Route 53, allowing for resuability across several cloud providers.
- **VPC Endpoints:** Optimises cloud cost and enforces privellege of least-access by replacing NAT Gateways, only ensuring connectivity to other services.

## Terraform State Management

- **Bootstrap:** Backend is configured locally for this stage only and is used to create the infrastructure need for cross-collaboration (S3 buckets, ECR, IAM roles)
- **Backend:** Backends for dev, staging and prod are configured remotely in seperate S3 buckets to make tracking resources easier.
- Versioning enabled in the bucket for quick rollback and the backend is 


## GitLab Flow

1. Developers work on code in ```feature``` branches. Pushes here trigger build & deploy workflows for the **dev** environment.
2. When developers are happy with their code, PRs are raised to the ```main``` branch. This triggers build & deploy workflows for the staging environment, allowing other teams to accurately test & review code.
3. On successful review, ```feature``` branches are merged to ```main```, triggering the final build & deploy workflows for production.

### Dev:

### Staging:

### Prod:




## Directory Structure

```bash 
├── .github/workflows
├── app
│   └── Dockerfile
└── terraform
    ├── bootstrap/
    ├── dev/
    ├── prod/
    └── staging/
```

## Demo