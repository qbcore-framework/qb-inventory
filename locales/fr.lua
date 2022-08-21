--[[
English base language translation for qb-inventory
Translation done by wanderrer (Martin Riggs#0807 on Discord)
]]--
local Translations = {
    progress = {
        ["crafting"] = "Fabrication...",
        ["snowballs"] = "Ramasse des boules de neige...",
    },
    notify = {
        ["failed"] = "Échec",
        ["canceled"] = "Annulé",
        ["vlocked"] = "Véhicule verrouillé",
        ["notowned"] = "Vous ne possédez pas cet objet!",
        ["missitem"] = "Vous n'avez pas cet objet!",
        ["nonb"] = "Personne à proximité!",
        ["noaccess"] = "Inaccessible",
        ["nosell"] = "Vous ne pouvez pas vendre cet objet..",
        ["itemexist"] = "L'objet n'existe pas??",
        ["notencash"] = "Vous n'avez pas assez d'argent..",
        ["noitem"] = "Vous n'avez pas les bon objets..",
        ["gsitem"] = "Vous ne pouvez pas vous donner un objet à vous-même!",
        ["tftgitem"] = "Vous êtes trop loin pour donner des objets!",
        ["infound"] = "L'objet que vous avez essayé de donner n'existe pas!",
        ["iifound"] = "L'objet trouvé n'est pas correct, réessayez!",
        ["gitemrec"] = "Vous avez reçu ",
        ["gitemfrom"] = " de ",
        ["gitemyg"] = "Vous avez donné ",
        ["gitinvfull"] = "L'inventaire de l'autre joueur est plein!",
        ["giymif"] = "Votre inventaire est plein!",
        ["gitydhei"] = "Vous n'avez pas assez de l'objet",
        ["gitydhitt"] = "Vous n'avez pas assez d'objets à transférer",
        ["navt"] = "Type invalide..",
        ["anfoc"] = "Les arguments ne sont pas remplis correctement..",
        ["yhg"] = "Vous avez donné ",
        ["cgitem"] = "Vous ne pouvez pas donner cet objet!",
        ["idne"] = "L'objet n'existe pas",
        ["pdne"] = "Le joueur n'est pas connecté",
    },
    inf_mapping = {
        ["opn_inv"] = "Ouvrir l'inventaire",
        ["tog_slots"] = "Active les emplacements de touches",
        ["use_item"] = "Utilise l'objet dans l'emplacement ",
    },
    menu = {
        ["vending"] = "Distributeur",
        ["craft"] = "Fabriquer",
        ["o_bag"] = "Ouvrir le Sac",
    },
    interaction = {
        ["craft"] = "~g~E~w~ - Fabriquer",
    },
    label = {
        ["craft"] = "Fabrication",
        ["a_craft"] = "Fabrication d'accessoire",
    },
}
Lang = Locale:new({phrases = Translations, warnOnMissing = true})
