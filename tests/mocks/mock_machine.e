note
	description: "[
		Mock {SM_MACHINE}
		]"

class
	MOCK_MACHINE

inherit
	SM_MACHINE
		redefine
			default_create
		end

feature {NONE} -- Initialization

	default_create
			-- <Precursor>
		do
				-- Listener for MOCK_DOOR trigger events
			create on_open_subscription
			add_subscriptions (<<on_open_subscription>>)
				-- Publisher for MOCK_DOOR post-event subscriptions
			create on_post_open_publication
			add_publication (on_post_open_publication)
		end

feature -- Event Publications

	on_post_open_publication: PS_PUBLICATION [ANY]

feature -- Event Subscriptions

	on_open_subscription: PS_SUBSCRIPTION [ANY]

feature -- Event Handlers

	on_post_open (a_data: ANY)
		do
			-- do something?
		end

end
