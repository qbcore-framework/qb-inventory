sort=true
new_type("event","Server Events")
new_type("command","Command")
custom_tags={ {'deprecated',title='Deprecated', hidden=true} }
dir="docs"

custom_display_name_handler = function(item, default_handler)
  if item.type == 'event' and item.tags.deprecated then
    return item.name.."<br><b>⚠️ DEPRECATED! Do not use it.</b>"
  end
  return default_handler(item)
end