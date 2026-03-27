extends StaticBody3D

@onready var main: MeshInstance3D = $Main
@onready var main_2: MeshInstance3D = $Main2
@onready var roof_2: MeshInstance3D = $Node3D/Roof2
@onready var roof: MeshInstance3D = $Node3D/Roof
@onready var door: MeshInstance3D = $Door


@export var color_main: Color = Color("6a5730")
@export var color_roof: Color = Color("6c4931")
@export var color_door: Color = Color("6a5730")

func _ready() -> void:
	var main_material = main.get_active_material(0)
	var roof_material = roof.get_active_material(0)
	var door_matirial = door.get_active_material(0)
	
	var new_main_material: = main_material.duplicate()
	var new_roof_material: = roof_material.duplicate()
	var new_door_matirial: = door_matirial.duplicate()
	
	new_main_material.albedo_color = color_main
	new_roof_material.albedo_color = color_roof
	new_door_matirial.albedo_color = color_door
	
	
	main.set_surface_override_material(0, new_main_material)
	main_2.set_surface_override_material(0, new_main_material)
	roof.set_surface_override_material(0, new_roof_material)
	roof_2.set_surface_override_material(0, new_roof_material)
	door.set_surface_override_material(0, new_door_matirial)
