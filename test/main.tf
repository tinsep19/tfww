variable "input-1" { type = string }
resource "local_file" "file" {
  content = "${terraform.workspace}"
  filename = "out/${terraform.workspace}/content.txt"
}
output "output-1" { value = local_file.file.content }
