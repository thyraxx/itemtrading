namespace itemtrading
{

	TradingWindow@ m_tradingWindow;
	TradePlayerListWindow@ m_tradePlayerList;
	bool isTradingRequested = false;

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
		@m_tradePlayerList = TradePlayerListWindow(aGameplayGameMode.m_guiBuilder);

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
		if(m_tradingWindow is null)
			return;

		//print("Platform::GetKeyState(58).Pressed: " + Platform:	:GetKeyState(58).Pressed);
		if(Platform::GetKeyState(58).Pressed)
		{
			//print("trading window activated");
			
			if(cast<TradePlayerListWindow>(baseGameMode.m_windowManager.GetCurrentWindow()) is null) {
				print("cast<TradingWindow>(baseGameMode.m_windowManager.GetCurrentWindow()) is null:" + (cast<TradePlayerListWindow>(baseGameMode.m_windowManager.GetCurrentWindow()) is null) );
				//baseGameMode.m_windowManager.AddWindowObject(m_tradingWindow);
				baseGameMode.m_windowManager.AddWindowObject(m_tradePlayerList);
			}else{
				print("Filename def: " + (baseGameMode.m_windowManager.GetCurrentWindow() is null ? "null" : baseGameMode.m_windowManager.GetCurrentWindow().m_filenameDef) );
				baseGameMode.m_windowManager.CloseWindow(m_tradePlayerList);
			}
		}
	}

	[Hook]
	void GameModePostStart(AGameplayGameMode@ aGameplayGameMode) {
		print("GameModePostStart---");
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
