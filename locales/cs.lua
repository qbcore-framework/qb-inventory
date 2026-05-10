local Translations = {
    progress = {
        ['snowballs'] = 'SbÃ­rÃ¡Å¡ snÄ›hovÃ© koule..',
    },
    notify = {
        ['failed'] = 'Nepovedlo se',
        ['canceled'] = 'ZruÅ¡eno',
        ['vlocked'] = 'Vozidlo uzamÄeno',
        ['notowned'] = 'Tento pÅ™edmÄ›t nevlastnÃ­Å¡!',
        ['missitem'] = 'NemÃ¡Å¡ tento pÅ™edmÄ›t!',
        ['nonb'] = 'Nikdo v okolÃ­ nenÃ­!',
        ['noaccess'] = 'NepÅ™Ã­stupnÃ©',
        ['nosell'] = 'Tento pÅ™edmÄ›t nemÅ¯Å¾eÅ¡ prodat.',
        ['itemexist'] = 'PÅ™edmÄ›t neexistuje',
        ['notencash'] = 'NemÃ¡Å¡ dost hotovosti..',
        ['noitem'] = 'NemÃ¡Å¡ sprÃ¡vnÃ© pÅ™edmÄ›ty..',
        ['gsitem'] = 'NemÅ¯Å¾eÅ¡ si dÃ¡t pÅ™edmÄ›t sÃ¡m sobÄ›?',
        ['tftgitem'] = 'Jsi pÅ™Ã­liÅ¡ daleko na to, aby sis dal pÅ™edmÄ›t!',
        ['infound'] = 'PÅ™edmÄ›t, kterÃ½ se snaÅ¾Ã­Å¡ dÃ¡t, nebyl nalezen!',
        ['iifound'] = 'Nalezen nesprÃ¡vnÃ½ pÅ™edmÄ›t, zkus to znovu!',
        ['gitemrec'] = 'Dostal jsi ',
        ['gitemfrom'] = ' Od ',
        ['gitemyg'] = 'Dal jsi ',
        ['gitinvfull'] = 'InventÃ¡Å™ druhÃ©ho hrÃ¡Äe je plnÃ½!',
        ['giymif'] = 'TvÅ¯j inventÃ¡Å™ je plnÃ½!',
        ['gitydhei'] = 'NemÃ¡Å¡ dost tohoto pÅ™edmÄ›tu',
        ['gitydhitt'] = 'NemÃ¡Å¡ dost pÅ™edmÄ›tÅ¯ na pÅ™enos',
        ['navt'] = 'NeplatnÃ½ typ..',
        ['anfoc'] = 'Argumenty nejsou sprÃ¡vnÄ› vyplnÄ›ny..',
        ['yhg'] = 'Dal jsi ',
        ['cgitem'] = 'Nelze dÃ¡t pÅ™edmÄ›t!',
        ['idne'] = 'PÅ™edmÄ›t neexistuje',
        ['pdne'] = 'HrÃ¡Ä nenÃ­ online',
        ['nogunbag'] = 'NemÅ¯Å¾eÅ¡ drÅ¾et zbraÅˆ a taÅ¡ku zÃ¡roveÅˆ!',
        ['hasbag'] = 'UÅ¾ drÅ¾Ã­Å¡ taÅ¡ku, jdi ji odhodit!',
        ['invinuse'] = 'Tento inventÃ¡Å™ se prÃ¡vÄ› pouÅ¾Ã­vÃ¡',
        ['notenoughstock'] = 'Nelze koupit vÄ›tÅ¡Ã­ mnoÅ¾stvÃ­, neÅ¾ je aktuÃ¡lnÄ› skladem',
        ['canthold'] = 'Tento pÅ™edmÄ›t neuneseÅ¡',
    },
    inf_mapping = {
        ['opn_inv'] = 'OtevÅ™i inventÃ¡Å™',
        ['tog_slots'] = 'PÅ™epÃ­nÃ¡ sloty klÃ¡vesovÃ½ch zkratek',
        ['use_item'] = 'PouÅ¾Ã­vÃ¡ pÅ™edmÄ›t ve slotu ',
    },
    menu = {
        ['vending'] = 'Automat',
        ['bin'] = 'OtevÅ™i kontejner',
        ['craft'] = 'Řemeslo',
        ['o_bag'] = 'Otevři tašku',
        ['p_bag'] = 'Vyzvednout tašku',
    },
    interaction = {
        ['craft'] = '~g~E~w~ - Řemeslo',
        ['drop_bag'] = 'Stisknutím [G] vak upustíte',
    },
}

if GetConvar('qb_locale', 'en') == 'cs' then
    Lang = Locale:new({
        phrases = Translations,
        warnOnMissing = true,
        fallbackLang = Lang,
    })
end