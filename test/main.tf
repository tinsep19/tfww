variable "input-1" { type = string }
resource "local_file" "file" {
  content = "${var.input-1}"
  filename = "out/${terraform.workspace}/content.txt"
}
output "output-1" { value = local_file.file.content_sha256}
