# ############################################################################ #
# Copyright © 2021 Piet Bronders <piet.bronders@gmail.com>
# Licensed under the MIT License.
# See LICENSE in the project root for license information.
# ############################################################################ #

tool
extends EditorPlugin

func _enter_tree():
	add_autoload_singleton("ProfanityCheck", "res://addons/profanity-check/plugin.gd")

func _exit_tree():
	remove_autoload_singleton("ProfanityCheck")
