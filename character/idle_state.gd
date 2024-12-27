extends BaseCharacterState
class_name IdleState

func get_animation_name() -> String:
	return "idle1"	

func get_state() -> STATE:
	return STATE.IDLE

func update(_delta: float) -> STATE:			
	return STATE.NONE
