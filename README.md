# infra-jenkins

# Jenkins Server Setup on AWS Using Terraform

This guide provides step-by-step instructions for setting up a Jenkins server on Amazon Web Services (AWS) using Terraform. Jenkins is a popular open-source automation server that helps automate the building, testing, and deployment of software.

## Prerequisites

Before you begin, ensure you have the following prerequisites in place:

1. **AWS Account**: You need an active AWS account with appropriate permissions to create resources.

2. **Terraform**: Install Terraform on your local machine. You can download it from the [official website](https://www.terraform.io/downloads.html).

## Setting Up Jenkins on AWS

Follow these steps to set up a Jenkins server on AWS using Terraform:

1. **Clone the Repository**:

   Clone the Jenkins Terraform project repository to your local machine:

   ```bash
   git clone https://github.com/yourusername/jenkins-aws-terraform.git
   cd jenkins-aws-terraform
   ```

2. **Configuration**:

   Modify the `terraform.tfvars` file to configure AWS credentials, region, and any other settings.

3. **Initialize Terraform**:

   Run the following command to initialize Terraform:

   ```bash
   terraform init
   ```

4. **Plan and Apply**:

   Run a plan to see the changes Terraform will make:

   ```bash
   terraform plan
   ```

   If the plan looks good, apply it to create the AWS resources:

   ```bash
   terraform apply
   ```

5. **Accessing Jenkins**:

   After Terraform completes, you'll see the public IP address or DNS name of the Jenkins server in the outputs. Access Jenkins using a web browser by navigating to `http://<Jenkins-IP-or-DNS>:8080`.

   You will need to retrieve the initial admin password from the server's logs to unlock Jenkins.

6. **Post-Installation Setup**:

   Follow the on-screen instructions for the Jenkins post-installation setup to configure the admin user and install recommended plugins.

7. **Start Using Jenkins**:

   Your Jenkins server is now ready for use. You can create jobs, pipelines, and integrate it into your CI/CD process.

8. **Destroy Resources (Optional)**:

   If you ever need to tear down the Jenkins server and AWS resources, you can do so using Terraform. Run:

   ```bash
   terraform destroy
   ```