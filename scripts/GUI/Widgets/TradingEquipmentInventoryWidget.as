class TradingEquipmentInventoryWidget : EquipmentInventoryWidget
{
	TradingEquipmentItemWidget@ m_tradingItemTemplate;

	TradingEquipmentInventoryWidget() {
		super();
	}

	bool IsItemAlreadyAdded(Equipment::Equipment@ item)
	{
		for(uint i = 0; i < equipInventoryOffer.m_items.length(); i++)
		{
			if(equipInventoryOffer.m_items[i] is item)
				return true;
		}

		return false;
	}

	void OnClick(Equipment::Equipment@ item) override
	{
		if(item is null)
			return;

		if(!equipInventoryOffer.CanAdd())
			return;

		print("onclick " + item.GetName());

		//auto equip = cast<Equipment::Equipment>(item);
		if (item !is null) {

			if(IsItemAlreadyAdded(item)){
				print("Item is already in trading window");
			}else{
				equipInventoryOffer.Add(item);

				SValueBuilder builder;
				Item::SaveItem(builder, item);

				// Peer hardcoded temporarily
				if(GetLocalPlayerRecord().peer == 0)
					(Network::Message("SyncAddItem") << builder.Build()).SendToPeer(1);
				else
					(Network::Message("SyncAddItem") << builder.Build()).SendToHost();
				
				Refresh();
			}

		}

		m_host.OnFunc(this, "refresh");
	}

	void DoLayout(vec2 origin, vec2 parentSz) override
	{
		EquipmentInventoryWidget::DoLayout(origin, parentSz);
	}


	void Refresh() override
	{
		ClearChildren();

		vec2 baseSize = vec2(m_width / m_itemTemplate.m_width, int(ceil(m_height / float(m_itemTemplate.m_height))));

		vec2 offset = vec2(0);
		ivec2 navOffset = ivec2(0);

		for (uint i = 0; i < uint(max(m_owner.equipInventory.m_items.length(), baseSize.x * baseSize.y)); i++)
		{
			auto item = cast<EquipmentItemWidget>(m_itemTemplate.Clone());

			//item.SetID( m_owner.equipInventory.m_items[i].GetIDHash() );
			item.SetID("");
			item.m_offset = offset;
			if (i < m_owner.equipInventory.m_items.length()) {
				item.Set(m_owner.equipInventory.m_items[i], this);
				
				if(IsItemAlreadyAdded(m_owner.equipInventory.m_items[i])) {
					item.m_visible = false;
					continue;
				}else{
					item.m_visible = true;
				}
			}

			item.m_navPos += navOffset;
			@item.m_inventory = this;

			AddChild(item);

			navOffset.x += 1;

			offset.x += item.m_width;
			if ((offset.x + item.m_width) > m_width)
			{
				offset.x = 0;
				offset.y += item.m_height;

				navOffset.x = 0;
				navOffset.y += 1;

				if (m_owner.equipInventory.m_items.length() / baseSize.x > baseSize.y)
					baseSize.y++;
			}
		}

		m_height = navOffset.y * m_itemTemplate.m_height;
	}
}

ref@ LoadTradingEquipmentInventoryWidget(WidgetLoadingContext &ctx)
{
	TradingEquipmentInventoryWidget@ w = TradingEquipmentInventoryWidget();
	w.Load(ctx);
	return w;
}