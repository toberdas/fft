extends StaticBody

signal stepped_on

func stepped_on_by_player(_col):
	emit_signal("stepped_on")
