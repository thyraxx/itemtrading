namespace itemtrading
{
	class TradingWindow : AWindowObject
	{
		//TradingEquipmentItemWidget@ m_equipmentWidgetOffer;
		//TradingEquipmentItemWidget@ m_equipmentWidgetCounterOffer;
		int counterOfferPeer;
		int offerPeer;

		TradingWindow(GUIBuilder@ b) 
		{
			super(b, "gui_itemtrade/thyraxxitemtrade.gui");

			@m_equipmentTradingInventoryWidget = cast<TradingEquipmentInventoryWidget>(m_widget.GetWidgetById("equipment-inventory"));
			@m_equipmentTradingInventoryWidget.m_itemTemplate = cast<EquipmentItemWidget>(m_widget.GetWidgetById("equipment-item-template"));

			@m_equipmentInventoryWidgetOffer = cast<TradingEquipmentInventoryOfferWidget>(m_widget.GetWidgetById("equipment-inventory-offer"));
			@m_equipmentInventoryWidgetOffer.m_itemTemplate = cast<EquipmentItemWidget>(m_widget.GetWidgetById("equipment-item-template-offer"));
			
			@m_equipmentInventoryWidgetCounterOffer = cast<TradingEquipmentInventoryCounterOfferWidget>(m_widget.GetWidgetById("equipment-inventory-counter-offer"));
			@m_equipmentInventoryWidgetCounterOffer.m_itemTemplate = cast<EquipmentItemWidget>(m_widget.GetWidgetById("equipment-item-template-counter-offer"));

		}

		void OnClose() override
		{
			equipInventoryOffer.Clear();
			equipInventoryCounterOffer.Clear();
			m_equipmentTradingInventoryWidget.Refresh();
			m_equipmentInventoryWidgetOffer.Refresh();
			m_equipmentInventoryWidgetCounterOffer.Refresh();
		}
	}
}