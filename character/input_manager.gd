extends Node2D

# amount of frames before the end of an animation that we will store an input
var frame_buffer_frames: float = 60
# store the most recent input if we're mid animation
var frame_buffer: Array[Dictionary] = []

# Set the frame buffer based on the input every frame
func _physics_process(delta: float) -> void:
	frame_buffer.push_back(input())	
	if (frame_buffer.size() > frame_buffer_frames):
		frame_buffer.pop_front()	

# read the input from the player
func input() -> Dictionary: 		
	return {
		# TODO put input here
	}

# get the input map at the specified frame
func get_input(frames_back: int = 1) -> Dictionary:
	return frame_buffer[-1 * frames_back]

# return true if the input exists in the last x buffered frames
func has_buffered_input(input_name: String, frames_back: int = 1) -> bool:
	for frame: Dictionary in frame_buffer.slice(-1 * frames_back):
		if (frame.has(input_name) and frame[input_name]):
			return true
	return false
