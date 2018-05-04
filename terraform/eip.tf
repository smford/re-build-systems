resource "aws_eip" "jenkins2_eip" {
  vpc      = true
  instance = "${element(module.jenkins2_server.id,0)}"

  lifecycle {
    prevent_destroy = false

    //ignore_changes  = ["instance"]
  }

  tags = {
    Environment = "${var.environment}"
    ManagedBy   = "terraform"
    Name        = "jenkins2_eip_${var.product}_${var.environment}"
    Product     = "${var.product}"
  }
}
