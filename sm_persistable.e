note
	description: "[
		Abstract notion of a {SM_PERSISTABLE} thing.
		]"
	design: "[
		Works in conjunction with {SM_PERSISTENCE_MACHINE}, providing
		a framework by which to give the machine something to persist.
		]"

deferred class
	SM_PERSISTABLE

inherit
	PS_SUBSCRIPTION [ANY]

	PS_PUBLICATION [ANY]

end
