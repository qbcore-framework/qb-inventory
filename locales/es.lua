local Translations = {
    progress = {
        ['snowballs'] = 'Recolectando bolas de nieve..',
    },
    notify = {
        ['failed'] = 'Fallido',
        ['canceled'] = 'Cancelado',
        ['vlocked'] = 'VehÃ­culo Bloqueado',
        ['notowned'] = 'Â¡No posees este objeto!',
        ['missitem'] = 'Â¡No tienes este objeto!',
        ['nonb'] = 'Â¡No hay nadie cerca!',
        ['noaccess'] = 'No Accesible',
        ['nosell'] = 'No puedes vender este objeto..',
        ['itemexist'] = 'El objeto no existe',
        ['notencash'] = 'No tienes suficiente dinero..',
        ['noitem'] = 'No tienes los objetos adecuados..',
        ['gsitem'] = 'Â¿No puedes darte un objeto a ti mismo?',
        ['tftgitem'] = 'Â¡EstÃ¡s demasiado lejos para dar objetos!',
        ['infound'] = 'Â¡Objeto que intentaste dar no encontrado!',
        ['iifound'] = 'Â¡Objeto incorrecto encontrado, intenta de nuevo!',
        ['gitemrec'] = 'Recibiste ',
        ['gitemfrom'] = ' De ',
        ['gitemyg'] = 'Diste ',
        ['gitinvfull'] = 'Â¡El inventario del otro jugador estÃ¡ lleno!',
        ['giymif'] = 'Â¡Tu inventario estÃ¡ lleno!',
        ['gitydhei'] = 'No tienes suficiente del objeto',
        ['gitydhitt'] = 'No tienes suficientes objetos para transferir',
        ['navt'] = 'No es un tipo vÃ¡lido..',
        ['anfoc'] = 'Argumentos no rellenados correctamente..',
        ['yhg'] = 'Has Dado ',
        ['cgitem'] = 'Â¡No se puede dar el objeto!',
        ['idne'] = 'El Objeto No Existe',
        ['pdne'] = 'El Jugador No EstÃ¡ En LÃ­nea',
        ['nogunbag'] = 'Â¡No puedes llevar un arma y una bolsa al mismo tiempo!',
        ['hasbag'] = 'Â¡Ya llevas una bolsa, ve a soltarla!',
        ['invinuse'] = 'Este inventario estÃ¡ en uso',
        ['notenoughstock'] = 'No puedes comprar mÃ¡s de lo que hay en stock actualmente',
        ['canthold'] = 'No puedes llevar este objeto',
    },
    inf_mapping = {
        ['opn_inv'] = 'Abrir Inventario',
        ['tog_slots'] = 'Alterna ranuras de teclas',
        ['use_item'] = 'Usa el objeto en la ranura',
    },
    menu = {
        ['vending'] = 'MÃ¡quina Expendedora',
        ['bin'] = 'Abrir Contenedor de Basura',
        ['craft'] = 'Crear',
        ['o_bag'] = 'Bolsa abierta',
        ['p_bag'] = 'recoger bolsa',
    },
    interaction = {
        ['craft'] = '~g~E~w~ - Fabricar',
        ['drop_bag'] = 'Presione [G] para soltar la bolsa.',
    },
}

if GetConvar('qb_locale', 'en') == 'es' then
    Lang = Locale:new({
        phrases = Translations,
        warnOnMissing = true,
        fallbackLang = Lang,
    })
end
