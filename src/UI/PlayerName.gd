extends LineEdit



func _ready():
	$HTTPRequest.request("https://www.generateur-de-pseudo.fr/")



func _on_HTTPRequest_request_completed(result, response_code, headers, body):
	var toSearchOn : String = body.get_string_from_utf8()
	var pseudoBeginPos = toSearchOn.find("pseudo-list")

	print(pseudoBeginPos)
	toSearchOn = toSearchOn.right(pseudoBeginPos)
	
	var pseudoEnd = toSearchOn.find("</")
	
	print(pseudoEnd)
	toSearchOn = toSearchOn.left(pseudoEnd)
	toSearchOn = toSearchOn.right(toSearchOn.find("<p>") + 3)
	if len(toSearchOn) > 0:
		text = toSearchOn
	
