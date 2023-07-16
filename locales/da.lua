local Translations = {
    progress = {
        ["crafting"] = "Crafting...", -- There is not a better word for it in danish, and everyone knows what it means. "Bygger", would be a alternative. 
        ["snowballs"] = "Samler snebolde..",
    },
    notify = {
        ["failed"] = "Fejlede",
        ["canceled"] = "Afbrudt",
        ["vlocked"] = "Køretøjet låst",
        ["notowned"] = "Du ejer ikke genstanden!",
        ["missitem"] = "Du har ikke denne genstand!",
        ["nonb"] = "Ingen i nærheden!",
        ["noaccess"] = "Ikke tilgængelig",
        ["nosell"] = "Du kan ikke sælge denne genstand..",
        ["itemexist"] = "Genstanden eksistere ikke",
        ["notencash"] = "Du har ikke penge nok..",
        ["noitem"] = "Du har ikke den rette genstand..",
        ["gsitem"] = "Du kan ikke give dig selv en genstand?",
        ["tftgitem"] = "Du er for langt væk for at kunne give genstande!",
        ["infound"] = "Genstanden du ville give eksistere ikke!",
        ["iifound"] = "Forkert genstand, prøv igen!",
        ["gitemrec"] = "Du modtog ",
        ["gitemfrom"] = " Fra ",
        ["gitemyg"] = "Du gav ",
        ["gitinvfull"] = "Spilleren har fyldt inventory!",
        ["giymif"] = "Dit inventory er fyldt!",
        ["gitydhei"] = "Du har ikke nok af genstanden",
        ["gitydhitt"] = "Du har ikke genstande nok til at kunne give ud",
        ["navt"] = "Ikke en valid type..",
        ["anfoc"] = "Argumenterne er ikke korrekt udfyldt..",
        ["yhg"] = "Du har givet ",
        ["cgitem"] = "Kan ikke give genstanden!",
        ["idne"] = "Genstanden eksistere ikke",
        ["pdne"] = "Spilleren er ikke online",
    },
    inf_mapping = {
        ["opn_inv"] = "Åbn inventory",
        ["tog_slots"] = "Toggles keybind slots",
        ["use_item"] = "Bruger genstanden i slot ",
    },
    menu = {
        ["vending"] = "Købs automat",
        ["craft"] = "Craft",
        ["o_bag"] = "Åbn taske",
    },
    interaction = {
        ["craft"] = "~g~E~w~ - Craft",
    },
    label = {
        ["craft"] = "Crafting",
        ["a_craft"] = "Attachment Crafting",
    },
}

Lang = Lang or Locale:new({
    phrases = Translations,
    warnOnMissing = true
})
