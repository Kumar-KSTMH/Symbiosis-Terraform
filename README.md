## 🏠 Architecture
![Architecture diagram](Symbiosis-3Tier.png)

### Create S3 Backend Bucket
Create an S3 bucket to store the .tfstate file in the remote backend

**Warning!** It is highly recommended that you `enable Bucket Versioning` on the S3 bucket to allow for state recovery in the case of accidental deletions and human error.

**Note**: We will need this bucket name in the later step

### Create a Dynamo DB table for state file locking
- Give the table a name
- Make sure to add a `Partition key` with the name `LockID` and type as `String`

### Generate a public and private key pair for our instances
We need a public key and a private key for our server so please follow the procedure I've included below.
---
cd modules/key/
ssh-keygen
---

The above command asks for the key name and then gives `client_key` it will create a pair of keys one public and one private. you can give any name you want but then you need to edit the Terraform file

Edit the below file according to your configuration
Add the below code in root/backend.tf

terraform {
  backend "s3" {
    bucket = "BUCKET_NAME"
    key    = "dev/FILE_NAME_TO_STORE_STATE.tfstate"
    region = "ap-southeast-1"
    dynamodb_table = "dynamoDB_TABLE_NAME"
  }
}
---

### 🔐 ACM certificate
Go to AWS console --> AWS Certificate Manager (ACM) and make sure you have a valid certificate in Issued status, if not, feel free to create one and use the domain name on which you are planning to host your application.

### 👨‍💻 Route 53 Hosted Zone
Go to AWS Console --> Route53 --> Hosted Zones and ensure you have a public hosted zone available, if not create one.
---
Add the below content into the `root/dev.tfvars` file and add the values of each variable.

ami_id           = ""
aws_region       = ""
project_name     = ""
environment      = ""
public_key_path  = ""
vpc_cidr         = ""
azs              = []
web_subnet_cidrs = []
app_subnet_cidrs = []
db_subnet_cidrs  = []
instance_type    = ""
key_name         = ""
db_username      = ""
db_password      = ""
certificate_domain_name = ""
additional_domain_name = ""

---
## ✈️ Now we are ready to deploy our application on the cloud ⛅
get into the project directory 
---
cd symbiosis-iac\root
---
👉 let install dependency to deploy the application 

terraform init 
Type the below command to see the plan of the execution 
terraform plan
✨Finally, HIT the below command to deploy the application...
terraform apply 
Type `yes`, and it will prompt you for approval..
---
Step 1: Download Code from GitHub in Your Local System
---
Step 2: Create IAM Role with Policies
SSM managed instance core.
---
Step 3: Create VPC, IGW, RT,Subnets, NAT-GW
Enable auto-assign public IP for web-tier public subnets.
---
Step 4: Create Security Groups
External-Load-Balancer-SG --> HTTP (80): 0.0.0.0/0.
Web-SG --> HTTP --> Web-LB-SG.
Internal-Load-Balancer-SG --> HTTP --> Web-SG.
App-SG --> Port 3000 --> App-LB-SG.
DB-SG --> MySQL (3306) --> App-SG.
---
Step 5: Create DB Subnet Group & RDS
Create DB subnet group.
Create RDS - Multi-AZ.
Place them in DB subnet group created above.
---
Step 6: Create Test App Server, Install Packages, Test Connections
Test App-Server Commands
Create AMI.
Create launch template using AMI.
Create target group.
Create internal load balancer.
Create autoscaling group.
Edit nginx.conf file in local system by adding Internal-app-LB-DNS.
---
Step 7: Create Test Web Server, Install Packages (Nginx, Node.js), Test Connections
Test Web-Server Commands
Create AMI.
Create launch template using AMI.
Create target group.
Create external load balancer.
Create autoscaling group.
---
Step 9: Add External-ALB-DNS Record in Route 53
---
Step 10: Create CloudWatch Alarms Along with SNS
---
Step 11: Create CloudTrail
---
**Thank you so much for reading..😅**
