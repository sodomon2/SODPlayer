--[[
lgettext: gettext module for lua.
https://github.com/t-kenji/lgettext
Copyright 2017 t-kenji <protect.2501@gmail.com>
MIT Licensed.
]]
local bit = require('bit')
local unpack = unpack or table.unpack

local _gettext = {}
gettext = _gettext

function string:split(sep)
    local fields = {}
    local from = 1
    local sep_from, sep_to = self:find(sep, from)
    while sep_from do
        fields[#fields + 1] = self:sub(from, sep_from - 1)
        from = sep_to + 1
        sep_from, sep_to = self:find(sep, from)
    end
    fields[#fields + 1] = self:sub(from)
    return fields
end

function string:trim()
    return (self:gsub('^%s*(.-)%s*$', '%1'))
end

function table.has_value(tbl, val)
    for _, v in ipairs(tbl) do
        if v == val then
            return true
        end
    end
    for _, v in pairs(tbl) do
        if v == val then
            return true
        end
    end
    return false
end

function table.reverse(tbl)
    local len = #tbl
    local ret = {}

    for i = len, 1, -1 do
        ret[len - i + 1] = tbl[i]
    end

    return ret
end


local _default_localedir = '@prefix@/@localedir@/'

local _c2lua = function(plural)
    local correct = plural:gsub('!', '~')
    if correct == '0' then
        correct = 'false'
    end
    return loadstring('return function(n) return '..correct..' and 1 or 0 end')()
end

local _expand_lang = function(locale)
    local COMPONENT_CODESET = bit.lshift(1, 0)
    local COMPONENT_TERRITORY = bit.lshift(1, 1)
    local COMPONENT_MODIFIER = bit.lshift(1, 2)

    local mask = 0
    local pos
    local modifier = ''
    local codeset = ''
    local territory = ''

    pos = locale:find('@')
    if pos and pos > 0 then
        modifier = locale:sub(pos)
        locale = locale:sub(1, pos - 1)
        mask = bit.bor(mask, COMPONENT_MODIFIER)
    end

    pos = locale:find('%.')
    if pos and pos > 0 then
        codeset = locale:sub(pos)
        locale = locale:sub(1, pos - 1)
        mask = bit.bor(mask, COMPONENT_CODESET)
    end

    pos = locale:find('_')
    if pos and pos > 0 then
        territory = locale:sub(pos)
        locale = locale:sub(1, pos - 1)
        mask = bit.bor(mask, COMPONENT_TERRITORY)
    end

    local language = locale
    local ret = {}
    for i = 0, mask do
        if bit.band(i, bit.bnot(mask)) == 0 then
            local val = language
            if bit.band(i, COMPONENT_TERRITORY) ~= 0 then
                val = val..territory
            end
            if bit.band(i, COMPONENT_CODESET) ~= 0 then
                val = val..codeset
            end
            if bit.band(i, COMPONENT_MODIFIER) ~= 0 then
                val = val..modifier
            end
            ret[#ret + 1] = val
        end
    end

    return table.reverse(ret)
end

local _unpack = function(buf)
    local bytes = {string.byte(buf, 1, -1)}
    local result = 0
    for i, v in ipairs(bytes) do
        result = result + bit.lshift(v, (i - 1) * 8)
    end
    return result
end

local _GNUTranslations = {
    -- Magic number of .mo files
    LE_MAGIC = 0x950412de,
    BE_MAGIC = 0xde120495,

    -- Acceptable .mo versions
    VERSIONS = {0, 1},
}
local _MetaGNUTranslations = {__metatable = {}}

_MetaGNUTranslations.__index = _GNUTranslations

_GNUTranslations.__call = function(self, mofile, f)
    local this = setmetatable({}, _MetaGNUTranslations)
    local filename = mofile
    this._info = {}
    this._catalog = {}
    this.plural = function(n) return n == 1 and 0 or 1 end
    local get_versions = function(version)
        -- Returns a table of major version, minor version
        return bit.rshift(version, 16), bit.band(version, 0xffff)
    end

    local buf = f:read('*a')
    local buflen = f:seek('end', 0)
    local magic = _unpack(string.sub(buf, 1, 4))
    local version, msgcount, masteridx, transidx = 0, 0, 0, 0
    if bit.tohex(magic) == bit.tohex(this.LE_MAGIC) then
        version = _unpack(string.sub(buf, 5, 8))
        msgcount = _unpack(string.sub(buf, 9, 12))
        masteridx = _unpack(string.sub(buf, 13, 16))
        transidx = _unpack(string.sub(buf, 17, 20))
    elseif bit.tohex(magic) == bit.tohex(this.BE_MAGIC) then
        error('Big endian does not support')
    else
        error('Bad magic number')
    end

    local major_version, minor_version = get_versions(version)

    if not table.has_value(this.VERSIONS, major_version) then
        error('Bad version number '..tostring(major_version))
    end

    -- Now put all messages from the .mo file buffer into the catalog
    -- dictionary.
    for i = 0, msgcount - 1 do
        local mlen = _unpack(string.sub(buf, masteridx + 1, masteridx + 4))
        local moff = _unpack(string.sub(buf, masteridx + 5, masteridx + 8))
        local mend = moff + mlen
        local tlen = _unpack(string.sub(buf, transidx + 1, transidx + 4))
        local toff = _unpack(string.sub(buf, transidx + 5, transidx + 8))
        local tend = toff + tlen
        local msg, tmsg
        if mend < buflen and tend < buflen then
            msg = string.sub(buf, moff + 1, mend)
            tmsg = string.sub(buf, toff + 1, tend)
        else
            error('File is corrupt')
        end
        -- See if we're looking at GNU .mo convertions for metadata
        if mlen == 0 then
            -- Catalog description
            local lastk = nil
            for _, item in ipairs(tmsg:split('\n')) do
                item = item:trim()
                if item then
                    local v = nil
                    local k = nil
                    if item:find(':') then
                        k, v = unpack(item:split(':'))
                        k = k:trim():lower()
                        v = v and v:trim() or ''
                        this._info[k] = v
                        lastk = k
                    elseif lastk then
                        this._info[lastk] = this._info[lastk]..'\n'..item
                    end
                    if k == 'content-type' then
                        this._charset = v:gsub('.+%s*charset=([%w-]+)', '%1')
                    elseif k == 'plural-forms' then
                        v = v:split(';')
                        local plural = v[2]:gsub('.+%s*plural=([%w!=<>()|&/]+)', '%1')
                        this.plural = _c2lua(plural)
                    end
                end
            end
        end

        -- Note: we unconditionally convert both msgids and msgstrs to
        -- Unicode using the character encoding specified in the charset
        -- parameter of the Content-Type header.  The gettext documentation
        -- strongly encourages msgids to be us-ascii, but some applications
        -- require alternative encodings (e.g. Zope's ZCML and ZPT).  For
        -- traditional gettext applications, the msgid conversion will
        -- cause no problems since us-ascii should always be a subset of
        -- the charset encoding.  We may want to fall back to 8-bit msgids
        -- if the Unicode conversion fails.
        local charset = this._charset or 'ascii'
        if msg:find('\x00') then
            -- Plural forms
            msgid1, msgid2 = unpack(msg:split('\x00'))
            tmsg = tmsg:split('\x00')
            for i, x in ipairs(tmsg) do
                this._catalog[{msgid1, i - 1}] = x
            end
        else
            this._catalog[msg] = tmsg
        end
        masteridx = masteridx + 8
        transidx = transidx + 8
    end
    return this
end

function _GNUTranslations:gettext(message)
    return self._catalog[message]
           or self._fallback and self._fallback.gettext(message)
           or message
end

function _GNUTranslations:ngettext(msgid1, msgid2, n)
    local tmsg = n == 1 and msgid1
                 or msgid2
    for k, t in pairs(self._catalog) do
        if type(k) == 'table'
           and k[1] == msgid1
           and k[2] == self.plural(n) then

            tmsg = t or self._fallback
                        and self._fallback.ngettext(msgid1, msgid2, n)
        end
    end
    return tmsg
end

function _GNUTranslations:info()
    return self._info
end

function _GNUTranslations:charset()
    return self._charset
end

function _GNUTranslations:output_charset()
    return self._output_charset
end

function _GNUTranslations:set_output_charset(charset)
    self._output_charset = charset
end

local GNUTranslations = setmetatable({}, _GNUTranslations)

-- a mapping between absolute .mo file path and Translation object
_gettext.translations = {}

-- Locale a .mo file using the gettext strategy
local _find = function(domain, localedir, languages, all)
    -- Get some reasonable defaults for arguments that were not supplied
    if localedir == nil then
        localedir = _default_localedir
    end
    if languages == nil then
        languages = {}
        for _, envar in ipairs({'LANGUAGE', 'LC_ALL', 'LC_MESSAGES', 'LANG'}) do
            local val = os.getenv(envar)
            if val then
                languages = val:split(':')
                break
            end
        end
        if not table.has_value(languages, 'C') then
            languages[#languages + 1] = 'C'
        end
    end

    -- now normalize and expand the languages
    local nelangs = {}
    for _, lang in ipairs(languages) do
        for _, nelang in ipairs(_expand_lang(lang)) do
            if nelangs[nelang] == nil then
                nelangs[#nelangs + 1] = nelang
            end
        end
    end
    -- select a language
    if all ~= 0 then
        result = {}
    else
        result = nil
    end
    for _, lang in ipairs(nelangs) do
        if lang == 'C' then
            break
        end
        mofile = string.format('%s/%s/%s/%s.mo', localedir, lang, 'LC_MESSAGES', domain)
        local f = io.open(mofile)
        if f then
            f:close()
            if all ~= 0 then
                result[#result + 1] = mofile
            else
                return {mofile}
            end
        end
    end
    return result
end

function _gettext.translation(domain, localedir, languages, codeset)
    local mofiles = _find(domain, localedir, languages, 1)
    if mofiles == nil then
        return nil
    end
    -- Avoid opening, reading, and parsing the .mo file after it's been done
    -- once.
    local result = nil
    for _, mofile in ipairs(mofiles) do
        key = mofile
        t = _gettext.translations[key]
        if t == nil then
            f = io.open(mofile)
            if f then
                t = GNUTranslations(mofile, f)
                _gettext.translations[key] = t
                f:close()
            end
        end

        if codeset then
            t:set_output_charset(codeset)
        end
        if result == nil then
            result = t
        else
            result:add_fallback(t)
        end
    end
    return result
end

-- a mapping b/w domains and locale directories
_gettext.localedirs = {}

-- a mapping b/w domains and codesets
_gettext.localecodesets = {}

-- current global domain, 'messages' used for compatibility w/ GNU gettext
_gettext.current_domain = 'messages'

function _gettext.dgettext(domain, message)
    local t = _gettext.translation(domain,
                                   _gettext.localedirs[domain],
                                   nil,
                                   _gettext.localecodesets[domain])
    return t and t:gettext(message)
           or message
end

function _gettext.dngettext(domain, msgid1, msgid2, n)
    local t = _gettext.translation(domain,
                                   _gettext.localedirs[domain],
                                   nil,
                                   _gettext.localecodesets[domain])
    return t and t:ngettext(msgid1, msgid2, n)
           or n == 1 and msgid1
           or msgid2
end

function _gettext.gettext(message)
    return _gettext.dgettext(_gettext.current_domain, message)
end

function _gettext.ngettext(msgid1, msgid2, n)
    return _gettext.dngettext(_gettext.current_domain, msgid1, msgid2, n)
end

function _gettext.textdomain(domain)
    if domain then
        _gettext.current_domain= domain
    end
    return _gettext.current_domain
end

function _gettext.bindtextdomain(domain, dirname)
    if dirname then
        _gettext.localedirs[domain] = dirname
    end
    return _gettext.localedirs[domain]
end

function _gettext.bind_textdomain_codeset(domain, codeset)
    if codeset then
        _gettext.localecodesets[domain] = codeset
    end
    return _gettext.localecodesets[domain]
end

return gettext
