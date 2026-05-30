class_name BridgeHand
extends RefCounted


const BridgeCardScript := preload("res://scripts/core/bridge_card.gd")
const HAND_SIZE := 13

var cards: Array = []


func _init(initial_cards: Array = []) -> void:
	for card in initial_cards:
		add_card(card)


static func from_codes(codes: Array[String]) -> BridgeHand:
	var hand := BridgeHand.new()
	for code in codes:
		hand.add_card(BridgeCardScript.from_code(code))
	return hand


func add_card(card: Variant) -> void:
	cards.append(card)


func size() -> int:
	return cards.size()


func is_complete() -> bool:
	return cards.size() == HAND_SIZE


func has_card(card: Variant) -> bool:
	for hand_card in cards:
		if hand_card.equals(card):
			return true
	return false


func card_codes() -> Array[String]:
	var codes: Array[String] = []
	for card in cards:
		codes.append(card.code())
	return codes


func duplicate_codes() -> Array[String]:
	var seen := {}
	var duplicates: Array[String] = []
	for card in cards:
		var card_code: String = card.code()
		if seen.has(card_code) and not duplicates.has(card_code):
			duplicates.append(card_code)
		seen[card_code] = true
	return duplicates


func is_valid() -> bool:
	if not is_complete():
		return false
	if not duplicate_codes().is_empty():
		return false
	for card in cards:
		if card == null or not card.is_valid():
			return false
	return true
