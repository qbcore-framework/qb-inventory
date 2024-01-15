local Translations = {
    progress = {
        ["crafting"] = "Craftezi...",
        ["snowballs"] = "Faci un bulgare de zapada..",
    },
    notify = {
        ["failed"] = "Esuat",
        ["canceled"] = "Anulat",
        ["vlocked"] = "Vehicul incuiat",
        ["notowned"] = "Nu deti acest item!",
        ["missitem"] = "Nu ai acest item!",
        ["nonb"] = "Nimeni in zona!",
        ["noaccess"] = "Nu este accesibil",
        ["nosell"] = "Nu poti vinde acest item..",
        ["itemexist"] = "Itemul nu exista??",
        ["notencash"] = "Nu ai destul cash..",
        ["noitem"] = "Nu ai itemele corecte..",
        ["gsitem"] = "Nu iti poti da tie un item?",
        ["tftgitem"] = "Esti prea departe ca sa oferi obiecte!",
        ["infound"] = "Itemul ce ai incercat sa il oferi nu exista!",
        ["iifound"] = "Item incorect gasit. Incearca iar!",
        ["gitemrec"] = "Ai primit ",
        ["gitemfrom"] = " De la ",
        ["gitemyg"] = "Ai dat ",
        ["gitinvfull"] = "Inventarul celuilalt este plin!",
        ["giymif"] = "Inventarul tau este plin!",
        ["gitydhei"] = "Nu ai cantitatea ce incerci sa oferi",
        ["gitydhitt"] = "Nu ai destule iteme ca sa oferi",
        ["navt"] = "Tipul nu este valid..",
        ["anfoc"] = "Argumenteke nu au fost completate corect..",
        ["yhg"] = "Ai oferit ",
        ["cgitem"] = "Nu poti oferi itemul!",
        ["idne"] = "Itemul nu exista",
        ["pdne"] = "Jucatorul nu este online",
    },
    inf_mapping = {
        ["opn_inv"] = "Deschide Inventar",
        ["tog_slots"] = "Activeaza keybindurile pe sloturi",
        ["use_item"] = "Foloseste itemul din slotul ",
    },
    menu = {
        ["vending"] = "Tonomat",
        ["craft"] = "Crafteaza",
        ["o_bag"] = "Deschide Geanta",
    },
    interaction = {
        ["craft"] = "~g~E~w~ - Crafteaza",
    },
    label = {
        ["craft"] = "Craftezi",
        ["a_craft"] = "Crafteaza atasamente",
    },
}

if GetConvar('qb_locale', 'en') == 'ro' then
    Lang = Locale:new({
        phrases = Translations,
        warnOnMissing = true,
        fallbackLang = Lang,
    })
end
