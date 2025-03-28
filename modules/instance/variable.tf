variable "stage" {
  type  = string
  default = "dev"
}
variable "servicename" {
  type  = string
  default = "asw"
}
variable "tags" {
  type = map(string)
  default = {
    "name" = "asw-EC2"
  }
}

variable "ami" {
  type  = string
  default = "ami-04c596dcf23eb98d8" #AL2
}
variable "instance_type" {
  type  = string
  default = "t2.micro" #1c1m
}
variable "sg_ec2_ids" {
  type  = list
}
variable "subnet_id" {
  type  = string
}
variable "vpc_id" {
  type  = string
  default = ""
}
variable "ebs_size" {
  type = number
  default = 50
}
variable "user_data" {
  type = string
  default = <<-EOF
    #!/bin/bash
    yum update -y
    yum install -y nginx

    # Nginx 리버스 프록시 설정
    cat <<EOL > /etc/nginx/conf.d/example.com.conf
    server {
        listen 80;
        server_name www.example.com;

        location / {
            proxy_pass http://www.example.com;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
        }
    }
    EOL

    # Nginx 재시작
    systemctl enable nginx
    systemctl start nginx
  EOF
}
variable "kms_key_id" {
  type = string
}
variable "ec2-iam-role-profile-name" {
  type = string
}
variable "associate_public_ip_address" {
  type = bool
  default = false
}
variable "isPortForwarding" {
  type = bool
  default = false
}
variable "ssh_allow_comm_list" {
  type = list(any)
}