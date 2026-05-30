extends Control


func _ready() -> void:
	_build_ui()


func _build_ui() -> void:
	var background := ColorRect.new()
	background.color = Color(0.05, 0.32, 0.22)
	background.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(background)

	var root := MarginContainer.new()
	root.set_anchors_preset(Control.PRESET_FULL_RECT)
	root.add_theme_constant_override("margin_left", 30)
	root.add_theme_constant_override("margin_top", 24)
	root.add_theme_constant_override("margin_right", 30)
	root.add_theme_constant_override("margin_bottom", 24)
	add_child(root)

	var layout := VBoxContainer.new()
	layout.add_theme_constant_override("separation", 16)
	root.add_child(layout)

	var top_bar := HBoxContainer.new()
	top_bar.add_theme_constant_override("separation", 12)
	layout.add_child(top_bar)

	var back_button := Button.new()
	back_button.text = "关卡"
	back_button.custom_minimum_size = Vector2(110, 42)
	back_button.pressed.connect(_on_back_pressed)
	top_bar.add_child(back_button)

	var level_label := Label.new()
	level_label.text = "第 %d 关 · 桥牌牌桌" % GameState.selected_level
	level_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	level_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	level_label.add_theme_font_size_override("font_size", 30)
	top_bar.add_child(level_label)

	var menu_button := Button.new()
	menu_button.text = "主菜单"
	menu_button.custom_minimum_size = Vector2(110, 42)
	menu_button.pressed.connect(_on_menu_pressed)
	top_bar.add_child(menu_button)

	var table_area := PanelContainer.new()
	table_area.size_flags_vertical = Control.SIZE_EXPAND_FILL
	layout.add_child(table_area)

	var table := GridContainer.new()
	table.columns = 3
	table.add_theme_constant_override("h_separation", 14)
	table.add_theme_constant_override("v_separation", 14)
	table_area.add_child(table)

	_add_seat(table, "")
	_add_seat(table, "北\n等待出牌")
	_add_seat(table, "")
	_add_seat(table, "西\n防守")
	_add_center(table)
	_add_seat(table, "东\n防守")
	_add_seat(table, "")
	_add_seat(table, "南\n玩家手牌：♠ A K 7  ♥ Q 9  ♦ A J 5  ♣ K 8 4 2")
	_add_seat(table, "")

	var action_bar := HBoxContainer.new()
	action_bar.alignment = BoxContainer.ALIGNMENT_CENTER
	action_bar.add_theme_constant_override("separation", 12)
	layout.add_child(action_bar)

	for card_name in ["♠A", "♥Q", "♦A", "♣K"]:
		var card_button := Button.new()
		card_button.text = card_name
		card_button.custom_minimum_size = Vector2(86, 54)
		card_button.pressed.connect(_on_card_pressed.bind(card_name))
		action_bar.add_child(card_button)


func _add_seat(parent: Node, text: String) -> void:
	var label := Label.new()
	label.text = text
	label.custom_minimum_size = Vector2(180, 100)
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	label.add_theme_font_size_override("font_size", 20)
	parent.add_child(label)


func _add_center(parent: Node) -> void:
	var center := Label.new()
	center.text = "首攻题\n请选择你的第一张牌"
	center.custom_minimum_size = Vector2(280, 180)
	center.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	center.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	center.add_theme_font_size_override("font_size", 24)
	parent.add_child(center)


func _on_card_pressed(card_name: String) -> void:
	print("Selected card: %s" % card_name)


func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/level_select.tscn")


func _on_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
