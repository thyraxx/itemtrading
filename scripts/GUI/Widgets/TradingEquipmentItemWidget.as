class TradingEquipmentItemWidget : EquipmentItemWidget
{
	TradingEquipmentItemWidget() {
		super();
	}
}

ref@ LoadTradingEquipmentItemWidget(WidgetLoadingContext &ctx)
{
	TradingEquipmentItemWidget@ w = TradingEquipmentItemWidget();
	w.Load(ctx);
	return w;
}