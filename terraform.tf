# Define the provider (change these values to your cloud provider)
provider "aws" {
  region = "us-east-1"
}

# Create an EC2 instance
resource "aws_instance" "example" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
  key_name      = "your-key-name"
  tags = {
    Name = "example-instance"
  }
}

# Define the connection to the instance for Ansible
connection "ssh" {
  host = aws_instance.example.public_ip
  type = "ssh"
  user = "ubuntu"
  private_key = file("/path/to/your/private/key.pem")
}

# Use a provisioner to run Ansible
provisioner "local-exec" {
  command = "ansible-playbook -i '${aws_instance.example.public_ip},' -e 'ansible_ssh_private_key_file=/path/to/your/private/key.pem' ansible-playbook.yml"
}

# Output the public IP address of the instance
output "public_ip" {
  value = aws_instance.example.public_ip
}
