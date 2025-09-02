# Standard Platform - Terraform Module 🚀🚀
<p align="right"><a href="https://partners.amazonaws.com/partners/0018a00001hHve4AAC/GoCloud"><img src="https://img.shields.io/badge/AWS%20Partner-Advanced-orange?style=for-the-badge&logo=amazonaws&logoColor=white" alt="AWS Partner"/></a><a href="LICENSE"><img src="https://img.shields.io/badge/License-Apache%202.0-green?style=for-the-badge&logo=apache&logoColor=white" alt="LICENSE"/></a></p>

Welcome to the Standard Platform — a suite of reusable and production-ready Terraform modules purpose-built for AWS environments.
Each module encapsulates best practices, security configurations, and sensible defaults to simplify and standardize infrastructure provisioning across projects.

## 📦 Module: Terraform AWS Backup Module
<p align="right"><a href="https://github.com/gocloudLa/terraform-aws-wrapper-aws-backup/releases/latest"><img src="https://img.shields.io/github/v/release/gocloudLa/terraform-aws-wrapper-aws-backup.svg?style=for-the-badge" alt="Latest Release"/></a><a href=""><img src="https://img.shields.io/github/last-commit/gocloudLa/terraform-aws-wrapper-aws-backup.svg?style=for-the-badge" alt="Last Commit"/></a><a href="https://registry.terraform.io/modules/gocloudLa/wrapper-aws-backup/aws"><img src="https://img.shields.io/badge/Terraform-Registry-7B42BC?style=for-the-badge&logo=terraform&logoColor=white" alt="Terraform Registry"/></a></p>
The Terraform wrapper for AWS Backup simplifies the configuration and management of backup policies in the AWS cloud. This wrapper functions as a predefined template, facilitating the creation of backup plans and policies.

### ✨ Features




## 🚀 Quick Start
```hcl
aws_backup_parameters = {
        "00" = {
            force_destroy = true
        }
    }
```


## 🔧 Additional Features Usage



## 📑 Inputs
| Name          | Description                         | Type     | Default                             | Required |
| ------------- | ----------------------------------- | -------- | ----------------------------------- | -------- |
| create_enable | Enable or disable resource creation | `bool`   | `true`                              | no       |
| vault_name    | Name of the vault                   | `string` | `t${local.common_name}-${each.key}` | no       |
| force_destroy | Force destroy of the resource       | `bool`   | `false`                             | no       |
| kms_key_arn   | ARN of the KMS key                  | `string` | `null`                              | no       |
| backup_plan   | Configuration for the backup plan   | `map`    | `{}`                                | no       |








---

## 🤝 Contributing
We welcome contributions! Please see our contributing guidelines for more details.

## 🆘 Support
- 📧 **Email**: info@gocloud.la
- 🐛 **Issues**: [GitHub Issues](https://github.com/gocloudLa/issues)

## 🧑‍💻 About
We are focused on Cloud Engineering, DevOps, and Infrastructure as Code.
We specialize in helping companies design, implement, and operate secure and scalable cloud-native platforms.
- 🌎 [www.gocloud.la](https://www.gocloud.la)
- ☁️ AWS Advanced Partner (Terraform, DevOps, GenAI)
- 📫 Contact: info@gocloud.la

## 📄 License
This project is licensed under the Apache 2.0 License - see the [LICENSE](LICENSE) file for details. 