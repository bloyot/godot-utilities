extends CharacterBody2D
class_name Player

enum FACING { LEFT, RIGHT }

# Signals
signal state_change(old_state: BaseCharacterState, new_state: BaseCharacterState)

static var DEFAULT_COLLISION_MASK: int = 0b0101
static var INTANGIBLE_COLLISION_MASK: int = 0b0001

# Children
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var hitbox: Area2D = $Hitbox

# Exports

# State variables
# track all states here for reference, map of STATE enum to BaseCharacterState object
var states: Dictionary = {
	BaseCharacterState.STATE.IDLE: IdleState.new()
}
# track our current state here
var curr_state: BaseCharacterState = null
# use this to avoid flipping our facing during the middle of an attack or other animation
var freeze_facing: bool = false

## player specific stuff goes here ##

########################################
########## Engine Overrides ############
########################################
func _ready() -> void:	
	init_states()
	
func _physics_process(delta: float) -> void:	
	var maybe_new_state: BaseCharacterState.STATE = curr_state.update(delta)
	if (maybe_new_state != BaseCharacterState.STATE.NONE):
		change_state(maybe_new_state)

	# determine facing	
	set_facing(curr_state.facing)
	
	# move the player based on our target position
	move(delta, curr_state.target_position)

func move(_delta: float, target_position: Vector2) -> void:		
	## movement logic goes here
	
	move_and_slide()

func init_states() -> void:
	# setup the states
	var states_group: Array = states.values()
	for state: BaseCharacterState in states_group:		
		state.setup(self)
		states[state.get_state()] = state
	curr_state = states[BaseCharacterState.STATE.IDLE]
	change_state(BaseCharacterState.STATE.IDLE)

func change_state(target_state: BaseCharacterState.STATE) -> void:	
	assert(states.has(target_state), "STATE " + str(target_state) + " not present on character")
	var old_state: BaseCharacterState = curr_state
	var new_state: BaseCharacterState = states[target_state]		

	old_state.on_exit()	
	new_state.on_enter()

	curr_state = new_state		
	state_change.emit(old_state, new_state)
	
func set_facing(facing: FACING) -> void:			
	animated_sprite.flip_h = facing == FACING.LEFT

func get_facing() -> FACING:
	return FACING.RIGHT if scale.x > 0 else FACING.LEFT

func play_animation(animation_name: String) -> void:
	animated_sprite.play(animation_name)
	
func set_intangible(is_intangible: bool) -> void:	
	collision_mask = INTANGIBLE_COLLISION_MASK if is_intangible else DEFAULT_COLLISION_MASK
	hitbox.collision_mask = INTANGIBLE_COLLISION_MASK if is_intangible else DEFAULT_COLLISION_MASK
