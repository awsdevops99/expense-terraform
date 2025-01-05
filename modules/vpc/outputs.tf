output "vpc_id" {
    value = aws_vpc.main
}
output "public_subnets"{
    value = aws_subnet.app.*.id
}
output "web_subnets"{
   value = aws_subnet.web.*.id
}
output "app_subnets"{
   value = aws_subnet.web.*.id
}

output "db_subnets"{
    value = aws_subnet.db.*.id
}
  

  
