class_name BridgeDeal
extends RefCounted


const BridgeHandScript := preload("res://scripts/core/bridge_hand.gd")
const SEATS := ["N", "E", "S", "W"]
const CARDS_PER_HAND := 13
const DECK_SIZE := 52

var hands := {}


func _init(initial_hands := {}) -> void:
	for seat in SEATS:
		if initial_hands.has(seat):
			hands[seat] = initial_hands[seat]
		else:
			hands[seat] = BridgeHandScript.new()


static func from_deck(deck: Array) -> BridgeDeal:
	var deal := BridgeDeal.new()
	for index in range(deck.size()):
		var seat: String = SEATS[int(index / CARDS_PER_HAND)]
		deal.hand_for(seat).add_card(deck[index])
	return deal


static func from_code_lists(north: Array[String], east: Array[String], south: Array[String], west: Array[String]) -> BridgeDeal:
	return BridgeDeal.new({
		"N": BridgeHandScript.from_codes(north),
		"E": BridgeHandScript.from_codes(east),
		"S": BridgeHandScript.from_codes(south),
		"W": BridgeHandScript.from_codes(west),
	})


func hand_for(seat: String) -> Variant:
	return hands.get(seat, BridgeHandScript.new())


func all_cards() -> Array:
	var cards: Array = []
	for seat in SEATS:
		cards.append_array(hand_for(seat).cards)
	return cards


func card_count() -> int:
	return all_cards().size()


func duplicate_codes() -> Array[String]:
	var seen := {}
	var duplicates: Array[String] = []
	for card in all_cards():
		var card_code: String = card.code()
		if seen.has(card_code) and not duplicates.has(card_code):
			duplicates.append(card_code)
		seen[card_code] = true
	return duplicates


func is_valid() -> bool:
	if card_count() != DECK_SIZE:
		return false
	if not duplicate_codes().is_empty():
		return false
	for seat in SEATS:
		if not hand_for(seat).is_valid():
			return false
	return true
