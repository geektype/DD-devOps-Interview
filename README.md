# DD DevOps Interview Test

## `default_vpc_cleanup/`

Directory contains a python script with a `requirements` file. To run, ensure that aws
credentials are setup by either using

```shell
aws configure
```

or manually setting them in script. Python version tested was `3.8.5`, but it should work for all releases supported by the boto3 client.

```shell
python3 -m venv env
source env/bin/activate
pip install -r requirements.txt
python main.py
```

**NOTE:** Running this script will _delete_ the default VPC in the account and its dependants for all regions without confirmation!

## `main.tf`

Contains code to setup terraform and aws provider.It also contains a referece to all modules and their input variabls.

## Modules

### `cloud_watch`

This module sets up a cloud watch group for cloud trail to dump logs in to. Additionally it contains 3 metrics with their associated filters and alarms to monitor 3 key security related events:

- `nonMFA_signin` - All console users shoul ideally use MFA signins and if its is not happening it opens a security vulnerability where a leaked password could give an attacker entry to AWS account.
- `rootAccount_usage` - Like most system it is ill-adviced to use the root account as it give unregulated privellage to all resources
- `unauthorised_api_call` - If an existing user or an non authenticated account tries to access resources it doesnt have access to, this metric will increment. If there is a high occurance of unauthorised calls then it could be a strong indicator of an active attack

### `cloudtrail`

This module sets up a cloud trail which spans all regions. It collect global metrics related to account access and dumps the event in to an s3 bucket and a cloudWatch log group. It has access to the log group through an IAM role.

### `CMK`

This module creates a KMS customer managed key. This key is used by cloud trail to encrypt logs which are stored in s3. The access to this key is only limited to the cloud trail resource.

### `s3_buckets`

This module creates 2 buckets with relevant policies. The first one is to store the events sent by Cloud Trail. The second one stores all access logs to the cloud trail bucket. Both buckets block public access

### `SNS`

This module creates an SNS topic which is in turn used by CloudWatch to publish alarms to. The subscribers have the type of email.

## Usage

```shell
terraform init
terraform plan -out plans/initPlan
terraform apply plans/initPlan
```
