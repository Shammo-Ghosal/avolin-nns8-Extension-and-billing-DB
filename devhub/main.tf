terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

#declare variables for Access Keys and Environments

variable "AWS_ACCESS_KEY" {
  type = string
}

variable "AWS_SECRET_KEY" {
  type = string
}

variable "Environment" {
  type = string
}

# Configure the AWS Provider
provider "aws" {
  region     = "us-west-2"
  access_key = "var.AWS_ACCESS_KEY"
  secret_key = "var.AWS_SECRET_KEY"
}

#Configure Dynamo DB tables

resource "aws_dynamodb_table" "Billing-dev-local" {
  name           = "Billing-dev-${var.Environment}-local"
  billing_mode   = "PROVISIONED"
  read_capacity  = 5
  write_capacity = 5
  hash_key       = "id"
  stream_enabled   = true
  stream_view_type = "NEW_AND_OLD_IMAGES"

  attribute {
    name = "id"
    type = "S"
  }

  attribute {
    name = "currentSubscriptionId"
    type = "S"
  }

  global_secondary_index {
    name               = "index_current_subscription_id"
    hash_key           = "currentSubscriptionId"
    write_capacity     = 5
    read_capacity      = 5
    projection_type    = "KEYS_ONLY"
  }

  tags = {
    Name        = "Billing-dev-local"
    Environment = "var.Environment"
  }
}

resource "aws_dynamodb_table" "BillingCache-dev-local" {
  name           = "BillingCache-dev-${var.Environment}-local"
  billing_mode   = "PROVISIONED"
  read_capacity  = 5
  write_capacity = 5
  hash_key       = "id"

  attribute {
    name = "id"
    type = "S"
  }

  tags = {
    Name        = "BillingCache-dev-local"
    Environment = "var.Environment"
  }
}

resource "aws_dynamodb_table" "CurrentBillingUsage-dev-local" {
  name           = "CurrentBillingUsage-dev-${var.Environment}-local"
  billing_mode   = "PROVISIONED"
  read_capacity  = 5
  write_capacity = 5
  hash_key       = "billingId-planId"
  stream_enabled   = true
  stream_view_type = "NEW_AND_OLD_IMAGES"

  attribute {
    name = "billingId-planId"
    type = "S"
  }

  tags = {
    Name        = "CurrentBillingUsage-dev-local"
    Environment = "var.Environment"
  }
} 

resource "aws_dynamodb_table" "ExtensionData-dev" {
  name           = "ExtensionData-dev-${var.Environment}"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "extensionId+merchantId"
  range_key      = "objectType+objectId"

  attribute {
    name = "extensionId+merchantId"
    type = "S"
  }

  attribute {
    name = "objectType+objectId"
    type = "S"
  }

  tags = {
    Name        = "ExtensionData-dev"
    Environment = "var.Environment"
  }
} 

resource "aws_dynamodb_table" "ExtensionDefinitions-dev" {
  name           = "ExtensionDefinitions-dev-${var.Environment}"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "id"

  attribute {
    name = "id"
    type = "S"
  }

  tags = {
    Name        = "ExtensionDefinitions-dev"
    Environment = "var.Environment"
  }
} 

resource "aws_dynamodb_table" "HistoricalBillingUsage-dev-local" {
  name           = "HistoricalBillingUsage-dev-${var.Environment}-local"
  billing_mode   = "PROVISIONED"
  read_capacity  = 5
  write_capacity = 5
  hash_key       = "billingId-planId"
  range_key      = "invoiceDate"
  stream_enabled   = true
  stream_view_type = "NEW_AND_OLD_IMAGES"

  attribute {
    name = "billingId-planId"
    type = "S"
  }

   attribute {
    name = "invoiceDate"
    type = "N"
  }

  tags = {
    Name        = "HistoricalBillingUsage-dev-local"
    Environment = "var.Environment"
  }
} 

resource "aws_dynamodb_table" "LicenseKey-dev-local" {
  name           = "LicenseKey-dev-${var.Environment}-local"
  billing_mode   = "PROVISIONED"
  read_capacity  = 5
  write_capacity = 5
  hash_key       = "id"

  attribute {
    name = "id"
    type = "S"
  }

   attribute {
    name = "requestId"
    type = "S"
  }

  global_secondary_index {
    name               = "index_request_id"
    hash_key           = "requestId"
    write_capacity     = 5
    read_capacity      = 5
    projection_type    = "KEYS_ONLY"
  }

  tags = {
    Name        = "LicenseKey-dev-local"
    Environment = "var.Environment"
  }
} 








