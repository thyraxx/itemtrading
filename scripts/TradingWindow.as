namespace itemtrading
{
	class TradingWindow : AWindowObject
	{
		EquipmentWidget@ m_equipmentWidget;
		EquipmentInventoryWidget@ m_equipmentInventoryWidget;

		TradingWindow(GUIBuilder@ b) 
		{
			super(b, "gui_itemtrade/thyraxxitemtrade.gui");

			@m_equipmentInventoryWidget = cast<EquipmentInventoryWidget>(m_widget.GetWidgetById("equipment-inventory"));
			@m_equipmentInventoryWidget.m_itemTemplate = cast<EquipmentItemWidget>(m_widget.GetWidgetById("equipment-item-template"));
			//@m_equipmentInventoryWidget.m_window = this;
		}
	}
}