resource "aws_apigatewayv2_api" "api-gateway" {
  name                       = "websocket-api"
  protocol_type              = "WEBSOCKET"
  route_selection_expression = "$request.body.action"
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "lambda_role" {
  name               = "LambdaRole"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

data "archive_file" "connect_lambda_archive" {
  type        = "zip"
  source_dir  = "../../lambdas/dist/"
  output_path = "connect.zip"
}

resource "aws_lambda_function" "random_with_friends_connect_lambda" {
  # If the file is not in the current working directory you will need to include a
  # path.module in the filename.
  filename      = "connect.zip"
  function_name = "random-with-friends-connect"
  role          = aws_iam_role.lambda_role.arn
  handler       = "connect.handler"

  source_code_hash = data.archive_file.connect_lambda_archive.output_base64sha256

  runtime = "nodejs18.x"

  depends_on = [
    aws_iam_role_policy_attachment.lambda_logs,
    aws_cloudwatch_log_group.random_with_friends_log_group,
  ]
}

# This is to optionally manage the CloudWatch Log Group for the Lambda Function.
# If skipping this resource configuration, also add "logs:CreateLogGroup" to the IAM policy below.
resource "aws_cloudwatch_log_group" "random_with_friends_log_group" {
  name              = "/aws/lambda/RandomWithFriends"
  retention_in_days = 14
}

# See also the following AWS managed policy: AWSLambdaBasicExecutionRole
data "aws_iam_policy_document" "lambda_logging" {
  statement {
    effect = "Allow"

    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]

    resources = ["arn:aws:logs:*:*:*"]
  }
}

resource "aws_iam_policy" "lambda_logging" {
  name        = "lambda_logging"
  path        = "/"
  description = "IAM policy for logging from a lambda"
  policy      = data.aws_iam_policy_document.lambda_logging.json
}

resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.lambda_logging.arn
}
