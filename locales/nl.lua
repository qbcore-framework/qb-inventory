local Translations = {
    progress = {
        ['snowballs'] = 'Sneeuwballen verzamelen..',
    },
    notify = {
        ['failed'] = 'Gefaald',
        ['canceled'] = 'Geannuleerd',
        ['vlocked'] = 'Voertuig vergrendeld',
        ['notowned'] = 'Je hebt dit item niet in je bezit!',
        ['missitem'] = 'Je hebt dit item niet!',
        ['nonb'] = 'Niemand in de buurt!',
        ['noaccess'] = 'Niet toegankelijk',
        ['nosell'] = 'Je kunt dit item niet verkopen..',
        ['itemexist'] = 'Item bestaat niet',
        ['notencash'] = 'Je hebt niet genoeg geld..',
        ['noitem'] = 'Je hebt niet de juiste items..',
        ['gsitem'] = 'Je kunt jezelf geen item geven?',
        ['tftgitem'] = 'Je bent te ver weg om items te geven!',
        ['infound'] = 'Het item dat u probeerde te geven is niet gevonden!',
        ['iifound'] = 'Verkeerd item gevonden probeer opnieuw!',
        ['gitemrec'] = 'U ontvangt ',
        ['gitemfrom'] = ' Van ',
        ['gitemyg'] = 'Je gaf ',
        ['gitinvfull'] = 'De inventaris van de andere speler is vol!',
        ['giymif'] = 'Je inventaris is vol!',
        ['gitydhei'] = 'Je hebt niet genoeg van het item',
        ['gitydhitt'] = 'Je hebt niet genoeg items om over te dragen',
        ['navt'] = 'Geen geldig type..',
        ['anfoc'] = 'Argumenten niet correct ingevuld..',
        ['yhg'] = 'Je gaf ',
        ['cgitem'] = 'Kan item niet geven!',
        ['idne'] = 'Item bestaat niet',
        ['pdne'] = 'Speler is niet online',
    },
    inf_mapping = {
        ['opn_inv'] = 'Open inventaris',
        ['tog_slots'] = 'Schakelt keybinds in/uit',
        ['use_item'] = 'Gebruikt het item in slot ',
    },
    menu = {
        ['vending'] = 'Verkoopautomaat',
        ['bin'] = 'Open vuilcontainer',
        ['craft'] = 'Maak',
        ['o_bag'] = 'Open Zak',
    },
    interaction = {
        ['craft'] = '~g~E~w~ - Maak',
    },
}

Lang = Lang or Locale:new({
    phrases = Translations,
    warnOnMissing = true
})
