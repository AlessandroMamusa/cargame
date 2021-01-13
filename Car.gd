extends KinematicBody2D

# source of this code from http://kidscancode.org/godot_recipes/2d/car_steering/

var wheel_base = 70 # distance between the wheels
var steering_angle = 15
var engine_power = 800

var acceleration = Vector2.ZERO
var velocity = Vector2.ZERO
var bracking = -450
var max_speed_reverse = 250
var steer_direction

var friction = -0.9
var drag = -0.0015


func _physics_process(delta):
	acceleration = Vector2.ZERO
	get_input()
	apply_friction()
	calculate_steering(delta)
	velocity += acceleration * delta
	velocity = move_and_slide(velocity)


func get_input():
	var turn = 0
	if Input.is_key_pressed(KEY_RIGHT):
		turn += 1
	if Input.is_key_pressed(KEY_LEFT):
		turn -= 1

	steer_direction = turn * deg2rad(steering_angle)

	if Input.is_key_pressed(KEY_UP):
		acceleration = transform.x * engine_power
	if Input.is_key_pressed(KEY_DOWN):
		acceleration = transform.x * bracking


func calculate_steering(delta):
	var rear_wheel = position - transform.x * wheel_base/2.0
	var front_wheel = position + transform.x * wheel_base/2.0

	rear_wheel += velocity * delta
	front_wheel += velocity.rotated(steer_direction) * delta

	var new_heading = (front_wheel - rear_wheel).normalized()
	var d = new_heading.dot(velocity.normalized())
	if d > 0:
		velocity = new_heading * velocity.length()
	if d < 0:
		velocity = -new_heading * min(velocity.length(), max_speed_reverse)
	rotation = new_heading.angle()


func apply_friction():
	if velocity.length() < 5:
		velocity = Vector2.ZERO
	var friction_force = velocity * friction
	var drag_force = velocity * velocity.length() * drag
	if velocity.length() < 100:
		friction_force *= 3
	acceleration += drag_force + friction_force
