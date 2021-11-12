terraform {
  backend "remote" {
    organization = "uk-corp"

    workspaces {
      name = "workspace-uk"
    }
  }
}
