locals {
#  Server_Prefix = "CliXX-"
  Server_Prefix=""
}


resource "aws_key_pair" "Stack_KP" {
  key_name   = "mykey"
  public_key = file(var.PATH_TO_PUBLIC_KEY)
}


resource "aws_instance" "Server" {
 count = length(var.subnet_ids)  //create an ec2 instance for each existing subnet
 subnet_id     = var.subnet_ids[count.index]  //Create an EC2 Instance for each subnet
 ami           = var.ami
 instance_type          = var.instance_type
 vpc_security_group_ids = [aws_security_group.stack-sg.id]
 user_data = data.template_file.bootstrap.rendered
 key_name = aws_key_pair.Stack_KP.key_name
#  subnet_id = var.subnet
root_block_device {
   volume_type           = "gp2"
   volume_size           = 30
   delete_on_termination = true
   encrypted= "false"
 }
 tags = {
  Name = "Stack-Dev-Server-${count.index}"
  Environment = var.environment
  OwnerEmail = var.OwnerEmail
}
}
