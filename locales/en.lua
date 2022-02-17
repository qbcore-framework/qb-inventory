local Translations = {
    error = {
        failed = "Failed",
        not_owned = "You do not own this item!", 
        no_near = "No one nearby!",
        no_access = "Not Accessible",
        veh_locked = "Vehicle is locked!",
        not_exist = "Item doesn\'t exist??",
        no_cash = "You don\'t have enough cash..",
        missing_item = "You don't have the right items..",
        yourself = "You can't give yourself an item?",
        toofar = "You are too far away to give items!",
        otherfull = "The other players inventory is full!",
        invfull = "Your inventory is full!",
        not_enough = "You do not have enough items to transfer",
        invalid_type = "Not a valid type..",
        arguments = "Arguments not filled out correctly..",
        cant_give = "Can't give item!",
        invalid_amount = "Invalid Amount",
        not_online = "Player Is Not Online",
    },
    success = {
        bought_item = "%{item} bought!",
        recieved = "You Received %{amount}x %{item} from %{firstname} %{lastname}!",
        gave = "You gave %{firstname} %{lastname} %{amount}x %{item} !",
        yougave = "You Have Given %{name} %{amount}x %{item} !",
    },
    info = {
        crafting_progress = "Crafting..",
        pickup_snow = "Collecting snowballs..",
        craft = "Craft",
        craft_label = "Crafting",
        attatch_label = "Attachment Crafting",
        stash_none = "Stash-None",
        stash = "Stash-",
        trunk_none = "Trunk-None",
        trunk = "Trunk-",
        glove_none = "Glovebox-None",
        glovebox = "Glovebox-",
        playerLabel = "Player-",
        dropped_none = "Dropped-None",
        dropped = "Dropped-",
    }
}

Lang = Locale:new({
    phrases = Translations,
    warnOnMissing = true
})
