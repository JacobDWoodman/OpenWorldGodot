extends RichTextLabel

func update_talk(dialogue):
	set_bbcode(dialogue)
	set_visible_characters(0)

func all_text_visible():
	return get_visible_characters() >= get_total_character_count()

func set_all_text_visible():
	set_visible_characters(get_total_character_count())
