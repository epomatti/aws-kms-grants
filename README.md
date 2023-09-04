# AWS KMS Grants

This code repo demonstrates the usage of KMS [_grants_][1]. As per the documentation:

> A grant is a policy instrument that allows AWS principals to use KMS keys in cryptographic operations.

More specifically:

> Grants are commonly used by AWS services that integrate with AWS KMS to encrypt your data at rest. The service creates a grant on behalf of a user in the account, uses its permissions, and retires the grant as soon as its task is complete.

In this example, grants will be used in [conjunction with S3][2]. To reduce costs with SSE-KMS we'll be using [Amazon S3 Buckets Keys][3].

## Running the code

Create the infrastructure:

```sh
terraform init
terraform apply -auto-approve
```

Check the KMS key permission statement for IAM user `John`, which should be the following:

```json
{
  "Sid": "Allow attachment of persistent resources",
  "Effect": "Allow",
  "Principal": {
      "AWS": "arn:aws:iam::000000000000:user/John"
  },
  "Action": [
      "kms:CreateGrant",
      "kms:ListGrants",
      "kms:RevokeGrant"
  ],
  "Resource": "*",
  "Condition": {
      "StringEquals": {
          "kms:ViaService": [
              "ec2.us-east-2.amazonaws.com",
              "rds.us-east-2.amazonaws.com",
              "s3.us-east-2.amazonaws.com"
          ]
      }
  }
}
```

IAM user `John` has no other permissions other than IAM `Readonly` for ease of development.




[1]: https://docs.aws.amazon.com/kms/latest/developerguide/grants.html
[2]: https://docs.aws.amazon.com/kms/latest/developerguide/services-s3.html
[3]: https://docs.aws.amazon.com/AmazonS3/latest/userguide/bucket-key.html
