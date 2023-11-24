extends Spatial
class_name ExpressionReceiverNode

var myExpression = ''
var needsBody = false

func receive_expression(expression, body = null):
	if expression is String:
		if expression == myExpression:
			if needsBody == false:
				run()
			if needsBody == true:
				run_with_body(body)
			
func run():
	pass

func run_with_body(body):
	pass
