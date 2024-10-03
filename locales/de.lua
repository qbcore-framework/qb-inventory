local Translations = {
    progress = {
        ['snowballs'] = 'Schneebälle sammeln..',
    },
    notify = {
        ['failed'] = 'Fehlgeschlagen',
        ['canceled'] = 'Abgebrochen',
        ['vlocked'] = 'Fahrzeug verriegelt',
        ['notowned'] = 'Du besitzt diesen Gegenstand nicht!',
        ['missitem'] = 'Du hast diesen Gegenstand nicht!',
        ['nonb'] = 'Niemand in der Nähe!',
        ['noaccess'] = 'Nicht zugänglich',
        ['nosell'] = 'Du kannst diesen Gegenstand nicht verkaufen..',
        ['itemexist'] = 'Der Gegenstand existiert nicht',
        ['notencash'] = 'Du hast nicht genug Bargeld..',
        ['noitem'] = 'Du hast nicht die richtigen Gegenstände..',
        ['gsitem'] = 'Du kannst dir keinen Gegenstand geben?',
        ['tftgitem'] = 'Du bist zu weit weg, um Gegenstände zu geben!',
        ['infound'] = 'Der Gegenstand, den du geben wolltest, wurde nicht gefunden!',
        ['iifound'] = 'Falscher Gegenstand gefunden, versuche es erneut!',
        ['gitemrec'] = 'Du hast erhalten ',
        ['gitemfrom'] = ' Von ',
        ['gitemyg'] = 'Du hast gegeben ',
        ['gitinvfull'] = 'Das Inventar des anderen Spielers ist voll!',
        ['giymif'] = 'Dein Inventar ist voll!',
        ['gitydhei'] = 'Du hast nicht genug von dem Gegenstand',
        ['gitydhitt'] = 'Du hast nicht genug Gegenstände zum Übertragen',
        ['navt'] = 'Ungültiger Typ..',
        ['anfoc'] = 'Argumente nicht korrekt ausgefüllt..',
        ['yhg'] = 'Du hast gegeben ',
        ['cgitem'] = 'Kann den Gegenstand nicht geben!',
        ['idne'] = 'Gegenstand existiert nicht',
        ['pdne'] = 'Spieler ist nicht online',
    },
    inf_mapping = {
        ['opn_inv'] = 'Inventar öffnen',
        ['tog_slots'] = 'Schaltet die belegten Slots um',
        ['use_item'] = 'Verwendet den Gegenstand im Slot ',
    },
    menu = {
        ['vending'] = 'Verkaufsautomat',
        ['bin'] = 'Müllcontainer öffnen',
        ['craft'] = 'Herstellen',
        ['o_bag'] = 'Tasche öffnen',
    },
    interaction = {
        ['craft'] = '~g~E~w~ - Herstellen',
    },
}

if GetConvar('qb_locale', 'en') == 'de' then
    Lang = Locale:new({
        phrases = Translations,
        warnOnMissing = true,
        fallbackLang = Lang,
    })
end
