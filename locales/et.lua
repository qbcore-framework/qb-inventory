--[[
Estonian base language translation for qb-inventory
Translation done by ViskCY (ViskCY#0001 on Discord)
]]--
local Translations = {
    progress = {
        ["crafting"] = "Meisterdan...",
        ["snowballs"] = "Kogun lumepalle..",
    },
    notify = {
        ["failed"] = "Ebaõnnestus",
        ["canceled"] = "Tühistatud",
        ["vlocked"] = "Sõiduk lukustatud",
        ["notowned"] = "Sa ei oma seda eset!",
        ["missitem"] = "Sul ei ole seda eset!",
        ["nonb"] = "Lähedal pole kedagi!",
        ["noaccess"] = "Pole juurdepääsetav",
        ["nosell"] = "Sa ei saa müüa seda eset..",
        ["itemexist"] = "Ese ei eksisteeri??",
        ["notencash"] = "Sul pole piisavalt raha..",
        ["noitem"] = "Sul pole õigeid esemeid..",
        ["gsitem"] = "Sa ei saa anda endale eset?",
        ["tftgitem"] = "Sa oled liiga kaugel, et anda esemeid!",
        ["infound"] = "Eset mida proovisid anda ei leitud!",
        ["iifound"] = "Vale ese, proovige uuesti!",
        ["gitemrec"] = "Sa said ",
        ["gitemfrom"] = " isikult nimega ",
        ["gitemyg"] = "Sa andisd ",
        ["gitinvfull"] = "Teise mängia inventuur on täis!",
        ["giymif"] = "Sinu inventuur on täis!",
        ["gitydhei"] = "Sul pole piisavalt seda eset",
        ["gitydhitt"] = "Teil pole ülekandmiseks piisavalt esemeid",
        ["navt"] = "Pole kehtiv tüüp..",
        ["anfoc"] = "Argumendid ei ole õigesti täidetud..",
        ["yhg"] = "Sa andisd ",
        ["cgitem"] = "Ei saa anda eset!",
        ["idne"] = "Ese ei eksisteeri",
        ["pdne"] = "Mängia ei ole võrgus",
    },
    inf_mapping = {
        ["opn_inv"] = "Ava inventuur",
        ["tog_slots"] = "Lülita sisse kiirvaliku nupud",
        ["use_item"] = "Kasuta eset kiirvalikus ",
    },
    menu = {
        ["vending"] = "Joogi/söögi automaat",
        ["craft"] = "Meisterda",
        ["o_bag"] = "Ava Kott",
    },
    interaction = {
        ["craft"] = "~g~E~w~ - Meisterda",
    },
    label = {
        ["craft"] = "Meisterdamine",
        ["a_craft"] = "Komponendi meisterdamine",
    },
}
Lang = Locale:new({phrases = Translations, warnOnMissing = true})