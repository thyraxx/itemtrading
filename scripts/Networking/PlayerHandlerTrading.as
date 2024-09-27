namespace PlayerHandlerTrading
{
	void SendCancelTradeMessage() {
		
	}

	void SyncAddItem(uint8 peer, SValue@ itemData) { // equipment/items must be send as SValue data
		print("SyncAddItem called");
		auto item = Equipment::LoadItem(itemData);
		if (item is null)
			return;

		print("Added item to counteroffer and refreshing trade window: " + item.baseItem.name);

		equipInventoryCounterOffer.Add(item);
		m_equipmentTradingInventoryWidget.Refresh();
		m_equipmentInventoryWidgetCounterOffer.Refresh();
	}

	void SyncRemoveItem(uint8 peer, SValue@ itemData) {
		print("SyncRemoveItem called");
		auto item = Equipment::LoadItem(itemData);
		if (item is null)
			return;

		print("Added item to counteroffer and refreshing trade window");
		equipInventoryCounterOffer.Remove(item);
		m_equipmentTradingInventoryWidget.Refresh();
	}

	void SendTradeRequestToPeer(uint8 peer) {
		if(peer != GetLocalPlayerRecord().peer)
			return;


	}

	void SendTradeRequestAccepted(uint8 peer) {

	}

	void SendTradeRequestDenied(uint8 peer) {

	}


	void SendTradeLockMessage(uint8 peer, bool isLocked) {

	}

	void SendTradeConfirmMessage(uint8 peer, bool isConfirmed) {

	}
}