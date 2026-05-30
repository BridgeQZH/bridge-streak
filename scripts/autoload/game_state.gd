extends Node


const LANGUAGE_ZH := "zh"
const LANGUAGE_EN := "en"

var selected_level: int = 1
var language: String = LANGUAGE_ZH

var ui_text := {
	"choose_language": {
		"zh": "选择语言",
		"en": "Choose Language",
	},
	"subtitle": {
		"zh": "桥牌闯关训练",
		"en": "Bridge puzzle training",
	},
	"start": {
		"zh": "开始闯关",
		"en": "Start",
	},
	"quit": {
		"zh": "退出",
		"en": "Quit",
	},
	"back": {
		"zh": "返回",
		"en": "Back",
	},
	"levels": {
		"zh": "关卡",
		"en": "Levels",
	},
	"select_level": {
		"zh": "选择关卡",
		"en": "Select Level",
	},
	"level_card": {
		"zh": "第 %d 关\n牌张训练",
		"en": "Level %d\nCard Play",
	},
	"menu": {
		"zh": "主菜单",
		"en": "Menu",
	},
	"reset": {
		"zh": "重置题目",
		"en": "Reset Puzzle",
	},
	"dummy_north": {
		"zh": "明手 / 北",
		"en": "Dummy / North",
	},
	"declarer_south": {
		"zh": "庄家 / 南",
		"en": "Declarer / South",
	},
	"level_missing": {
		"zh": "关卡数据缺失。",
		"en": "Level data missing.",
	},
	"create_level": {
		"zh": "请创建 data/levels/001.json 后重试。",
		"en": "Create data/levels/001.json and try again.",
	},
	"choose_card": {
		"zh": "请选择一张牌。",
		"en": "Choose a card.",
	},
	"step_status": {
		"zh": "步骤 %d/%d：%s",
		"en": "Step %d/%d: %s",
	},
	"wrong_seat": {
		"zh": "这一步应该从 %s 出牌。",
		"en": "This play must come from %s.",
	},
	"try_again": {
		"zh": "%s 请再试一次。",
		"en": "%s Try again.",
	},
	"success": {
		"zh": "成功。",
		"en": "Success.",
	},
	"good": {
		"zh": "很好。",
		"en": "Good.",
	},
	"wrong_card": {
		"zh": "这张牌不是正确选择。",
		"en": "That is not the right card.",
	},
	"north": {
		"zh": "明手",
		"en": "dummy",
	},
	"south": {
		"zh": "南手",
		"en": "South",
	},
}


func set_language(new_language: String) -> void:
	if new_language == LANGUAGE_EN:
		language = LANGUAGE_EN
	else:
		language = LANGUAGE_ZH


func t(key: String) -> String:
	var entry: Variant = ui_text.get(key, {})
	if typeof(entry) != TYPE_DICTIONARY:
		return key
	return _localized(entry as Dictionary)


func localized(value: Variant) -> String:
	if typeof(value) == TYPE_DICTIONARY:
		return _localized(value as Dictionary)
	return str(value)


func seat_name(seat: String) -> String:
	if seat == "N":
		return t("north")
	if seat == "S":
		return t("south")
	return seat


func _localized(entry: Dictionary) -> String:
	if entry.has(language):
		return str(entry[language])
	if entry.has(LANGUAGE_EN):
		return str(entry[LANGUAGE_EN])
	if entry.has(LANGUAGE_ZH):
		return str(entry[LANGUAGE_ZH])
	return ""
