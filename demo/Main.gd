extends Node

func _ready():
	print(ProfanityCheck.is_dirty("cocksucker"))
	print(ProfanityCheck.is_dirty("dick"))

	print(ProfanityCheck.is_dirty("protection"))
