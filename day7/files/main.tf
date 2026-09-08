# -----------------------------------------------------------------------------
# Data source: latest Amazon Linux 2 AMI (free-tier eligible OS)
# -----------------------------------------------------------------------------
data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# -----------------------------------------------------------------------------
# Security Group: allow SSH in, everything out
# -----------------------------------------------------------------------------
resource "aws_security_group" "ec2_sg" {
  name        = "${var.project_name}-ec2-sg"
  description = "Allow SSH inbound and all outbound traffic"

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "All outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.common_tags, {
    Name = "${var.project_name}-ec2-sg"
  })
}

# -----------------------------------------------------------------------------
# EC2 Instances (Free Tier: t3.micro or t2.micro depending on account age,
# 750 hrs/month combined, 30GB EBS)
# -----------------------------------------------------------------------------
resource "aws_instance" "app" {
  count = var.instance_count

  ami                    = data.aws_ami.amazon_linux_2.id
  instance_type          = var.instance_type
  key_name               = var.key_name != "" ? var.key_name : null
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]

  root_block_device {
    volume_type = "gp3"
    volume_size = var.root_volume_size
  }

  tags = merge(local.common_tags, {
    Name = "${var.project_name}-ec2-${count.index + 1}"
  })
}
