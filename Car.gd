extends KinematicBody2D

# source of this code from http://kidscancode.org/godot_recipes/2d/car_steering/

var wheel_base = 70 # distance between the wheels
var steering_angle = 15

var velocity = Vector2.ZERO
var steer_direction

func _physics_process(delta):
	get_input()
	calculate_steering(delta)
	velocity = move_and_slide(velocity)


func get_input():
	var turn = 0
	if Input.is_key_pressed(KEY_RIGHT):
		turn += 1
	if Input.is_key_pressed(KEY_LEFT):
		turn -= 1

	steer_direction = turn * deg2rad(steering_angle)
	velocity = Vector2.ZERO
	if Input.is_key_pressed(KEY_UP):
		velocity = transform.x * 500


func calculate_steering(delta):
	var rear_wheel = position - transform.x * wheel_base/2.0
	var front_wheel = position + transform.x * wheel_base/2.0

	rear_wheel += velocity * delta
	front_wheel += velocity.rotated(steer_direction) * delta

	var new_heading = (front_wheel - rear_wheel).normalized()
	velocity = new_heading * velocity.length()
	rotation = new_heading.angle()
