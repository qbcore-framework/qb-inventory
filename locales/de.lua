local Translations = {
    progress = {
        ['snowballs'] = 'SchneebÃ¤lle sammeln..',
    },
    notify = {
        ['failed'] = 'Fehlgeschlagen',
        ['canceled'] = 'Abgebrochen',
        ['vlocked'] = 'Fahrzeug verriegelt',
        ['notowned'] = 'Du besitzt diesen Gegenstand nicht!',
        ['missitem'] = 'Du hast diesen Gegenstand nicht!',
        ['nonb'] = 'Niemand in der NÃ¤he!',
        ['noaccess'] = 'Nicht zugÃ¤nglich',
        ['nosell'] = 'Du kannst diesen Gegenstand nicht verkaufen..',
        ['itemexist'] = 'Der Gegenstand existiert nicht',
        ['notencash'] = 'Du hast nicht genug Bargeld..',
        ['noitem'] = 'Du hast nicht die richtigen GegenstÃ¤nde..',
        ['gsitem'] = 'Du kannst dir keinen Gegenstand geben?',
        ['tftgitem'] = 'Du bist zu weit weg, um GegenstÃ¤nde zu geben!',
        ['infound'] = 'Der Gegenstand, den du geben wolltest, wurde nicht gefunden!',
        ['iifound'] = 'Falscher Gegenstand gefunden, versuche es erneut!',
        ['gitemrec'] = 'Du hast erhalten ',
        ['gitemfrom'] = ' Von ',
        ['gitemyg'] = 'Du hast gegeben ',
        ['gitinvfull'] = 'Das Inventar des anderen Spielers ist voll!',
        ['giymif'] = 'Dein Inventar ist voll!',
        ['gitydhei'] = 'Du hast nicht genug von dem Gegenstand',
        ['gitydhitt'] = 'Du hast nicht genug GegenstÃ¤nde zum Ãœbertragen',
        ['navt'] = 'UngÃ¼ltiger Typ..',
        ['anfoc'] = 'Argumente nicht korrekt ausgefÃ¼llt..',
        ['yhg'] = 'Du hast gegeben ',
        ['cgitem'] = 'Kann den Gegenstand nicht geben!',
        ['idne'] = 'Gegenstand existiert nicht',
        ['pdne'] = 'Spieler ist nicht online',
        ['nogunbag'] = 'Du kannst nicht gleichzeitig eine Waffe und eine Tasche halten!',
        ['hasbag'] = 'Du hÃ¤ltst bereits eine Tasche, leg sie erst ab!',
        ['invinuse'] = 'Dieses Inventar wird derzeit verwendet',
        ['notenoughstock'] = 'Du kannst nicht mehr kaufen als aktuell auf Lager ist',
        ['canthold'] = 'Du kannst diesen Gegenstand nicht tragen',
    },
    inf_mapping = {
        ['opn_inv'] = 'Inventar Ã¶ffnen',
        ['tog_slots'] = 'Schaltet die belegten Slots um',
        ['use_item'] = 'Verwendet den Gegenstand im Slot ',
    },
    menu = {
        ['vending'] = 'Verkaufsautomat',
        ['bin'] = 'MÃ¼llcontainer Ã¶ffnen',
        ['craft'] = 'Herstellen',
        ['o_bag'] = 'Tasche öffnen',
        ['p_bag'] = 'Tasche abholen',
    },
    interaction = {
        ['craft'] = '~g~E~w~ - Herstellen',
        ['drop_bag'] = 'Drücken Sie [G], um die Tasche fallen zu lassen',
    },
}

if GetConvar('qb_locale', 'en') == 'de' then
    Lang = Locale:new({
        phrases = Translations,
        warnOnMissing = true,
        fallbackLang = Lang,
    })
end
