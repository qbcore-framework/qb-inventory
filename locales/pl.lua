local Translations = {
    progress = {
        ['snowballs'] = 'Zbieranie śnieżek..',
    },
    notify = {
        ['failed'] = 'Niepowodzenie',
        ['canceled'] = 'Anulowano',
        ['vlocked'] = 'Samochód Zamknięty',
        ['notowned'] = 'Nie jesteś właścicielem tego przedmiotu!',
        ['missitem'] = 'Nie posiadasz tego przedmiotu!',
        ['nonb'] = 'Brak osób w Pobliżu!',
        ['noaccess'] = 'Brak Dostępu',
        ['nosell'] = 'Nie możesz sprzedać tego przedmiotu..',
        ['itemexist'] = 'Przedmiot nie istnieje',
        ['notencash'] = 'Nie masz wystarczająco gotówki..',
        ['noitem'] = 'Nie posiadasz właściwych przedmiotów..',
        ['gsitem'] = 'Nie możesz dać przedmiotu sobie?',
        ['tftgitem'] = 'Jesteś za za daleko aby dać przedmiot!',
        ['infound'] = 'Nie znaleziono przedmiotu który próbujesz dać!',
        ['iifound'] = 'Znaleziono nieprawidłowy przedmiot, spróbuj ponownie!',
        ['gitemrec'] = 'Otrzymałeś ',
        ['gitemfrom'] = ' Od ',
        ['gitemyg'] = 'Przekazałeś ',
        ['gitinvfull'] = 'Ekwipunek drugiego gracza jest pełny!',
        ['giymif'] = 'Twój Ekwipunek jest Pełny!',
        ['gitydhei'] = 'Nie masz wystarczająco tego przedmiotu',
        ['gitydhitt'] = 'Nie masz wystarczająco przedmiotów do przekazania',
        ['navt'] = 'Nieprawidłowy Typ..',
        ['anfoc'] = 'Argumenty wypełnione nieprawidłowo..',
        ['yhg'] = 'Przekazałeś ',
        ['cgitem'] = 'Nie możesz przekazac przedmiotu!',
        ['idne'] = 'Przedmiot nie Istnieje',
        ['pdne'] = 'Gracz jest Offline',
    },
    inf_mapping = {
        ['opn_inv'] = 'Otwórz Ekwipunek',
        ['tog_slots'] = 'Zmienia slot Przycisku',
        ['use_item'] = 'Używa przedmiotu w Slocie ',
    },
    menu = {
        ['vending'] = 'Automat',
        ['bin'] = 'Otwórz Śmietnik',
        ['craft'] = 'Wytwórz',
        ['o_bag'] = 'Otwórz Plecak',
    },
    interaction = {
        ['craft'] = '~g~E~w~ - Wytwórz',
    },
}

Lang = Lang or Locale:new({
    phrases = Translations,
    warnOnMissing = true
})
