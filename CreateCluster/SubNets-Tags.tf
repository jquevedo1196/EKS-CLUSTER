provider "aws" {
  region = var.region
  profile = var.profile
}

resource "aws_ec2_tag" "share_all" {
  for_each    = toset([var.subn_priv_1, var.subn_priv_2, var.subn_pub_1, var.subn_pub_2])
  resource_id = each.value
  key         = "${var.cluster.key}${var.cluster_name}"
  value       = var.cluster.value
}

resource "aws_ec2_tag" "public" {
  for_each    = toset([var.subn_pub_1, var.subn_pub_2])
  resource_id = each.value
  key         = var.nets_public.key
  value       = var.nets_public.value
}

resource "aws_ec2_tag" "private" {
  for_each    = toset([var.subn_priv_1, var.subn_priv_2])
  resource_id = each.value
  key         = var.nets_private.key
  value       = var.nets_private.value
}
