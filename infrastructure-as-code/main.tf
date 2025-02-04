provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "linux_vm" {
  ami           = "ami-0c94855ba95c71c99"  # Replace with the latest Ubuntu AMI ID
  instance_type = "t2.micro"

  key_name = "your-key-pair"               # Replace with your key pair name

  tags = {
    Name = "LinuxVM"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt update -y"
    ]

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("~/.ssh/your-key.pem")  # Replace with your private key path
      host        = self.public_ip
    }
  }
}