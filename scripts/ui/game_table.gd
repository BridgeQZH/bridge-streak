extends Control


const LEVEL_PATH_TEMPLATE := "res://data/levels/%03d.json"
const CARD_WIDTH := 92
const CARD_HEIGHT := 128
const SUIT_NAMES := {
	"S": "spade",
	"H": "heart",
	"D": "diamond",
	"C": "club",
}
const RANK_IMAGE_NAMES := {
	"A": "1",
	"K": "13",
	"Q": "12",
	"J": "11",
	"T": "10",
	"9": "9",
	"8": "8",
	"7": "7",
	"6": "6",
	"5": "5",
	"4": "4",
	"3": "3",
	"2": "2",
}

var level_data: Dictionary = {}
var current_step: int = 0
var chosen_cards: Array[String] = []
var prompt_label: Label
var status_label: Label
var north_cards: HBoxContainer
var south_cards: HBoxContainer
var table_cards: HBoxContainer


func _ready() -> void:
	level_data = _load_level(GameState.selected_level)
	if level_data.is_empty():
		level_data = _load_level(1)
	_build_ui()
	_update_prompt()


func _load_level(level_number: int) -> Dictionary:
	var level_path: String = LEVEL_PATH_TEMPLATE % level_number
	if not FileAccess.file_exists(level_path):
		push_warning("Level file does not exist: %s" % level_path)
		return {}

	var file: FileAccess = FileAccess.open(level_path, FileAccess.READ)
	if file == null:
		push_warning("Could not open level file: %s" % level_path)
		return {}

	var parsed: Variant = JSON.parse_string(file.get_as_text())
	if typeof(parsed) != TYPE_DICTIONARY:
		push_warning("Level JSON must be an object: %s" % level_path)
		return {}
	return parsed as Dictionary


func _build_ui() -> void:
	var background := ColorRect.new()
	background.color = Color(0.05, 0.30, 0.21)
	background.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(background)

	var root := MarginContainer.new()
	root.set_anchors_preset(Control.PRESET_FULL_RECT)
	root.add_theme_constant_override("margin_left", 28)
	root.add_theme_constant_override("margin_top", 20)
	root.add_theme_constant_override("margin_right", 28)
	root.add_theme_constant_override("margin_bottom", 20)
	add_child(root)

	var layout := VBoxContainer.new()
	layout.add_theme_constant_override("separation", 14)
	root.add_child(layout)

	_add_top_bar(layout)
	_add_prompt(layout)
	_add_table(layout)
	_add_status(layout)


func _add_top_bar(parent: Node) -> void:
	var top_bar := HBoxContainer.new()
	top_bar.add_theme_constant_override("separation", 12)
	parent.add_child(top_bar)

	var back_button := Button.new()
	back_button.text = GameState.t("levels")
	back_button.custom_minimum_size = Vector2(110, 42)
	back_button.pressed.connect(_on_back_pressed)
	top_bar.add_child(back_button)

	var title := Label.new()
	title.text = "%s - %s %d" % [GameState.localized(level_data.get("title", "Bridge Puzzle")), GameState.t("levels"), GameState.selected_level]
	title.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override("font_size", 28)
	top_bar.add_child(title)

	var menu_button := Button.new()
	menu_button.text = GameState.t("menu")
	menu_button.custom_minimum_size = Vector2(110, 42)
	menu_button.pressed.connect(_on_menu_pressed)
	top_bar.add_child(menu_button)


func _add_prompt(parent: Node) -> void:
	prompt_label = Label.new()
	prompt_label.text = GameState.localized(level_data.get("prompt", ""))
	prompt_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	prompt_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	prompt_label.add_theme_font_size_override("font_size", 20)
	parent.add_child(prompt_label)


func _add_table(parent: Node) -> void:
	var table_panel := PanelContainer.new()
	table_panel.size_flags_vertical = Control.SIZE_EXPAND_FILL
	parent.add_child(table_panel)

	var table_margin := MarginContainer.new()
	table_margin.add_theme_constant_override("margin_left", 18)
	table_margin.add_theme_constant_override("margin_top", 18)
	table_margin.add_theme_constant_override("margin_right", 18)
	table_margin.add_theme_constant_override("margin_bottom", 18)
	table_panel.add_child(table_margin)

	var table_layout := VBoxContainer.new()
	table_layout.alignment = BoxContainer.ALIGNMENT_CENTER
	table_layout.add_theme_constant_override("separation", 20)
	table_margin.add_child(table_layout)

	var north_label := Label.new()
	north_label.text = GameState.t("dummy_north")
	north_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	north_label.add_theme_font_size_override("font_size", 18)
	table_layout.add_child(north_label)

	north_cards = HBoxContainer.new()
	north_cards.alignment = BoxContainer.ALIGNMENT_CENTER
	north_cards.add_theme_constant_override("separation", 10)
	table_layout.add_child(north_cards)
	_add_card_buttons(north_cards, _hand_for("N"), "N")

	table_cards = HBoxContainer.new()
	table_cards.alignment = BoxContainer.ALIGNMENT_CENTER
	table_cards.custom_minimum_size = Vector2(1, 138)
	table_cards.add_theme_constant_override("separation", 12)
	table_layout.add_child(table_cards)

	var south_label := Label.new()
	south_label.text = GameState.t("declarer_south")
	south_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	south_label.add_theme_font_size_override("font_size", 18)
	table_layout.add_child(south_label)

	south_cards = HBoxContainer.new()
	south_cards.alignment = BoxContainer.ALIGNMENT_CENTER
	south_cards.add_theme_constant_override("separation", 10)
	table_layout.add_child(south_cards)
	_add_card_buttons(south_cards, _hand_for("S"), "S")


func _add_status(parent: Node) -> void:
	status_label = Label.new()
	status_label.text = ""
	status_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	status_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	status_label.add_theme_font_size_override("font_size", 18)
	parent.add_child(status_label)

	var reset_button := Button.new()
	reset_button.text = GameState.t("reset")
	reset_button.custom_minimum_size = Vector2(180, 42)
	reset_button.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	reset_button.pressed.connect(_on_reset_pressed)
	parent.add_child(reset_button)


func _add_card_buttons(parent: Node, cards: Array, seat: String) -> void:
	for card_code in cards:
		var card_button := TextureButton.new()
		card_button.custom_minimum_size = Vector2(CARD_WIDTH, CARD_HEIGHT)
		card_button.ignore_texture_size = true
		card_button.stretch_mode = TextureButton.STRETCH_KEEP_ASPECT_CENTERED
		card_button.texture_normal = _load_card_texture(str(card_code))
		card_button.tooltip_text = "%s %s" % [seat, card_code]
		card_button.pressed.connect(_on_card_pressed.bind(str(card_code), seat, card_button))
		parent.add_child(card_button)


func _load_card_texture(card_code: String) -> Texture2D:
	var suit: String = card_code.substr(0, 1)
	var rank: String = card_code.substr(1, 1)
	var path: String = "res://Cards/simplecard_%s_%s.png" % [SUIT_NAMES[suit], RANK_IMAGE_NAMES[rank]]
	return load(path)


func _hand_for(seat: String) -> Array:
	var hands: Dictionary = level_data.get("hands", {})
	return hands.get(seat, [])


func _on_card_pressed(card_code: String, seat: String, button: TextureButton) -> void:
	if _is_finished():
		return

	var steps: Array = level_data.get("solution_steps", [])
	var step: Dictionary = steps[current_step]
	var expected_seat: String = str(step.get("seat", ""))
	var expected_cards: Array = step.get("cards", [])

	if seat != expected_seat:
		_mark_wrong(GameState.t("wrong_seat") % GameState.seat_name(expected_seat))
		return

	if not expected_cards.has(card_code):
		_mark_wrong(GameState.localized(step.get("wrong_message", GameState.t("wrong_card"))))
		return

	button.disabled = true
	chosen_cards.append(card_code)
	_add_played_card(card_code)
	current_step += 1

	if _is_finished():
		status_label.text = GameState.localized(level_data.get("success_message", GameState.t("success")))
		prompt_label.text = GameState.localized(level_data.get("explanation", ""))
	else:
		status_label.text = GameState.localized(step.get("correct_message", GameState.t("good")))
		_update_prompt()


func _add_played_card(card_code: String) -> void:
	var texture_rect := TextureRect.new()
	texture_rect.custom_minimum_size = Vector2(CARD_WIDTH, CARD_HEIGHT)
	texture_rect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	texture_rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	texture_rect.texture = _load_card_texture(card_code)
	table_cards.add_child(texture_rect)


func _mark_wrong(message: String) -> void:
	status_label.text = GameState.t("try_again") % message


func _update_prompt() -> void:
	if level_data.is_empty():
		prompt_label.text = GameState.t("level_missing")
		status_label.text = GameState.t("create_level")
		return

	if _is_finished():
		return

	var steps: Array = level_data.get("solution_steps", [])
	var step: Dictionary = steps[current_step]
	status_label.text = GameState.t("step_status") % [current_step + 1, steps.size(), GameState.localized(step.get("hint", GameState.t("choose_card")))]


func _is_finished() -> bool:
	var steps: Array = level_data.get("solution_steps", [])
	return current_step >= steps.size()


func _on_reset_pressed() -> void:
	get_tree().reload_current_scene()


func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/level_select.tscn")


func _on_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
