resource "aws_dx_gateway" "primary" {
  name            = "dx-gateway"
  amazon_side_asn = 64512
  
}

resource "aws_dx_gateway_association" "example" {
  dx_gateway_id         = aws_dx_gateway.primary.id
  associated_gateway_id = aws_vpn_gateway.vpn_gateway.id
}
