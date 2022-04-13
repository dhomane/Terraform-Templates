#  vim:ts=2:sts=2:sw=2:et
#
#  Author: Hari Sekhon
#  Date: 2022-03-21 16:34:40 +0000 (Mon, 21 Mar 2022)
#
#  https://github.com/HariSekhon/Terraform
#
#  License: see accompanying Hari Sekhon LICENSE file
#
#  If you're using my code you're welcome to connect with me on LinkedIn and optionally send me feedback to help steer this or other code I publish
#
#  https://www.linkedin.com/in/HariSekhon
#

# ============================================================================ #
#                       G i t H u b   C o d e O w n e r s
# ============================================================================ #

# teams must be set to "closed" (visible in the UI), not "secret", otherwise they'll appear in PR draft but disappear in PR, looking like a bug, but it's expected behaviour, team visibility is a requirement

resource "github_repository_file" "codeowners" {
  repository = github_repository.repo.name
  branch     = "main" # or "master"
  file       = ".github/CODEOWNERS"
  # permit codeowners override in module caller using var below instead
  #content       = ".github/ @myorg/devops-team"
  # ensure there is a newline at end of file via EOT style so people with IDEs or pre-commit hooks aren't changing the file during PRs
  # XXX: Edit the MYORG/DEVOPS-TEAM with your actual github team (which must be Visible aka "closed" in Terraform)
  content             = <<EOF
# Managed by Terraform - DO NOT EDIT
%{if var.codeowners != ""}${var.codeowners}%{else}.github/ @MYORG/DEVOPS-TEAM%{endif}
EOF
  commit_message = "CODEOWNERS managed by Terraform"
  # requires both or neither - uses the account owning the github token as the author if omitted
  #commit_author = "Terraform"
  #commit_email  = "terraform@MYCOMPANY.COM"
  overwrite_on_create = false

  lifecycle {
    ignore_changes = [
      commit_message,
      overwrite_on_create
    ]
  }
}
