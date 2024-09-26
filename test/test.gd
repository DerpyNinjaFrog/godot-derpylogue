extends PanelContainer

const PATH = 'res://test/test.xml'

var parser = XMLParser.new()

@onready var name_label: Label = $VBoxContainer/NameLabel
@onready var text_label: RichTextLabel = $VBoxContainer/TextLabel
@onready var options_container: VBoxContainer = $VBoxContainer/OptionsContainer

func _ready() -> void:
	parser.open(PATH)

func next_line():
	parser.read()
	
	if parser.get_node_type() != parser.NODE_TEXT:
		if parser.get_node_type() == parser.NODE_UNKNOWN: next_line(); return;
		
		if parser.get_node_name() == 'line':
			if parser.has_attribute('character'):
				name_label.text = parser.get_named_attribute_value('character')
			
			var last_node_name = ''
			while not (parser.get_node_type() == parser.NODE_ELEMENT_END and parser.get_node_name() == 'line'):
				var node_type = parser.get_node_type()
				print(_get_node_type_string(node_type))
				if node_type == parser.NODE_TEXT:
					if last_node_name == 'line':
						text_label.text = parser.get_node_data()
				else:
					var node_name = parser.get_node_name()
					print(node_name)
					if parser.has_attribute('character'):
						name_label.text = parser.get_named_attribute_value('character')
					
					last_node_name = node_name
				
				parser.read()
			
		elif parser.get_node_name() == 'options':
			if parser.has_attribute('character'):
				name_label.text = parser.get_named_attribute_value('character')
			
			var last_node_name = ''
			var last_button
			while not (parser.get_node_type() == parser.NODE_ELEMENT_END and parser.get_node_name() == 'options'):
				var node_type = parser.get_node_type()
				print(_get_node_type_string(node_type))
				if node_type == parser.NODE_TEXT:
					if last_node_name == 'line':
						text_label.text = parser.get_node_data()
					elif last_node_name == 'prompt':
						name_label.text = parser.get_node_data()
					elif last_node_name == 'option':
						last_button.text = parser.get_node_data()
				else:
					var node_name = parser.get_node_name()
					print(node_name)
					if parser.has_attribute('character'):
						name_label.text = parser.get_named_attribute_value('character')
					
					if parser.has_attribute('to'):
						var option_button = Button.new()
						options_container.add_child(option_button)
						option_button.pressed.connect(_on_option_button_pressed.bind(parser.get_named_attribute_value('to')))
						
						last_button = option_button
					
					last_node_name = node_name
				
				parser.read()
	else:
		next_line()

func _get_node_type_string(node_type: XMLParser.NodeType) -> String:
	match node_type:
		XMLParser.NODE_NONE:
			return 'NODE_NONE'
		XMLParser.NODE_ELEMENT:
			return 'NODE_ELEMENT'
		XMLParser.NODE_ELEMENT_END:
			return 'NODE_ELEMENT_END'
		XMLParser.NODE_TEXT:
			return 'NODE_TEXT'
		XMLParser.NODE_COMMENT:
			return 'NODE_COMMENT'
		XMLParser.NODE_CDATA:
			return 'NODE_CDATA'
		XMLParser.NODE_UNKNOWN:
			return 'NODE_UNKNOWN'
	return ''

func _on_continue_pressed() -> void:
	next_line()

func _on_option_button_pressed(to_id: String) -> void:
	pass
