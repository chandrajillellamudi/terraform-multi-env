resource "aws_route53_record" "expense" {

 for_each = var.instance_names
  zone_id = var.zone_id
  name    = each.key == "frontend-dev" ? var.domain_name : "${each.key}.${var.domain_name}"
  type    = "A"
  ttl     = 1
  records = startswith(each.key, "frontend") ? [aws_instance.server[each.key].public_ip] : [aws_instance.server[each.key].private_ip]
  allow_overwrite = true
}