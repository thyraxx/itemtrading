namespace itemtrading
{
	//class TradeRequest : AWindowObject
	class TradeRequest : HUDComponent
	{
		GameInput@ gameInput;
		MenuInput@ menuInput;
		WindowInput@ m_input;
		WindowManager@ m_manager;
		bool m_usePressed;
		//KeyNavigationBar@ m_navigationBar;

		AInteractableWidget@ m_widgetTradeAccept;
		AInteractableWidget@ m_widgetTradeDeny;
		TextWidget@ m_textWidget;

		int m_inputTickC;

		TradeRequest(GUIBuilder@ b, WindowManager@ windowManager) 
		{
			super(b, "gui_itemtrade/traderequest.gui");
			m_visible = false;
			@m_manager = windowManager;

			@m_input = WindowInput();
			//@m_navigationBar = KeyNavigationBar( cast<AWindowObject>(this) );

			@m_widgetTradeAccept = cast<AInteractableWidget>(m_widget.GetWidgetById("tradeaccept"));
			@m_widgetTradeDeny = cast<AInteractableWidget>(m_widget.GetWidgetById("tradedeny"));
			@m_textWidget = cast<TextWidget>(m_widget.GetWidgetById("name"));

			RefreshInteractableWidgets(m_widget);
			OnInteractableIndexChanged();
		}

		void RefreshInteractableWidgets(Widget@ widget)
		{
			m_input.RefreshInteractableWidgets(widget);
		}

		void Update(int dt, PlayerRecord@ record) override
		{
			HUDComponent::Update(dt, record);

			if(gameInput is null)
				@gameInput = GetInput();

			if(menuInput is null)
				@menuInput = GetMenuInput();

			if(gameInput is null || menuInput is null || m_input is null){
				print("gameInput, menuinput or m_input is null");
				return;
			}

			vec2 giMoveDir = gameInput.MoveDir;
			
			//if (m_waitForUp)
			//{
				if ((menuInput.Up.Down || menuInput.Down.Down || menuInput.Left.Down || menuInput.Right.Down) || (giMoveDir.x != 0 || giMoveDir.y != 0))
					return; //;return m_closing;

			//	m_waitForUp = false;
			//}

			if (m_inputTickC > 0)
				m_inputTickC -= dt;

			ivec2 cachedInteractableIndex = m_input.m_interactableIndex;
			auto gm = cast<BaseGameMode>(g_gameMode);
			vec2 mousePos = gm.GetMousePos();

			if (abs(giMoveDir.x) > abs(giMoveDir.y))
				giMoveDir.y = 0;
			else
				giMoveDir.x = 0;


			// Update mouse
			bool wasNotMouseHovering = m_input.m_hovering is null && m_input.m_mouseOnlyHovering is null;
			m_input.UpdateMouseInputs(m_origin, 
				vec4(m_origin.x, m_origin.y,
					gm.m_wndSWidth, gm.m_wndSHeight), 
				vec2(mousePos.x / gm.m_wndScale, mousePos.y / gm.m_wndScale),
				gameInput.UsingGamepad);

			if (wasNotMouseHovering && (m_input.m_hovering !is null || m_input.m_mouseOnlyHovering !is null))
				OnInteractableIndexChanged();

			// Use pressed
			if ((menuInput.Forward.Pressed) && !m_usePressed)
			{
				m_manager.LockInput(false);
				if (!gameInput.UsingGamepad && m_input.m_usingMouse)
				{
					if (m_input.m_hovering !is null && m_input.m_hovering.Enabled())
					{
						m_input.m_hovering.ClickDown(m_input.m_usingMouse, mousePos / gm.m_wndScale);
						m_usePressed = true;
					}
				}
				else if (m_input.IsInBounds() && m_input.m_interactables[cachedInteractableIndex.x][cachedInteractableIndex.y].Enabled())
				{
					m_input.m_interactables[cachedInteractableIndex.x][cachedInteractableIndex.y].ClickDown(m_input.m_usingMouse, mousePos / gm.m_wndScale);
					m_usePressed = true;
				}
			}
			// Use released
			else if ((menuInput.Forward.Released) && m_usePressed)
			{
				if (!gameInput.UsingGamepad && m_input.m_usingMouse)
				{
					if (m_input.m_hovering !is null && m_input.m_hovering.Enabled())
					{
						m_input.m_hovering.ClickUp(m_input.m_usingMouse, mousePos / gm.m_wndScale);
						m_usePressed = false;
					}
				}
				else if (m_input.IsInBounds() && m_input.m_interactables[cachedInteractableIndex.x][cachedInteractableIndex.y].Enabled())
				{
					m_input.m_interactables[cachedInteractableIndex.x][cachedInteractableIndex.y].ClickUp(m_input.m_usingMouse, mousePos / gm.m_wndScale);
					m_usePressed = false;
				}
			}

			if (m_manager.m_lockInput)
				return; //;return m_closing;
			
			// MenuContext
			else if (m_input.m_menuContextOnUp !is null && menuInput.ContextMenu.Released)
				m_input.m_menuContextOnUp();
			else if (m_input.m_menuContextOnPressed !is null && menuInput.ContextMenu.Pressed)
				m_input.m_menuContextOnPressed();
			else if (m_input.m_menuContextOnDown !is null && menuInput.ContextMenu.Down)
				m_input.m_menuContextOnDown(dt);

			// MenuAdditional
			else if (m_input.m_menuAdditionalOnUp !is null && menuInput.Additional.Released)
				m_input.m_menuAdditionalOnUp();
			else if (m_input.m_menuAdditionalOnPressed !is null && menuInput.Additional.Pressed)
				m_input.m_menuAdditionalOnPressed();
			else if (m_input.m_menuAdditionalOnDown !is null && menuInput.Additional.Down)
				m_input.m_menuAdditionalOnDown(dt);

			// Early return after mouse stuff
			else if (!m_input.IsInBounds() || m_input.m_disableControls || m_input.isEmpty())
				return; //;return m_closing;

			// Up
			else if (menuInput.Up.Pressed || ((menuInput.Up.Down || giMoveDir.y < 0) && m_inputTickC <= 0))
			{
				m_input.m_failC = 0;
				m_input.m_interactableIndex = m_input.OnUp(m_input.m_interactableIndex);
				m_inputTickC = g_inputTick;
				m_input.m_usingMouse = false;
			}
			// Down
			else if (menuInput.Down.Pressed || ((menuInput.Down.Down || giMoveDir.y > 0) && m_inputTickC <= 0))
			{
				m_input.m_failC = 0;
				m_input.m_interactableIndex = m_input.OnDown(m_input.m_interactableIndex);
				m_inputTickC = g_inputTick;
				m_input.m_usingMouse = false;
			}
			// Left
			else if (menuInput.Left.Pressed || ((menuInput.Left.Down || giMoveDir.x < 0) && m_inputTickC <= 0))
			{
				m_input.m_failC = 0;
				m_input.m_interactableIndex = m_input.OnLeft(m_input.m_interactableIndex);
				m_inputTickC = g_inputTick;
				m_input.m_usingMouse = false;
			}
			// Right
			else if (menuInput.Right.Pressed || ((menuInput.Right.Down || giMoveDir.x > 0) && m_inputTickC <= 0))
			{
				m_input.m_failC = 0;
				m_input.m_interactableIndex = m_input.OnRight(m_input.m_interactableIndex);
				m_inputTickC = g_inputTick;
				m_input.m_usingMouse = false;
			}

			// Set new hover
			if (cachedInteractableIndex.x != m_input.m_interactableIndex.x || cachedInteractableIndex.y != m_input.m_interactableIndex.y)
			{
				if (m_input.IsInBounds(cachedInteractableIndex))
					m_input.m_interactables[cachedInteractableIndex.x][cachedInteractableIndex.y].Leave();

				m_input.m_interactables[m_input.m_interactableIndex.x][m_input.m_interactableIndex.y].Hover();

				OnInteractableIndexChanged();
			}
			else if (m_input.IsInBounds(cachedInteractableIndex) && !m_input.GetCurrentInteractable().m_hovering && !m_input.m_usingMouse)
			{
				m_input.m_interactables[m_input.m_interactableIndex.x][m_input.m_interactableIndex.y].Hover();
				OnInteractableIndexChanged();
			}
		}

		// TODO: Not used for anything currently?
		void OnInteractableIndexChanged()
		{
			auto currInteractable = m_input.GetCurrentInteractable();
			if (currInteractable is null)
				return;

			//print(currInteractable.m_id);

			//array<string>@ rawTexts = currInteractable.NavigationBarText();
			//array<KeyNavigationText@> navTexts;
			//for (uint i = 0; i < rawTexts.length(); i++)
			//	navTexts.insertLast(KeyNavigationText(m_navigationBar.m_font.BuildText(rawTexts[i])));

			//m_navigationBar.BuildBar(navTexts, cast<AWindowObject>(this) );
		}



		void OnFunc(Widget@ sender, const string &in name) override 
		{
			auto gm = cast<BaseGameMode>(g_gameMode);

			print("OnFunc: " + name);
			auto parse = name.split(" ");
			if(parse[0] == "accept") {
				print("trade accepted");
				(Network::Message("TradeRequestAccept")).SendToPeer( parseInt(parse[1]) );
				m_manager.AddWindowObject(m_tradingWindow);
			}

			if(parse[0] == "deny") {
				print("trade denied");
				m_tradeStatus.Reset();
				(Network::Message("TradeRequestDeny")).SendToPeer( parseInt(parse[1]) );
			}

			m_visible = false;
		}
	}
}