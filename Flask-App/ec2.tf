resource "aws_instance" "ubuntu" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name      = aws_key_pair.example.key_name
  vpc_security_group_ids = [aws_security_group.webSg.id]
  subnet_id              = aws_subnet.sub1.id

  connection {
    type        = "ssh"
    user        = "ubuntu"  # Replace with the appropriate username for your EC2 instance
    private_key = file("~/.ssh/id_rsa")  # Replace with the path to your private key
    host        = self.public_ip
   }

   # File provisioner to copy a file from local to the remote EC2 instance
   provisioner "file" {
      source = "/opt/application-deployment-in-aws-terraform-provisioner/Flask Application/app.py" # Replace with the path to your local file
    destination = "/home/ubuntu/app.py"  # Replace with the path on the remote instance
   }

   provisioner "remote-exec" {
    inline = [
      "echo 'Hello from the remote instance'",
    "sudo apt update -y",  # Update package lists (for ubuntu)
    "sudo apt install -y python3.12",  # Install python3 and pip
    ]
   }
}
