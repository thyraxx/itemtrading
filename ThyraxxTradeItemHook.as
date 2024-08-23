namespace itemtrading
{
	TradingWindow@ m_tradingWindow;

	[Hook]
	void GameModeStart(AGameplayGameMode@ aGameplayGameMode, SValue@ save) {
		print("We are here--");
		aGameplayGameMode.m_userWindows.insertLast(@m_tradingWindow = TradingWindow(aGameplayGameMode.m_guiBuilder));
	}


	[Hook]
	void GameModeUpdate(BaseGameMode@ baseGameMode, int ms, GameInput& gameInput, MenuInput& menuInput) {
		if(m_tradingWindow is null)
			return;

		if(Platform::GetKeyState(58).Pressed){
			print("trading window activated");
			baseGameMode.ToggleUserWindow(m_tradingWindow);
		}
	}

	[Hook]
	void LoadWidgetProducers(GUIBuilder@ builder) {
		builder.AddWidgetProducer("tradingequipmentinventory", LoadTradingEquipmentInventoryWidget);
		builder.AddWidgetProducer("tradingequipmentitem", LoadTradingEquipmentInventoryWidget);
	}

}