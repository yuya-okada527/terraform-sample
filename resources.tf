data "archive_file" "lambda_zip" {
  type = "zip"
  source_dir = "lambda_src"
  output_path = "lambda/lambda.zip"
}