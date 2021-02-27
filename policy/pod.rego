# name of this policy module or package
# typically named to the type of resource that the policy apply to
package main

import data

is_resource_of_type(resource, type) {
	resource.type == type
}

is_kubernetes_pod(resource) {
	is_resource_of_type(resource, "kubernetes_pod")
}

allowed_containers = {
	"nginx",
	"alpine",
}

violated_pods[image] {
	input.resource_changes[_].change.actions[_] != "no-op"

	pod := input.resource_changes[i]
	is_kubernetes_pod(pod)
	container_tag := pod.change.after.spec[_].container[_].image
	image := split(container_tag, ":")[0]

	not allowed_containers[image]
}

deny[msg] {
	count(violated_pods) > 0
	msg := sprintf("These pods not allowed to exist: %v", [violated_pods[_]])
}
