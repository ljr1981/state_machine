note
	description: "[
		Abstract notion of a {SM_GRAPH}.
		]"
	design: "[
		Based on making output of {SM_MACHINE} to
		a GraphViz diagram (digraph).
		]"
	EIS: "src=http://www.graphviz.org"
	EIS: "src=http://www.graphviz.org/content/fsm"
	EIS: "src=http://www.graphviz.org/Gallery/directed/fsm.gv.txt"
	EIS: "src=http://www.graphviz.org/content/dot-language"

deferred class
	SM_GRAPH

feature -- Outputs

	graph_out: STRING
			-- `graph_out' of Current {SM_GRAPH}.
		deferred
		end

feature {NONE} -- Implementation: Constants

	graph_template: STRING = "digraph finite_state_machine {rankdir=LR;size=%"8,5%" node [shape = circle];<<NODES>>}"

	node_template: STRING = "<<FROM>> -> <<TO>> [ label = %"<<LABEL>>%" ];"

end
