local Translations = {
    progress = {
        ['snowballs'] = 'Coletando bolas de neve...',
    },
    notify = {
        ['failed'] = 'Falhou',
        ['canceled'] = 'Cancelado',
        ['vlocked'] = 'Veículo trancado',
        ['notowned'] = 'Você não possui este item!',
        ['missitem'] = 'Você não tem este item!',
        ['nonb'] = 'Ninguém por perto!',
        ['noaccess'] = 'Não acessível',
        ['nosell'] = 'Você não pode vender este item...',
        ['itemexist'] = 'O item não existe',
        ['notencash'] = 'Você não tem dinheiro suficiente...',
        ['noitem'] = 'Você não tem os itens certos...',
        ['gsitem'] = 'Você não pode se dar um item!',
        ['tftgitem'] = 'Você está muito longe para dar itens!',
        ['infound'] = 'O item que você tentou dar não foi encontrado!',
        ['iifound'] = 'Item incorreto encontrado, tente novamente!',
        ['gitemrec'] = 'Você recebeu ',
        ['gitemfrom'] = ' De ',
        ['gitemyg'] = 'Você deu ',
        ['gitinvfull'] = 'O inventário do outro jogador está cheio!',
        ['giymif'] = 'Seu inventário está cheio!',
        ['gitydhei'] = 'Você não tem quantidade suficiente do item',
        ['gitydhitt'] = 'Você não tem itens suficientes para transferir',
        ['navt'] = 'Tipo inválido...',
        ['anfoc'] = 'Argumentos não preenchidos corretamente...',
        ['yhg'] = 'Você deu ',
        ['cgitem'] = 'Não foi possível dar o item!',
        ['idne'] = 'O item não existe',
        ['pdne'] = 'O jogador não está online',
    },
    inf_mapping = {
        ['opn_inv'] = 'Abrir inventário',
        ['tog_slots'] = 'Alternar atalhos de teclas',
        ['use_item'] = 'Usa o item no slot ',
    },
    menu = {
        ['vending'] = 'Máquina de vendas',
        ['bin'] = 'Abrir lixeira',
        ['craft'] = 'Criar',
        ['o_bag'] = 'Abrir bolsa',
    },
    interaction = {
        ['craft'] = '~g~E~w~ - Criar',
    },
}

Lang = Lang or Locale:new({
    phrases = Translations,
    warnOnMissing = true
})
