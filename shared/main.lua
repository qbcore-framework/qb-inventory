Inventory = {
	Functions = {}
}

function Inventory.Functions.formatItem(name, slot, amount, info, price, id, costs, points, threshold)
	-- dynamic item data
	local data = type(name) == 'table' and name or {
		id			= id,
		slot 		= slot,
		name		= name,
		info 		= info or "",
		price 		= price,
		costs 		= costs,
		points 		= points,
		amount 		= tonumber(amount),
		threshold 	= threshold,
	}
	local meta = QBShared.Items[(type(name) == 'table' and name.name or name)]
	assert(meta, 'INVENTORY:ITEM:FORMAT | static item meta not found in QBShared.Items for item '..data.name)
	-- static item meta
	data.label			= meta.label 		or "placeholder"
	data.image			= meta.image 		or "placeholder.png"
	data.description 	= meta.description 	or ""
	data.weight 		= meta.weight 		or 0
	data.type 			= meta.type 		or "item"
	data.unique 		= meta.unique 		or false
	data.useable 		= meta.useable 		or false
	-- return the formated data
	return data
end

function Inventory.Functions.Sort(items)
	items = type(items) == 'string' and json.decode(items) or items
	if items and next(items) then
		for i = 1, #items do
			local item = items[i]
			items[item.slot] = Inventory.Functions.formatItem(item)
		end
	end
	return items
end

function Inventory.Functions.AddItem(collection, id, slot, otherslot, name, amount, info)
	amount = tonumber(amount)
	local meta = QBShared.Items[name]
	local col = collection[id]
	if not meta.unique then
		if col.items[slot] ~= nil and col.items[slot].name == name then
			col.items[slot].amount = col.items[slot].amount + amount
		else
			col.items[slot] = Inventory.Functions.formatItem(name, slot, amount, info)
		end
	else
		if col.items[slot] ~= nil and col.items[slot].name == name then
			col.items[otherslot] = Inventory.Functions.formatItem(name, otherslot, amount, info)
		else
			col.items[slot] = Inventory.Functions.formatItem(name, slot, amount, info)
		end
	end
	collection[id] = col
	return collection
end

function Inventory.Functions.RemoveItem(collection, id, slot, name, amount)
	amount = tonumber(amount)
	local items = collection[id].items
	if items[slot] ~= nil and items[slot].name == name then
		if items[slot].amount > amount then
			items[slot].amount = items[slot].amount - amount
		else
			items[slot] = nil
			if next(items) == nil then
				items = {}
			end
		end
	else
		items[slot] = nil
		if items == nil then
			items[slot] = nil
		end
	end
	collection[id].items = items
	return collection
end