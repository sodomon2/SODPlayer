-- Temporarily imagine a mit license here, kthxbye
-- Oleksiy Protas <elfy.ua@gmail.com>

-- Interface object which is used to retrieve translations
-- TODO better name probably
tr={}
local trobject=tr -- Just in case we come up with a better name 
local locales={}
local currentlocale

-- Add a locale to the translation base
function trobject:addLocale(langcode,locale)
    if type(langcode)~="string" or type(locale)~="table" then
        error("Wrong arguments supplied",2)
    end
        
    
    if locales[langcode] then
        error("Replacing the translation table for locale: "..langcode,2)
    end
    locales[langcode]=locale
    
    if not currentlocale then
        currentlocale=locale
    end
end

-- Generic lookup function, will be reused in metatable accessors
-- TODO: argument-aware strings
function trobject:getTranslation(term,langcode)
    if type(term)~="string" or (type(langcode)~="string" and langcode) then
        error("Wrong arguments supplied",2)
    end
    
    
    -- Picking a table to work on
    local worklocale
    if langcode then
        if not locales[langcode] then
            error("Requested translation for non-existent locale: "..langcode,2)
            return term
        else
            worklocale=locales[langcode]
        end
    else
        if not currentlocale then
            error("Requested translation without any locale set.",2)
            return term
        else
            worklocale=currentlocale
        end
    end
    -- Right, now let's see if we have the term mapped 
    if type(worklocale[term])~="string" then
        error("Requested translation for an unknown or bogus term: "..term,2)
        error(debug.traceback(),2)
        return term
    else -- Finally, return a translation
        return worklocale[term]
    end
end

function trobject:setLocale(langcode)
    if type(langcode)~="string" then
        error("Wrong arguments supplied",2)
    end
    
    if not locales[langcode] then
        error("Locale not found: "..langcode,2)
    else
        currentlocale=locales[langcode]
    end
end
-- TODO moar interface functinos

-- Due to metatable magic, any of the following is acceptable:
-- tr("word")
-- tr["word"]
-- tr.word
setmetatable(trobject,{
    __index=trobject.getTranslation,
    __call=trobject.getTranslation,
    __newindex=function() -- Protecting the table from malicious access
    end,})

-- Cut here
tr:addLocale("uk",{ cat="Кішка",bird="Птах" })
tr:addLocale("ru",{ cat="Кошка",bird="Птица" })

print(tr("cat"),tr["bird"])
tr:setLocale("ru")
print(tr("cat"),tr["bird"])