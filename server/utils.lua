--- QB Inventory Project
-- Server-side code for the all the utils functions
-- @module utils
-- @author restray

---
-- @function recipeContains
-- @tparam string[] recipe      A table of all the items name needed to craft the item
-- @tparam Item                 The item to craft
-- @treturn boolean             If the recipe is valid
function recipeContains(recipe, fromItem)
	for _, v in pairs(recipe.accept) do
		if v == fromItem.name then
			return true
		end
	end

	return false
end