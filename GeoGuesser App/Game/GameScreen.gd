extends Panel

onready var streetView = $StreetView
onready var button1 = $Options/Panel/HBoxContainer/Button
onready var button2 = $Options/Panel/HBoxContainer/Button2
onready var button3 = $Options/Panel/HBoxContainer/Button3
onready var button4 = $Options/Panel/HBoxContainer/Button4


func _ready():
	http_request()


func http_request():
	# Create an HTTP request noe and connect its completion signal.
	var http_request = HTTPRequest.new()
	add_child(http_request)
	http_request.connect("request_completed", self, "_http_request_completed")
	
	# Perform the HTTP request. The URL below returns a PNG image as of writing.
	var error = http_request.request("https://lh3.googleusercontent.com/2hDpuTi-0AMKvoZJGd-yKWvK4tKdQr_kLIpB_qSeMau2TNGCNidAosMEvrEXFO9G6tmlFlPQplpwiqirgrIPWnCKMvElaYgI-HiVvXc=w600")
	if error != OK:
		push_error("an error occured in the HTTP request.") 


func _http_request_completed(result, response_code, headers, body):
	var image = Image.new()
	var error = image.load_png_from_buffer(body)
	if error != OK:
		push_error("Couldn't load the image.")
	
	var texture = ImageTexture.new()
	texture.create_from_image(image)
	
	# Display the image in a TextureRect node.
	streetView.texture = texture


func _on_Button4_pressed():
	pass # Replace with function body.


func _on_Button3_pressed():
	pass # Replace with function body.


func _on_Button2_pressed():
	pass # Replace with function body.


func _on_Button_pressed():
	pass # Replace with function body.


func _on_Countdown_timer_ended():
	http_request()
