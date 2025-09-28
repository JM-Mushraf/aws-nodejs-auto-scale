#####################################
# VPC and Networking
#####################################

resource "aws_vpc" "myvpc" {
  cidr_block = var.cidr
}

resource "aws_subnet" "sub1" {
  vpc_id                  = aws_vpc.myvpc.id
  cidr_block              = "10.0.0.0/24"
  availability_zone       = "eu-north-1a"
  map_public_ip_on_launch = true
}

resource "aws_subnet" "sub2" {
  vpc_id                  = aws_vpc.myvpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "eu-north-1b"
  map_public_ip_on_launch = true
}

resource "aws_internet_gateway" "ig" {
  vpc_id = aws_vpc.myvpc.id
}

resource "aws_route_table" "RT" {
  vpc_id = aws_vpc.myvpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ig.id
  }
}

resource "aws_route_table_association" "rta1" {
  subnet_id      = aws_subnet.sub1.id
  route_table_id = aws_route_table.RT.id
}

resource "aws_route_table_association" "rta2" {
  subnet_id      = aws_subnet.sub2.id
  route_table_id = aws_route_table.RT.id
}

#####################################
# Security Groups
#####################################

# ALB Security Group
resource "aws_security_group" "alb_sg" {
  name   = "alb-sg"
  vpc_id = aws_vpc.myvpc.id

  # Allow HTTP from public
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outbound
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "alb-sg"
  }
}

# EC2 Security Group
resource "aws_security_group" "ec2_sg" {
  name   = "ec2-sg"
  vpc_id = aws_vpc.myvpc.id

  # Allow traffic from ALB SG on port 3000
  ingress {
    from_port       = 3000
    to_port         = 3000
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  # SSH for admin
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outbound
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ec2-sg"
  }
}

#####################################
# EC2 Instances
#####################################

resource "aws_instance" "webserver1" {
  ami                    = var.ami
  instance_type           = "t3.micro"
  vpc_security_group_ids  = [aws_security_group.ec2_sg.id]
  subnet_id               = aws_subnet.sub1.id
  user_data               = file("server.sh")

  tags = {
    Name = "webserver1"
  }
}

resource "aws_instance" "webserver2" {
  ami                    = var.ami
  instance_type           = "t3.micro"
  vpc_security_group_ids  = [aws_security_group.ec2_sg.id]
  subnet_id               = aws_subnet.sub2.id
  user_data               = file("server.sh")

  tags = {
    Name = "webserver2"
  }
}

#####################################
# Load Balancer
#####################################

resource "aws_lb" "lb" {
  name               = "lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = [aws_subnet.sub1.id, aws_subnet.sub2.id]

  tags = {
    Name = "web"
  }
}

#####################################
# Target Group
#####################################

resource "aws_lb_target_group" "tg" {
  name     = "lbTG"
  port     = 3000
  protocol = "HTTP"
  vpc_id   = aws_vpc.myvpc.id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
    port                = "traffic-port"
  }
}

resource "aws_lb_target_group_attachment" "lbattach1" {
  target_group_arn = aws_lb_target_group.tg.arn
  target_id        = aws_instance.webserver1.id
  port             = 3000
}

resource "aws_lb_target_group_attachment" "lbattach2" {
  target_group_arn = aws_lb_target_group.tg.arn
  target_id        = aws_instance.webserver2.id
  port             = 3000
}

#####################################
# Listener
#####################################

resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }
}

#####################################
# Outputs
#####################################

output "loadbalancerdns" {
  value = aws_lb.lb.dns_name
}
