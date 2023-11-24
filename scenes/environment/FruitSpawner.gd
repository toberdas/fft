extends Spatial


const ThreeDItem = preload("res://scenes/item/3DItem.tscn")
const defaultFruit = preload("res://assets/resources/items/specificItems/bait/CauliflowerMushroom.tres")

var currentFruit = null
var growing = false
var growth = 0.0
var growthTarget = 24.0

func _process(delta):
	if growing:
		grow_fruit(delta)

func grow_fruit(time):
	growth += time
	if growth >= growthTarget:
		fruit_ready()

func fruit_ready():
	growing = false
	var fruitData = defaultFruit
	currentFruit = $ItemSpawner.spawn_3d_item_from_resource(fruitData)
	$Bush.grow_on_bush(currentFruit)
	currentFruit.connect("item_gone", self, "fruit_dropped")
	currentFruit.freeze()

func fruit_dropped():
	currentFruit = null
	start_growing()

func start_growing():
	growth = 0.0
	growing = true

func drop_fruit():
	if currentFruit:
		currentFruit.unfreeze()
		fruit_dropped()
