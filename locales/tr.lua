local Translations = {
    progress = {
        ["crafting"] = "Üretiyorsun...",
        ["snowballs"] = "Kartopu yaptın...",
    },
    notify = {
        ["failed"] = "Başarısız",
        ["canceled"] = "İptal Edildi",
        ["vlocked"] = "Araç kitli",
        ["notowned"] = "Bu iteme sahip değilsin!",
        ["missitem"] = "Bu itemi alamazsın!",
        ["nonb"] = "Yakınında Kimse yok!",
        ["noaccess"] = "Erişilebilir Değil",
        ["nosell"] = "Bu ürünü satamazsın...",
        ["itemexist"] = "İtem mevcut değil??",
        ["notencash"] = "Yeterli Paran yok...",
        ["noitem"] = "Doğru eşyaya sahip değilsiniz...",
        ["gsitem"] = "Kendine item veremezsin?",
        ["tftgitem"] = "Çok uzaktasın!",
        ["infound"] = "Vermeyi denediğiniz öğe bulunamadı!",
        ["iifound"] = "Yanlış öğe bulundu tekrar deneyin!",
        ["gitemrec"] = "Aldınız ",
        ["gitemfrom"] = " Bundan ",
        ["gitemyg"] = "Verdin ",
        ["gitinvfull"] = "Diğer kişinin envanteri full!",
        ["giymif"] = "Envanterin Full!",
        ["gitydhei"] = "Yeterli miktarda item yok",
        ["gitydhitt"] = "Vermek için yeterli item yok",
        ["navt"] = "Geçerli bir tür değil...",
        ["anfoc"] = "Argümanlar doğru doldurulmamış...",
        ["yhg"] = "Verdin ",
        ["cgitem"] = "Bunu veremezsin!",
        ["idne"] = "İtem bulunamadı",
        ["pdne"] = "Oyuncu Aktif değil ",
    },
    inf_mapping = { 
        ["opn_inv"] = "Envanteri Aç",
        ["tog_slots"] = "Tuş bağlama yuvalarını değiştirir",
        ["use_item"] = "Yuvadaki öğeyi kullanır",
    },
    menu = {
        ["vending"] = "Otomat",
        ["craft"] = "Üret",
        ["o_bag"] = "Çantayı Aç",
    },
    interaction = {
        ["craft"] = "[E] - Üret",
    },
    label = {
        ["craft"] = "Ürelitiyor",
        ["a_craft"] = "Eklenti Üretiliyor",
        ["player"] = "Oyuncu",
    },
}

if GetConvar('qb_locale', 'en') == 'tr' then
    Lang = Locale:new({
        phrases = Translations,
        warnOnMissing = true,
        fallbackLang = Lang,
    })
end
