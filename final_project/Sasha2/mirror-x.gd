@tool
extends MeshInstance3D

@export var size = Vector2(4,5)
@export var pixels_per_unit = 200
@export var mirror_index : int = 0

@onready var viewport = get_node("Viewport")
@onready var plane_mark = get_node("PlaneTransform")

var main_cam = null
var mirror_cam = null

func set_mirror_size (new_size):
	size = new_size
	mesh.size = size
	initialize_camera()

func _ready():
	if Engine.is_editor_hint():
		return
	initialize_camera()
	
func _process(delta):
	
	if Engine.is_editor_hint():
		return
		
	# Compute reflection plane and its global transform  (origin in the middle, 
	#  X and Y axis properly aligned with the viewport, -Z is the mirror's forward direction) 
	var plane_origin = plane_mark.global_transform.origin
	var plane_normal = plane_mark.global_transform.basis.z.normalized()
	var reflection_plane = Plane(plane_normal, plane_origin.dot(plane_normal))
	var reflection_transform = plane_mark.global_transform
	
	# Main camera position
	var cam_pos = main_cam.global_transform.origin 
	
	# The projected point of main camera's position onto the reflection plane
	var proj_pos = reflection_plane.project(cam_pos)
	
	# Main camera position reflected over the mirror's plane
	var mirrored_pos = cam_pos + (proj_pos - cam_pos) * 2.0
	
	# Compute mirror camera transform
	# - origin at the mirrored position
	# - looking perpedicularly into the relfection plane (this way the near clip plane will be 
	#      parallel to the reflection plane) 
	var t = Transform3D(Basis(), mirrored_pos)
	t = t.looking_at(proj_pos, reflection_transform.basis.y.normalized())
	mirror_cam.set_global_transform(t)
	
	# Compute the tilting offset for the frustum (the X and Y coordinates of the mirrored camera position
	#	when expressed in the reflection plane coordinate system) 
	var offset = reflection_transform.affine_inverse() * cam_pos
	offset = Vector2(offset.x, offset.y)
	# Set mirror camera frustum
	# - size 	-> mirror's width (camera is set to KEEP_WIDTH)
	# - offset 	-> previously computed tilting offset
	# - z_near 	-> distance between the mirror camera and the reflection plane (this ensures we won't
	#               be reflecting anything behind the mirror)
	# - z_far	-> large arbitrary value (render distance limit form th mirror camera position)
	mirror_cam.set_frustum(mesh.size.x, -offset, proj_pos.distance_to(cam_pos), 1000.0)

func initialize_camera():
	
	if !is_inside_tree() || Engine.is_editor_hint():
		return
		
	# Get main camera
	var root_viewport = get_tree().root
	main_cam = root_viewport.get_camera_3d()
	
	# Free mirror camera if it already exists
	if mirror_cam != null:
		mirror_cam.queue_free()
		
	# Add a mirror camera
	mirror_cam = Camera3D.new()
	viewport.add_child(mirror_cam)
	mirror_cam.keep_aspect = Camera3D.KEEP_WIDTH
	mirror_cam.current = true
	
	# Adjust viewport size to match the actual mirror size, multiplied by the resolution ratio
	viewport.size = mesh.size * pixels_per_unit
	
	# Set material texture
	#TO DO: change to set uniform
	set_instance_shader_parameter("tex_index", mirror_index)
	#get_surface_override_material(0).set_shader_parameter("tex_index", mirror_index)
	match (mirror_index):
		0:
			get_surface_override_material(0).set_shader_parameter("tex_mirror_0", viewport.get_texture())
		1:
			get_surface_override_material(0).set_shader_parameter("tex_mirror_1", viewport.get_texture())
		2:
			get_surface_override_material(0).set_shader_parameter("tex_mirror_2", viewport.get_texture())
		3:
			get_surface_override_material(0).set_shader_parameter("tex_mirror_3", viewport.get_texture())
		4:
			get_surface_override_material(0).set_shader_parameter("tex_mirror_4", viewport.get_texture())
	#get_surface_override_material(0).albedo_texture = viewport.get_texture()
	
