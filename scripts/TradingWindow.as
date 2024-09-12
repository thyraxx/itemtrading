namespace itemtrading
{
	class TradingWindow : AWindowObject
	{
		EquipmentWidget@ m_equipmentWidget;
		EquipmentInventoryWidget@ m_equipmentInventoryWidget;

		TradingEquipmentItemWidget@ m_equipmentWidgetOffer;
		TradingEquipmentInventoryWidget@ m_equipmentInventoryWidgetOffer;

		TradingEquipmentItemWidget@ m_equipmentWidgetCounterOffer;
		TradingEquipmentInventoryWidget@ m_equipmentInventoryWidgetCounterOffer;

		TradingWindow(GUIBuilder@ b) 
		{
			super(b, "gui_itemtrade/thyraxxitemtrade.gui");

			@m_equipmentInventoryWidget = cast<EquipmentInventoryWidget>(m_widget.GetWidgetById("equipment-inventory"));
			@m_equipmentInventoryWidget.m_itemTemplate = cast<EquipmentItemWidget>(m_widget.GetWidgetById("equipment-item-template"));

			m_equipmentInventoryWidget.SetOwner(GetLocalPlayerRecord());

			//@m_equipmentInventoryWidgetOffer = cast<TradingEquipmentInventoryWidget>(m_widget.GetWidgetById("equipment-inventory-offer"));
			//@m_equipmentInventoryWidgetOffer.m_itemTemplate = cast<TradingEquipmentItemWidget>(m_widget.GetWidgetById("equipment-item-template-offer"));

			//@m_equipmentInventoryWidgetCounterOffer = cast<TradingEquipmentInventoryWidget>(m_widget.GetWidgetById("equipment-inventory-counter-offer"));
			//@m_equipmentInventoryWidgetCounterOffer.m_itemTemplate = cast<TradingEquipmentItemWidget>(m_widget.GetWidgetById("equipment-item-template-counter-offer"));

		}
	}
}