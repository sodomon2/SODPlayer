
-- Original description
-----------------------------------------------------------
-- load an mo file and return a lua table
-- @param mo_file name of the file to load
-- @return table on success
-- @return nil,string on failure
-- @copyright J.J?rgen von Bargen
-- @licence I provide this as public domain
-- @see http://www.gnu.org/software/hello/manual/gettext/MO-Files.html
-- @see https://gist.github.com/keyring/a0530f34f885b322585f46c527204160
-----------------------------------------------------------

local Gettext     = class('Gettext')

function Gettext:gettext(mo)
	local hash = Gettext:parseData(mo)
	return function(text)
		return hash[text] or text
	end
end

function Gettext:parseData(mo_data)
    --------------------------------
    -- precache some functions
    --------------------------------
    local byte=string.byte
    local sub=string.sub

    --------------------------------
    -- check format
    --------------------------------
    local peek_long --localize
    local magic=sub(mo_data,1,4)
    -- intel magic 0xde120495
    if magic=="\222\018\004\149" then
        peek_long=function(offs)
            local a,b,c,d=byte(mo_data,offs+1,offs+4)
            return ((d*256+c)*256+b)*256+a
        end
    -- motorola magic = 0x950412de
    elseif magic=="\149\004\018\222" then
        peek_long=function(offs)
            local a,b,c,d=byte(mo_data,offs+1,offs+4)
            return ((a*256+b)*256+c)*256+d
        end
    else
        return nil,"no valid mo-file"
    end

    --------------------------------
    -- version
    --------------------------------
    local V=peek_long(4)
    if V~=0 then
        return nul,"unsupported version"
    end

    ------------------------------
    -- get number of offsets of table
    ------------------------------
    local N,O,T=peek_long(8),peek_long(12),peek_long(16)
    ------------------------------
    -- traverse and get strings
    ------------------------------
    local hash={}
    for nstr=1,N do
        local ol,oo=peek_long(O),peek_long(O+4) O=O+8
        local tl,to=peek_long(T),peek_long(T+4) T=T+8
        hash[sub(mo_data,oo+1,oo+ol)]=sub(mo_data,to+1,to+tl)
    end
    return hash    -- return table
end

local locale	= (os.getenv("LC_ALL"))
local file	= ('/usr/share/locale/%s/LC_MESSAGES/sodplayer.mo'):format(locale)
if (file) then
	local  fd,err=io.open(file,"rb")
	if not fd then return nil,err end
	local  mo=fd:read("*all")
	fd:close()
	return Gettext:gettext(mo)
end

return Gettext
