function T(key, ...)
    if Locales[Config.Locale] and Locales[Config.Locale][key] then
        return string.format(Locales[Config.Locale][key], ...)
    else
        return "Translation [" .. key .. "] not found!"
    end
end