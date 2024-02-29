local Translations = {
    progress = {
        ["crafting"] = "クラフト中...",
        ["snowballs"] = "雪玉集め中..",
    },
    notify = {
        ["failed"] = "失敗しました",
        ["canceled"] = "キャンセルしました",
        ["vlocked"] = "乗り物をロックしました",
        ["notowned"] = "この商品は所有していません!",
        ["missitem"] = "このアイテムを持っていません!",
        ["nonb"] = "近くに誰もいません!",
        ["noaccess"] = "アクセスできません",
        ["nosell"] = "このアイテムは売ることができません..",
        ["itemexist"] = "アイテムがありません",
        ["notencash"] = "現金が足りません..",
        ["noitem"] = "正しいアイテムを持っていません..",
        ["gsitem"] = "アイテムは自分へは渡せません",
        ["tftgitem"] = "相手との距離が遠いためアイテムを渡せません!",
        ["infound"] = "アイテムが見つかりません!",
        ["iifound"] = "間違ったアイテムです!",
        ["gitemrec"] = "アイテムを受け取りました: ",
        ["gitemfrom"] = " 渡した人: ",
        ["gitemyg"] = "アイテムを渡した: ",
        ["gitinvfull"] = "相手のインベントリがいっぱいなので渡せません!",
        ["giymif"] = "インベントリがいっぱいで受け取れません!",
        ["gitydhei"] = "アイテムの数が足りません",
        ["gitydhitt"] = "転送するアイテムが足りません",
        ["navt"] = "有効な種類ではありません",
        ["anfoc"] = "引数が正しく入力されていません..",
        ["yhg"] = "アイテムを渡した: ",
        ["cgitem"] = "アイテムを渡せませんでした!",
        ["idne"] = "アイテムが見つかりません",
        ["pdne"] = "プレイヤーはオフラインです",
    },
    inf_mapping = {
        ["opn_inv"] = "インベントリを開く",
        ["tog_slots"] = "キー割り当てスロットを切り替え",
        ["use_item"] = "アイテムを使用: ",
    },
    menu = {
        ["vending"] = "自動販売機",
        ["craft"] = "クラフト",
        ["o_bag"] = "バッグを開く",
    },
    interaction = {
        ["craft"] = "~g~E~w~ - クラフト",
    },
    label = {
        ["craft"] = "クラフト",
        ["a_craft"] = "アタッチメントのクラフト",
    },
}

if GetConvar('qb_locale', 'en') == 'ja' then
    Lang = Locale:new({
        phrases = Translations,
        warnOnMissing = true,
        fallbackLang = Lang,
    })
end
