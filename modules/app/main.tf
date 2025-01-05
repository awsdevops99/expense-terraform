resource "aws_security_group" "main" {
  name        = "${var.env}"-"${var.component}"
  description = "${var.env}"-"${var.component}"
  vpc_id      = var.vpc_id

  ingress = {
      description = "APP"
      from_port = var.app_port
      to_port = var.app_port
      protocol = "tcp"
      cidr_blocks= var.sg_cidr 
  }

 egress = {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  tags = merge(var.tags, {Name = "${env.var}-mysql-rds"})
  }

resource "aws_launch_template" "main" {
  name_prefix   = "${var.env}"-"${var.component}"
  image_id      = data.aws_ami.main.image_id
  instance_type = var.instance_type
  vpc_security_group_ids = [aws_security_group.main.id]
  tags = merge(var.tags, {Name = "${env.var}"-"${env.component}"})

  user_data = base64decode(templatefile("${path.module}/userdata.sh",{
    role_name = var.component
    env = var.env
  }))


  iam_instance_profile {
    name = aws_iam_instance_profile
  } 
}

resource "aws_autoscaling_group" "bar" {
  availability_zones = ["us-east-1a"]
  desired_capacity   = var.instance_count
  max_size           = var.instance_count + 5
  min_size           = var.instance_count

  launch_template {
    id      = aws_launch_template.main.id
    version = "$Latest"
  }

 

  
}
resource "aws_autoscaling_group" "bar" {
  name                      = "${var.env}"-"${var.component}"
  max_size                  = var.instance_count
  min_size                  = var.instance_count
  vpc_zone_identifier       = var.subnets
  tag {

    key = "name"
    value = "${var.env}"-"${var.component}"
    propagate_at_launch = true
  }
}


resource "aws_iam_role" "test_role" {
  name = "${var.env}"-"${var.component}"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

inline_policy {
    name = "my_inline_policy"

    policy = jsonencode({
	"Version": "2012-10-17",
	"Statement": [
		{
			"Sid": "GetResources",
			"Effect": "Allow",
			"Action": [
				"ssm:GetParametersByPath",
                "ssm:GetParameterHistory",
				"ssm:GetParameters",
				"ssm:GetParameter"
			],
			"Resource": "arn:aws:ssm:us-east-1:831926604528:parameter/${var.env}.rds.*",
            "Resource": "arn:aws:ssm:us-east-1:831926604528:parameter/${var.env}.${var.component}.*"
		},
		{
			"Sid": "listresources",
			"Effect": "Allow",
			"Action": "ssm:DescribeParameters",
			"Resource": "*"
		},

        {
          "Sid" : "ListResources",
          "Effect" : "Allow",
          "Action" : "ssm:DescribeParameters",
          "Resource" : "*"
        },
        {
          "Sid" : "S3UploadForPrometheusAlerts",
          "Effect" : "Allow",
          "Action" : [
            "s3:GetObject",
            "s3:ListBucket",
            "s3:PutObject",
            "s3:DeleteObjectVersion",
            "s3:DeleteObject"
          ],
          "Resource" : [
            "arn:aws:s3:::d76-prometheus-alert-rules/*",
            "arn:aws:s3:::d76-prometheus-alert-rules"
          ]
        }
      ]
    })
  }

}


resource "aws_iam_instance_profile" "main" {
  name = "${var.env}"-"${var.component}"
  role = aws_iam_role.role.main.name
}
