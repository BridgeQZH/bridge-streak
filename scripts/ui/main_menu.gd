extends Control


func _ready() -> void:
	_build_ui()


func _build_ui() -> void:
	var background := ColorRect.new()
	background.color = Color(0.08, 0.23, 0.18)
	background.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(background)

	var root := MarginContainer.new()
	root.set_anchors_preset(Control.PRESET_FULL_RECT)
	root.add_theme_constant_override("margin_left", 48)
	root.add_theme_constant_override("margin_top", 42)
	root.add_theme_constant_override("margin_right", 48)
	root.add_theme_constant_override("margin_bottom", 42)
	add_child(root)

	var layout := VBoxContainer.new()
	layout.alignment = BoxContainer.ALIGNMENT_CENTER
	layout.add_theme_constant_override("separation", 18)
	root.add_child(layout)

	var title := Label.new()
	title.text = "Bridge Streak"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override("font_size", 52)
	layout.add_child(title)

	var subtitle := Label.new()
	subtitle.text = "桥牌闯关训练"
	subtitle.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	subtitle.add_theme_font_size_override("font_size", 24)
	layout.add_child(subtitle)

	var start_button := Button.new()
	start_button.text = "开始闯关"
	start_button.custom_minimum_size = Vector2(220, 54)
	start_button.pressed.connect(_on_start_pressed)
	layout.add_child(start_button)

	var quit_button := Button.new()
	quit_button.text = "退出"
	quit_button.custom_minimum_size = Vector2(220, 46)
	quit_button.pressed.connect(_on_quit_pressed)
	layout.add_child(quit_button)


func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/level_select.tscn")


func _on_quit_pressed() -> void:
	get_tree().quit()
