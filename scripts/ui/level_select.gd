extends Control


const LEVEL_COUNT := 6


func _ready() -> void:
	_build_ui()


func _build_ui() -> void:
	var background := ColorRect.new()
	background.color = Color(0.11, 0.16, 0.21)
	background.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(background)

	var root := MarginContainer.new()
	root.set_anchors_preset(Control.PRESET_FULL_RECT)
	root.add_theme_constant_override("margin_left", 42)
	root.add_theme_constant_override("margin_top", 36)
	root.add_theme_constant_override("margin_right", 42)
	root.add_theme_constant_override("margin_bottom", 36)
	add_child(root)

	var layout := VBoxContainer.new()
	layout.add_theme_constant_override("separation", 18)
	root.add_child(layout)

	var top_bar := HBoxContainer.new()
	top_bar.add_theme_constant_override("separation", 12)
	layout.add_child(top_bar)

	var back_button := Button.new()
	back_button.text = "返回"
	back_button.custom_minimum_size = Vector2(110, 42)
	back_button.pressed.connect(_on_back_pressed)
	top_bar.add_child(back_button)

	var title := Label.new()
	title.text = "选择关卡"
	title.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override("font_size", 36)
	top_bar.add_child(title)

	var spacer := Control.new()
	spacer.custom_minimum_size = Vector2(110, 1)
	top_bar.add_child(spacer)

	var grid := GridContainer.new()
	grid.columns = 3
	grid.size_flags_vertical = Control.SIZE_EXPAND_FILL
	grid.add_theme_constant_override("h_separation", 14)
	grid.add_theme_constant_override("v_separation", 14)
	layout.add_child(grid)

	for level_number in range(1, LEVEL_COUNT + 1):
		var button := Button.new()
		button.text = "第 %d 关\n首攻训练" % level_number
		button.custom_minimum_size = Vector2(190, 120)
		button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		button.size_flags_vertical = Control.SIZE_EXPAND_FILL
		button.pressed.connect(_on_level_pressed.bind(level_number))
		grid.add_child(button)


func _on_level_pressed(level_number: int) -> void:
	GameState.selected_level = level_number
	get_tree().change_scene_to_file("res://scenes/game_table.tscn")


func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
