# AWS KMS Grants

This code repo demonstrates the usage of KMS [_grants_][1]. As per the documentation:

> A grant is a policy instrument that allows AWS principals to use KMS keys in cryptographic operations.
> 
>
> Grants are commonly used by AWS services that integrate with AWS KMS to encrypt your data at rest. The service creates a grant on behalf of a user in the account, uses its permissions, and retires the grant as soon as its task is complete.

There are two scenarios in this repository:
- In [conjunction with S3][2]. To reduce costs with SSE-KMS we'll be using [Amazon S3 Buckets Keys][3].
- Hands-on using AWS CLI to `Create`, `Retire`, and `Revoke` grants.

Grants can take up to 5 minutes to achieve eventual consistency. For immediate use, it's necessary to use a grant token.

## Apply

Create the infrastructure:

```sh
terraform init
terraform apply -auto-approve
```

This will create the required demonstration resources.

## S3 grants

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

## AWS CLI

This section implements this [hands-on video][4] steps.

The following resources will be configured for this hands-on:

- IAM users: `AdminPrin`, `RetirePrin`, and `GranteePrin`
- KMS Key
- EC2 instance with the AWS CLI installed
- `AdminPrin` will be granted administrator privileges to the KMS key
- ⚠️ `AdminPrin` will be granted `AdministratorAccess`

### Hands-on

#### Create the grants

Connect to the EC2 instance and set up the `AdminPrin` user:

```sh
aws configure
```

Now create the grants for the exercise.

> ℹ️ Note: Copy the Grant Token and Grant ID

Create a grant providing the Grantee Principal the ability to generate a data key:

```sh
aws kms create-grant \
    --key-id <<KEY ID>> \
    --grantee-principal <<ARN of GranteePrin>> \
    --operations GenerateDataKey \
    --retiring-principal <<ARN of RetirePrin>> \
    --constraints EncryptionContextSubset={Department=IT}
```

Create a grant providing the Grantee Principal the ability to decrypt:

```sh
aws kms create-grant \
    --key-id <<KEY ID>> \
    --grantee-principal <<ARN of GranteePrin>> \
    --operations Decrypt \
    --retiring-principal <<ARN of RetirePrin>> \
    --constraints EncryptionContextSubset={Department=Finance}
```

#### Use the grants

Configure `GranteePrin`:

```sh
aws configure
```

Generate a Data Key:

> 💡 Note: If eventual consistency is not achieved yet, you can add `--grant-token <<GRANT TOKEN>>`

```sh
aws kms generate-data-key \
    --key-id <<KEY ID>> \
    --key-spec AES_256 \
    --encryption-context Department=IT
```

#### Retire a grant

Configure `RetirePrin`:

```sh
aws configure
```

Retire the grant:

```sh
aws kms retire-grant --key-id <<KEY ARN>> --grant-token <<GRANT-TOKEN>>
```

#### Revoke grants

Configure `AdminPrin` again:

```sh
aws configure
```

List the existing grants:

```sh
aws kms list-grants --key-id <<KEY ARN>>
```

Revoke the `Decrypt` grant:

```sh
aws kms revoke-grant --key-id <<KEY ARN>> --grant-id <<GRANT ID>>
```

---

### Clean-up

Destroy the resources:

```
terraform destroy -auto-approve
```

[1]: https://docs.aws.amazon.com/kms/latest/developerguide/grants.html
[2]: https://docs.aws.amazon.com/kms/latest/developerguide/services-s3.html
[3]: https://docs.aws.amazon.com/AmazonS3/latest/userguide/bucket-key.html
[4]: https://youtu.be/lmG360mNYyA
