extends Node

# List to store outcomes with a fixed maximum size.
var outcomes = []

func add_outcome(outcome: String):
	# Insert the new outcome at the beginning of the list.
	outcomes.insert(0, outcome)
	# Ensure the list never exceeds five elements.
	if outcomes.size() > 5:
		outcomes = outcomes.slice(0, 5)
