namespace itemtrading
{
	class TradingWindow : AWindowObject
	{
		TradingEquipmentItemWidget@ m_equipmentWidget;
		TradingEquipmentInventoryWidget@ m_equipmentInventoryWidget;

		TradingEquipmentItemWidget@ m_equipmentWidgetOffer;
		TradingEquipmentInventoryOfferWidget@ m_equipmentInventoryWidgetOffer;

		TradingEquipmentItemWidget@ m_equipmentWidgetCounterOffer;
		TradingEquipmentInventoryWidget@ m_equipmentInventoryWidgetCounterOffer;

		TradingWindow(GUIBuilder@ b) 
		{
			super(b, "gui_itemtrade/thyraxxitemtrade.gui");

			@m_equipmentInventoryWidget = cast<TradingEquipmentInventoryWidget>(m_widget.GetWidgetById("equipment-inventory"));
			@m_equipmentInventoryWidget.m_itemTemplate = cast<EquipmentItemWidget>(m_widget.GetWidgetById("equipment-item-template"));

			@m_equipmentInventoryWidgetOffer = cast<TradingEquipmentInventoryOfferWidget>(m_widget.GetWidgetById("equipment-inventory-offer"));
			@m_equipmentInventoryWidgetOffer.m_itemTemplate = cast<EquipmentItemWidget>(m_widget.GetWidgetById("equipment-item-template-offer"));
			//m_equipmentInventoryWidgetOffer.SetOwner(GetLocalPlayerRecord());


			//@m_equipmentInventoryWidgetCounterOffer = cast<TradingEquipmentInventoryWidget>(m_widget.GetWidgetById("equipment-inventory-counter-offer"));
			//@m_equipmentInventoryWidgetCounterOffer.m_itemTemplate = cast<TradingEquipmentItemWidget>(m_widget.GetWidgetById("equipment-item-template-counter-offer"));

		}
	}
}