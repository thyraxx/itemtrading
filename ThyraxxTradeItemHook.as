namespace itemtrading
{

	TradeRequest@ m_tradeRequest;
	TradingWindow@ m_tradingWindow;
	TradePlayerListWindow@ m_tradePlayerList;
	Trade@ m_trade = Trade();

	[Hook]
	void GameModeStart(AGameplayGameMode@ aGameplayGameMode, SValue@ save) 
	{
		print("We are here--");
		// Offer window
		@equipInventoryOffer = EquipmentInventory(GetLocalPlayerRecord());
		equipInventoryOffer.m_maxItems = 9;
		
		// Counter offer window
		@equipInventoryCounterOffer = EquipmentInventory(GetLocalPlayerRecord());
		equipInventoryCounterOffer.m_maxItems = 9;
		
		@m_tradingWindow = TradingWindow(aGameplayGameMode.m_guiBuilder);
		//@m_tradeRequest = TradeRequest(aGameplayGameMode.m_guiBuilder);

		print("isServer: " + Network::IsServer());
	}

	[Hook]
	void PickedCharacter(PlayerRecord@ record)
	{
		m_equipmentTradingInventoryWidget.SetOwner(record);
	}

	[Hook]
	void GameModeUpdate(BaseGameMode@ baseGameMode, int ms, GameInput& gameInput, MenuInput& menuInput) 
	{
		// Keycode 58 = F1
		if(!Platform::GetKeyState(58).Pressed)
			return;

		// Showing how many Window objects there are, if 0 you don't have any UI windows open like Character sheet or guild hall
		//print("m_objects.length(): " + baseGameMode.m_windowManager.m_objects.length());
		
		if(baseGameMode.m_windowManager.GetCurrentWindow() is null && baseGameMode.m_windowManager.m_objects.length() == 0)
			baseGameMode.m_windowManager.AddWindowObject(@m_tradePlayerList = TradePlayerListWindow(baseGameMode.m_guiBuilder));
		else
			baseGameMode.m_windowManager.CloseWindow(m_tradePlayerList);
	}

	[Hook]
	void GameModePostStart(AGameplayGameMode@ aGameplayGameMode) {
		print("GameModePostStart---");
	}

	[Hook]
	void HUDConstructor(HUD@ hud, GUIBuilder@ guiBuilder) {
		hud.m_components.insertLast(@m_tradeRequest = TradeRequest(guiBuilder, cast<BaseGameMode>(g_gameMode).m_windowManager));
	}

	[Hook]
	void LoadWidgetProducers(GUIBuilder@ builder) 
	{
		builder.AddWidgetProducer("tradingequipmentinventory", LoadTradingEquipmentInventoryWidget);
		builder.AddWidgetProducer("tradingequipmentinventoryoffer", LoadTradingEquipmentInventoryOfferWidget);
		builder.AddWidgetProducer("tradingequipmentinventorycounteroffer", LoadTradingEquipmentInventoryCounterOfferWidget);
	}

}

EquipmentInventory@ equipInventoryOffer;
EquipmentInventory@ equipInventoryCounterOffer;
TradingEquipmentInventoryWidget@ m_equipmentTradingInventoryWidget;
TradingEquipmentInventoryOfferWidget@ m_equipmentInventoryWidgetOffer;
TradingEquipmentInventoryCounterOfferWidget@ m_equipmentInventoryWidgetCounterOffer;
