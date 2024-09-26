extends Resource

class_name Dialogue

func load_from_file(file: String):
	var parser := XMLParser.new()
	parser.open(file)
	parse(parser)

func parse(parser: XMLParser):
	if parser.read() == ERR_FILE_EOF: return
	
	var node_type := parser.get_node_type()
	if node_type == parser.NODE_UNKNOWN: parse(parser)
	if node_type == parser.NODE_COMMENT: parse(parser)
	if node_type == parser.NODE_TEXT: parse(parser)
	
	var node_name := parser.get_node_name()
	
	#if node_name == 'line':
	var node = XMLNode.new()
	node.name = node_name
	node.type = node_type
	for i in parser.get_attribute_count():
		var attribute_name = parser.get_attribute_name(i)
		var attribute_value = parser.get_attribute_value(i)
		
		node.attributes[attribute_name] = attribute_value
	
