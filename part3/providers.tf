### Providers
### file:providers.tf
### Credentials for different providers we will use.

provider "aws" {
  # You can delete this entry if you have it defined in ~/.aws/credentials
  # file or if you export AWS_DEFAULT_REGION as environment variable
  region     = "<YOUR REGION HERE>"

  # You can delete these entries if you have ~/.aws/credentials file
  # or you export AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY
  access_key = "<YOUR KEY HERE>"
  secret_key = "<YOUR SECRET HERE>"
}
