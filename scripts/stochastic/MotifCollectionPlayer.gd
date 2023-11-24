extends Spatial
class_name MotifCollectionPlayer

var paused = false
var scaley = null
var collection = null
var motifDistribution = null
var timer = null
export(Curve) var falloffCurve

var motifPlayer = null

func init(_scale, _collection):
	scaley = _scale
	collection = _collection

func start(_scale, _collection):
	motifPlayer = MotifPlayer.new()

	add_child(motifPlayer)
	scaley = _scale
	collection = _collection
	fill_dist(collection.randomMotifs)
	var wt = collection.spacing + (randf() * 12.0)
	timer = get_tree().create_timer(wt)
	timer.connect("timeout", self, "play_motif")
#	play_motif()

func unpause():
	if paused:
		if motifPlayer:
			motifPlayer.unmute()
			paused = false

func pause():
	if !paused:
		if motifPlayer:
			motifPlayer.mute()
			paused = true
	
func play_motif():
	if motifPlayer:
		var m = motifDistribution.roll(true)
		if m:
			if randf() > .8:
				m.scale.make_tonic()
			motifPlayer.play_motif(m)
			var wt = collection.spacing + (randf() * 12.0)
			timer = get_tree().create_timer(wt)
			timer.connect("timeout", self, "play_motif")
		else:
			fill_dist(collection.randomMotifs)
			play_motif()

func fill_dist(motifs):
	motifDistribution = WeightedDistribution.new()
	for motif in motifs:
		motifDistribution.add_option(motif, 5)

func _on_VibeManager_update_mood(rat):
	if rat:
		if motifPlayer:
			motifPlayer.dynamicBase = falloffCurve.interpolate(rat) * 0.0
