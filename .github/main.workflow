workflow "on push" {
  on = "push"
  resolves = ["mdlint"]
}

action "mdlint" {
  uses = "bltavares/actions/mdlint@master"
  runs = ["markdownlint", "--config", ".mdlintrc", "."]
}
