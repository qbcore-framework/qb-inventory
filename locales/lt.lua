local Translations = {
    progress = {
        ["crafting"] = "Gaminama...",
        ["snowballs"] = "Renkamos gniūžtės...",
    },
    notify = {
        ["failed"] = "Nepavyko",
        ["canceled"] = "Atšaukta",
        ["vlocked"] = "Transporto priemonė užrakinta",
        ["notowned"] = "Jums nepriklauso šis daiktas!",
        ["missitem"] = "Jūs neturite šio daikto!",
        ["nonb"] = "Aplink jus nieko nėra!",
        ["noaccess"] = "Neprieinama",
        ["nosell"] = "Jūs negalite parduoti šio daikto..",
        ["itemexist"] = "Daiktas neegzistuoja?",
        ["notencash"] = "Jūs neturite pakankamai grynųjų...",
        ["noitem"] = "Jūs neturite reikiamų daiktų..",
        ["gsitem"] = "Jūs negalite duoti daikto sau?",
        ["tftgitem"] = "Jūs esate per toli, kad duoti daiktus!",
        ["infound"] = "Daiktas, kurį bandėte duoti, nerastas!",
        ["iifound"] = "Neteisingas daiktas rastas, bandykite iš naujo!",
        ["gitemrec"] = "Jūs gavote ",
        ["gitemfrom"] = " Iš ",
        ["gitemyg"] = "Jūs davėte ",
        ["gitinvfull"] = "Kito žaidėjo inventorius pilnas!",
        ["giymif"] = "Jūsų inventorius pilnas!",
        ["gitydhei"] = "Jūs neturite pakankamai to daikto",
        ["gitydhitt"] = "Jūs neturite pakankamai daiktų perdavimui",
        ["navt"] = "Neįmanomas tipas...",
        ["anfoc"] = "Argumentai nepilnai užpildyti..",
        ["yhg"] = "Jūs davėte ",
        ["cgitem"] = "Negalite duoti daikto!",
        ["idne"] = "Daiktas neegzistuoja",
        ["pdne"] = "Žaidėjas neprisijungęs",
    },
    inf_mapping = {
        ["opn_inv"] = "Inventoriaus atidarymas",
        ["tog_slots"] = "Panaudoja mygtuko vietą",
        ["use_item"] = "Daikto panaudojimas vietoje ",
    },
    menu = {
        ["vending"] = "Automatas",
        ["craft"] = "Pagaminti",
        ["o_bag"] = "Atidaryti krepšį",
    },
    interaction = {
        ["craft"] = "~g~E~w~ - Pagaminti",
    },
    label = {
        ["craft"] = "Gaminama",
        ["a_craft"] = "Priedas gaminamas",
    },
}

if GetConvar('qb_locale', 'en') == 'lt' then
    Lang = Locale:new({
        phrases = Translations,
        warnOnMissing = true,
        fallbackLang = Lang,
    })
end
