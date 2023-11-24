extends Spatial

export(NodePath) var playerTracker

var env = null

signal update_mood

func _ready():
	playerTracker = get_node(playerTracker)

func _on_IslandNode_start_initialize(_save):
	$UpdateTimer.start()
#	$MusicPlayer.start(res.islandVibeResource.islandMusic)
#	$MotifCollectionPlayer.start(res.scale, res.motifCollection)
	
func _on_IslandNode_start_deinitialize():
	$MusicPlayer.stop()
	$UpdateTimer.stop()

func _on_UpdateTimer_timeout():
	if playerTracker.distanceRatio:
		emit_signal("update_mood", playerTracker.distanceRatio)
