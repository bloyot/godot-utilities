extends Node

# map of event type -> arg type array
var events: Dictionary
# map of event type -> array of callback functions
var callbacks: Dictionary

func register(event_type: String, arg_types: Array[Variant]) -> void:
	# TODO throw error if event already exists
	events[event_type] = arg_types	
	
func callback(event_type: String, callback: Callable) -> void:
	# TODO (if possible) verify that the callback args match the registered arg type
	if callbacks.has(event_type):
		callbacks[event_type].append(callback)	
	else:
		callbacks[event_type] = [callback]
	
func publish(event_type: String, args: Array[Variant]) -> void:
	# TODO verify that args match the registered arg types
	if callbacks.has(event_type):
		for callable: Callable in callbacks[event_type]:
			callable.call(args)	
