Inv = {
	item = {},
	items = setmetatable(QBShared.Items, {
		__index = QBShared.Items,
		__call = function(self, data)
			return type(data) == 'table' and self[data.name] or self[data]
		end
	}),
	collection = {}
}

function Inv.require(params, label, value)
	if params then
		for i = 1, #value, 1 do
			assert(value[i], 'Inv:' .. label .. ' | a required param is not given to the function')
		end
	else
		assert(value, 'Inv:' .. label .. ' | a required piece of data within this function is undefined')
	end
end

function Inv.item.format(name, slot, amount, info, price, id, costs, points, threshold)

	Inv.require(true, 'ITEM:FORMAT', { name, slot, amount })
	if (costs or points or threshold) ~= nil then
		Inv.require(true, 'ITEM:FORMAT', { costs, points, threshold })
	end

	-- get item meta by given name
	name = type(name) == 'string' and name:lower() or '"no string given"'
	local meta = Inv.items[name]

	Inv.require(false, 'ITEM:FORMAT', meta)

	-- return the formated data
	return {

		-- dynamic item data
		id			= id,
		slot 		= slot,
		info 		= info or "",
		price 		= price,
		costs 		= costs,
		points 		= points,
		amount 		= tonumber(amount),
		threshold 	= threshold,

		-- static item meta
		name 		= meta.name 		or "placeholder",
		label 		= meta.label 		or "placeholder",
		image 		= meta.image 		or "placeholder.png",
		description = meta.description 	or "",
		weight 		= meta.weight 		or 0,
		type 		= meta.type 		or "item",
		unique 		= meta.unique 		or false,
		useable 	= meta.useable 		or false

	}

end

function Inv.item.shrink(item)

	Inv.require(true, 'ITEM:SHRINK', { item })

	return {
		name 	= item.name,
		slot 	= item.slot,
		info 	= item.info,
		amount 	= item.amount
	}

end

function Inv.collection.map(_table, callback)

	Inv.require(true, 'COLLECTION:MAP', { _table, callback })

	if type(next(_table)) == 'number' then

		for index = 1, #_table, 1 do

			callback(_table[index], index)

		end

	end

end