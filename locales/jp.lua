--[[
English base language translation for qb-inventory
Translation done by wanderrer (Martin Riggs#0807 on Discord)
]]--
local Translations = {
    progress = {
        ["crafting"] = "工作中...",
        ["snowballs"] = "雪玉を回収中...",
    },
    notify = {
        ["failed"] = "失敗しました。",
        ["canceled"] = "キャンセルされました。",
        ["vlocked"] = "鍵をかけました。",
        ["notowned"] = "このアイテムは所有していません。",
        ["missitem"] = "このアイテムは所有していません。",
        ["nonb"] = "近くに誰もいません。",
        ["noaccess"] = "アクセス不可です。",
        ["nosell"] = "このアイテムは売却不可です。",
        ["itemexist"] = "アイテムは存在してません。",
        ["notencash"] = "十分なお金がありません。",
        ["noitem"] = "適切なアイテムを所持していません。",
        ["gsitem"] = "自分自身にアイテムは渡せません。",
        ["tftgitem"] = "アイテムを渡す相手との距離が遠すぎます。",
        ["infound"] = "あなたが渡そうとしているアイテムが見つかりませんでした。",
        ["iifound"] = "誤ったアイテムが見つかりました。再試行してください。",
        ["gitemrec"] = "アイテムを受け取りました: ",
        ["gitemfrom"] = " 贈呈者: ",
        ["gitemyg"] = "アイテムを贈呈しました: ",
        ["gitinvfull"] = "相手のインベントリが満杯です!",
        ["giymif"] = "あなたのインベントリは満杯です!",
        ["gitydhei"] = "あなたは十分なアイテムを所持していません。",
        ["gitydhitt"] = "贈呈するために十分なアイテムを所持していません。",
        ["navt"] = "有効なタイプではありません。",
        ["anfoc"] = "引数を正しく指定してください。",
        ["yhg"] = "贈呈しました: ",
        ["cgitem"] = "このアイテムは贈呈できません!",
        ["idne"] = "このアイテムは存在しません。",
        ["pdne"] = "プレイヤーはオフラインです。",
    },
    inf_mapping = {
        ["opn_inv"] = "インベントリを開く",
        ["tog_slots"] = "スロットのキー設定",
        ["use_item"] = "アイテムを使用 スロット番号: ",
    },
    menu = {
        ["vending"] = "自動販売機",
        ["craft"] = "工作",
        ["o_bag"] = "カバンを開く",
    },
    interaction = {
        ["craft"] = "~g~E~w~ - 工作",
    },
    label = {
        ["craft"] = "工作",
        ["a_craft"] = "アタッチメントの工作",
    },
}

Lang = Lang or Locale:new({
    phrases = Translations,
    warnOnMissing = true
})
