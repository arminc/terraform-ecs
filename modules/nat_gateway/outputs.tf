output "ids" {
  value = "${aws_nat_gateway.nat.*.id}"
}
