data "archive_file" "lambda_zip" {
  type = "zip"
  source_dir = "lambda_src/python"
  output_path = "lambda/lambda.zip"
}

resource "aws_lambda_function" "local_lambda" {
  filename         = data.archive_file.lambda_zip.output_path
  function_name    = "local-lambda"
  role             = aws_iam_role.local_lambda_iam_role.arn
  handler          = "lambda.lambda_function"
  runtime          = "python3.8"
  source_code_hash = filebase64sha256(data.archive_file.lambda_zip.output_path)
}

resource "aws_iam_role" "local_lambda_iam_role" {
  name = "local-lambda-iam-role"
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
