data "archive_file" "inner_lambda_file" {
  type = "zip"
  source_dir = "lambda_src/python"
  output_path = "lambda/lambda.zip"
}

resource "aws_lambda_function" "inner_lambda" {
  filename         = data.archive_file.inner_lambda_file.output_path
  function_name    = "local-lambda"
  role             = aws_iam_role.inner_lambda_iam_role.arn
  handler          = "lambda.lambda_function"
  runtime          = "python3.8"
  source_code_hash = filebase64sha256(data.archive_file.inner_lambda_file.output_path)
}

resource "aws_iam_role" "inner_lambda_iam_role" {
  name = "inner-lambda-iam-role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

data "aws_iam_policy_document" "iam_policy_document" {
  statement {
    actions = ["sqs:*"]
    effect = "Allow"
  }

}

# resource "aws_sqs_queue" "inner_sqs" {
#   name                        = "inner_sqs.fifo"
#   fifo_queue                  = true
#   content_based_deduplication = true
#   policy = data.aws_iam_policy_document.iam_policy_document.json
# }

# resource "aws_lambda_event_source_mapping" "inner_mapping" {
#   event_source_arn = aws_sqs_queue.inner_sqs.arn
#   function_name    = aws_lambda_function.inner_lambda.arn
# }

resource "aws_s3_bucket" "bucket1" {
  bucket = "sample-bucket"
  acl = "private"
}