extends StaticBody3D

var health: int = 100
var maxHealth: int = 100
var iFrame: bool = false
var death: bool = false
@onready var progress_bar: ProgressBar = $SubViewport/ProgressBar
@onready var player: CharacterBody3D = $"../../../player"
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var i_frame_timer: Timer = $iFrameTimer
@onready var reset_timer: Timer = $resetTimer
@onready var hit_sound: AudioStreamPlayer3D = $hitSound

func _process(_delta: float) -> void:
	
	progress_bar.value = health
	
	if health >= maxHealth:
		progress_bar.hide()
	else:
		progress_bar.show()
	
	if health <= 0:
		death = true
		progress_bar.hide()
		animation_player.play("death")
		health = 1

func _on_hitbox_area_entered(area: Area3D) -> void:
	if area.is_in_group("weapon") and iFrame == false and player.attackActive == true and death == false:
		hit_sound.play()
		health -= player.playerAttack
		iFrame = true
		i_frame_timer.start()
	if area.is_in_group("magic") and iFrame == false and death == false:
		hit_sound.play()
		health -= player.playerMagicAtk
		iFrame = true
		i_frame_timer.start()
	if area.is_in_group("lightningMagic") and iFrame == false and death == false:
		hit_sound.play()
		health -= player.playerMagicAtk * 0.5
		iFrame = true
		i_frame_timer.start()
	if area.is_in_group("iceMagic") and iFrame == false and death == false:
		hit_sound.play()
		health -= player.playerMagicAtk * 0.75
		iFrame = true
		i_frame_timer.start()

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "death":
		reset_timer.start()

func _on_i_frame_timer_timeout() -> void:
	iFrame = false

func _on_reset_timer_timeout() -> void:
	death = false
	health = maxHealth
	animation_player.play("RESET")
	progress_bar.hide()
