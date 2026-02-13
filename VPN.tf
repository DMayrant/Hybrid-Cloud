resource "aws_vpn_gateway" "vpn_gateway" {
  vpc_id = aws_vpc.main_vpc.id
}

resource "aws_vpn_gateway_attachment" "vpn_attach" {
  vpc_id         = aws_vpc.main_vpc.id
  vpn_gateway_id = aws_vpn_gateway.vpn_gateway.id
}

resource "aws_customer_gateway" "customer_gateway" {
  bgp_asn    = 65000
  ip_address = "172.0.0.1" # public IP of on-prem device
  type       = "ipsec.1"
}

resource "aws_vpn_connection" "aws_vpc" {
  vpn_gateway_id      = aws_vpn_gateway.vpn_gateway.id
  customer_gateway_id = aws_customer_gateway.customer_gateway.id
  type                = "ipsec.1"
  tags = {
    Name = "aws_vpn_connector"
  }
  static_routes_only = true
}

resource "aws_vpn_connection_route" "onprem" {
  vpn_connection_id      = aws_vpn_connection.aws_vpc.id
  destination_cidr_block = "192.168.0.0/16"
}

resource "aws_route" "onprem_route" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "192.168.0.0/16"
  gateway_id             = aws_vpn_gateway.vpn_gateway.id
}
