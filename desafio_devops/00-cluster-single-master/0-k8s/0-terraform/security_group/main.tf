provider "aws" {
  region = "sa-east-1"
}

variable "sg-master" {
  type        = string
  description = "security group master"
}

variable "sg-worker" {
  type        = string
  description = "security group worker"
}

resource "aws_security_group_rule" "master_single" {
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  //cidr_blocks       = []
  //ipv6_cidr_blocks  = []
  source_security_group_id = var.sg-worker
  security_group_id = var.sg-master
}
// resource "aws_security_group" "acessos_master_single_master" {
//   name        = "acessos_master_single_master_desafio"
//   description = "acessos_workers_single_master inbound traffic"
//   vpc_id      = "vpc-0b7bc0aae8788da62"
//   id          = var.sg-master

//   ingress = [
//     {
//        cidr_blocks      = []
//        description      = ""
//        from_port        = 0
//        ipv6_cidr_blocks = []
//        prefix_list_ids  = []
//        protocol         = "-1"
//        security_groups  = [
//          var.sg-worker,
//        ]
//        self             = false
//        to_port          = 0
//      }
//   ]
// }

resource "aws_security_group_rule" "workers_single" {
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  //cidr_blocks       = []
  //ipv6_cidr_blocks  = []
  source_security_group_id = var.sg-master
  security_group_id = var.sg-worker
}

// resource "aws_security_group" "acessos_workers_single_master" {
//   name        = "acessos_workers_single_master_desafio"
//   description = "acessos_workers_single_master inbound traffic"
//   vpc_id      = "vpc-0b7bc0aae8788da62"
//   id          = var.sg-worker

//   ingress = [
//     {
//       cidr_blocks      = []
//       description      = ""
//       from_port        = 0
//       ipv6_cidr_blocks = []
//       prefix_list_ids  = []
//       protocol         = "-1"
//       security_groups  = [
//         var.sg-master,
//       ]
//       self             = false
//       to_port          = 0
//     }
//   ]
// }