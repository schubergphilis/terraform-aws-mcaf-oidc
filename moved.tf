moved {
  from = aws_iam_openid_connect_provider.default["instance"]
  to   = aws_iam_openid_connect_provider.default["create"]
}

moved {
  from = data.tls_certificate.default
  to   = data.tls_certificate.default["create"]
}
