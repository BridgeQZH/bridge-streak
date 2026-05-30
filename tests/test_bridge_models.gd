extends SceneTree


const BridgeCardScript := preload("res://scripts/core/bridge_card.gd")
const BridgeDealScript := preload("res://scripts/core/bridge_deal.gd")

var failures: Array[String] = []


func _initialize() -> void:
	_test_full_deck_has_52_unique_cards()
	_test_deal_splits_into_four_complete_hands()
	_test_duplicate_card_invalidates_deal()

	if failures.is_empty():
		print("Bridge model tests passed.")
		quit(0)
	else:
		for failure in failures:
			push_error(failure)
		quit(1)


func _assert(condition: bool, message: String) -> void:
	if not condition:
		failures.append(message)


func _test_full_deck_has_52_unique_cards() -> void:
	var deck := BridgeCardScript.full_deck()
	var seen := {}

	_assert(deck.size() == 52, "A full bridge deck must contain 52 cards.")

	for card in deck:
		_assert(card.is_valid(), "Card must be valid: %s" % card.code())
		_assert(not seen.has(card.code()), "Card must be unique: %s" % card.code())
		seen[card.code()] = true

	_assert(seen.size() == 52, "A full bridge deck must have 52 unique codes.")


func _test_deal_splits_into_four_complete_hands() -> void:
	var deal := BridgeDealScript.from_deck(BridgeCardScript.full_deck())

	_assert(deal.is_valid(), "A deal created from a full deck must be valid.")
	_assert(deal.card_count() == 52, "A deal must contain 52 cards.")
	_assert(deal.duplicate_codes().is_empty(), "A deal must not contain duplicate cards.")

	for seat in BridgeDealScript.SEATS:
		_assert(deal.hand_for(seat).size() == 13, "%s hand must contain 13 cards." % seat)
		_assert(deal.hand_for(seat).is_valid(), "%s hand must be valid." % seat)


func _test_duplicate_card_invalidates_deal() -> void:
	var deck := BridgeCardScript.full_deck()
	deck[51] = deck[0]
	var deal := BridgeDealScript.from_deck(deck)

	_assert(not deal.is_valid(), "A deal with a duplicate card must be invalid.")
	_assert(deal.duplicate_codes().size() == 1, "Duplicate deal must report one duplicated card code.")
