package main

deny[msg] {
  input.kind = "Service"
  not input.spec.type = "NodePort"
  msg = "Service type should be NodePort"
}


package main

deny[msg] {
  input.kind == "Deployment"
  not input.spec.template.spec.securityContext.runAsNonRoot

  msg := "Containers must not run as root"
}
