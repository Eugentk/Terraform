output "latest_version_linux" {
  value = data.aws_ami.latest_version.id
}

output "IP_address_from_DNS" {
  value = aws_eip.static_ip.public_ip
}
