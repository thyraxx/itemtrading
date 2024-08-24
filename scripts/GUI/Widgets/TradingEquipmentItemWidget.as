class TradingEquipmentItemWidget : EquipmentItemWidget
{
	TradingEquipmentItemWidget() {
		super();
	}

	void ClickDown(bool usingMouse, vec2 mousePos) override 
	{
		EquipmentItemWidget::ClickDown(usingMouse, mousePos);
		print("click down");
	}
}

ref@ LoadTradingEquipmentItemWidget(WidgetLoadingContext &ctx)
{
	TradingEquipmentItemWidget@ w = TradingEquipmentItemWidget();
	w.Load(ctx);
	return w;
}