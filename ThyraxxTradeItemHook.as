namespace itemtrading
{
	TradingWindow@ m_tradingWindow;

	[Hook]
	void GameModeStart(AGameplayGameMode@ aGameplayGameMode, SValue@ save) 
	{
		print("We are here--");
		@m_tradingWindow = TradingWindow(aGameplayGameMode.m_guiBuilder);
	}

	[Hook]
	void PickedCharacter(PlayerRecord@ record)
	{
		//m_tradingWindow.m_equipmentWidget.SetOwner(record);
		m_tradingWindow.m_equipmentInventoryWidget.SetOwner(record);
		//m_tradingWindow.m_equipmentInventoryWidget.SetOwner(record);
		//m_tradingWindow.m_equipmentInventoryWidget.SetOwner(GetLocalPlayerRecord());


		//@m_tradingWindow.m_equipmentInventoryWidget = cast<TradingEquipmentInventoryWidget>(m_tradingWindow.m_widget.GetWidgetById("equipment-inventory"));
		//@m_tradingWindow.m_equipmentInventoryWidget.m_itemTemplate = cast<EquipmentItemWidget>(m_tradingWindow.m_widget.GetWidgetById("equipment-item-template"));

	}

	[Hook]
	void GameModeUpdate(BaseGameMode@ baseGameMode, int ms, GameInput& gameInput, MenuInput& menuInput) 
	{
		if(m_tradingWindow is null)
			return;

		if(Platform::GetKeyState(58).Pressed)
		{
			print("trading window activated");
			
			if(cast<TradingWindow>(baseGameMode.m_windowManager.GetCurrentWindow()) is null)
				baseGameMode.m_windowManager.AddWindowObject(m_tradingWindow);
			else
				baseGameMode.m_windowManager.CloseWindow(m_tradingWindow);
		}
	}

	[Hook]
	void LoadWidgetProducers(GUIBuilder@ builder) 
	{
		builder.AddWidgetProducer("tradingequipmentinventory", LoadTradingEquipmentInventoryWidget);
		builder.AddWidgetProducer("tradingequipmentitem", LoadTradingEquipmentInventoryWidget);
	}

}