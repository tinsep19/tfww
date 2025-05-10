variable "input-1" { type = string }
resource "terraform_data" "resource-1" {
  input = var.input-1
}
output "output-1" { value = terraform_data.resource-1.output }
