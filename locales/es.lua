local Translations = {
    progress = {
        ['snowballs'] = 'Recolectando bolas de nieve..',
    },
    notify = {
        ['failed'] = 'Falló',
        ['canceled'] = 'Cancelado',
        ['vlocked'] = 'Vehículo Bloqueado',
        ['notowned'] = '¡No eres el dueño de este artículo!',
        ['missitem'] = '¡No tienes este artículo!',
        ['nonb'] = '¡No hay nadie cerca!',
        ['noaccess'] = 'No Accesible',
        ['nosell'] = 'No puedes vender este artículo..',
        ['itemexist'] = 'El artículo no existe',
        ['notencash'] = 'No tienes suficiente dinero en efectivo..',
        ['noitem'] = 'No tienes los artículos correctos..',
        ['gsitem'] = '¿No puedes darte un artículo a ti mismo?',
        ['tftgitem'] = '¡Estás demasiado lejos para dar artículos!',
        ['infound'] = '¡El artículo que intentaste dar no se encontró!',
        ['iifound'] = '¡Artículo incorrecto encontrado, intenta de nuevo!',
        ['gitemrec'] = 'Has recibido ',
        ['gitemfrom'] = ' De ',
        ['gitemyg'] = 'Diste ',
        ['gitinvfull'] = '¡El inventario del otro jugador está lleno!',
        ['giymif'] = '¡Tu inventario está lleno!',
        ['gitydhei'] = 'No tienes suficiente del artículo',
        ['gitydhitt'] = 'No tienes suficientes artículos para transferir',
        ['navt'] = 'Tipo no válido..',
        ['anfoc'] = 'Argumentos no llenados correctamente..',
        ['yhg'] = 'Has dado ',
        ['cgitem'] = '¡No se puede dar el artículo!',
        ['idne'] = 'El artículo no existe',
        ['pdne'] = 'El jugador no está en línea',
    },
    inf_mapping = {
        ['opn_inv'] = 'Abrir Inventario',
        ['tog_slots'] = 'Alterna las ranuras de teclas rápidas',
        ['use_item'] = 'Usa el artículo en la ranura ',
    },
    menu = {
        ['vending'] = 'Máquina Expendedora',
        ['bin'] = 'Abrir Contenedor',
        ['craft'] = 'Crear',
        ['o_bag'] = 'Abrir Bolsa',
    },
    interaction = {
        ['craft'] = '~g~E~w~ - Crear',
    },
}

if GetConvar('qb_locale', 'en') == 'es' then
    Lang = Locale:new({
        phrases = Translations,
        warnOnMissing = true,
        fallbackLang = Lang,
    })
end
