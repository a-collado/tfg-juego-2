@icon("res://assets/Iconos/Editor/state_machine_state.svg")
extends Node
class_name State

signal Transitioned
var active := false

func enter() -> void: pass
func exit() -> void: pass
func update() -> void: pass
func physics_update() -> void: pass
