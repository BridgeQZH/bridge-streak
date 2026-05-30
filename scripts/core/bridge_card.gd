class_name BridgeCard
extends RefCounted


const SUITS := ["S", "H", "D", "C"]
const RANKS := ["A", "K", "Q", "J", "T", "9", "8", "7", "6", "5", "4", "3", "2"]

var suit: String
var rank: String


func _init(card_suit: String = "", card_rank: String = "") -> void:
	suit = card_suit
	rank = card_rank


static func full_deck() -> Array[BridgeCard]:
	var deck: Array[BridgeCard] = []
	for deck_suit in SUITS:
		for deck_rank in RANKS:
			deck.append(BridgeCard.new(deck_suit, deck_rank))
	return deck


static func from_code(code: String) -> BridgeCard:
	var normalized := code.strip_edges().to_upper()
	if normalized.length() != 2:
		return BridgeCard.new()
	return BridgeCard.new(normalized.substr(0, 1), normalized.substr(1, 1))


func is_valid() -> bool:
	return SUITS.has(suit) and RANKS.has(rank)


func code() -> String:
	return "%s%s" % [suit, rank]


func equals(other: BridgeCard) -> bool:
	return other != null and suit == other.suit and rank == other.rank
