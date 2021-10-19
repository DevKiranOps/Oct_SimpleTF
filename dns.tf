
resource "aws_route53_zone" "dev" {
  name = "learndevops.club"

  tags = {
    Environment = "dev"
  }
}