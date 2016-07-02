do

local function pre_process(msg)
    
    local hash = 'mate:'..msg.to.id
    if redis:get(hash) and msg.from.id and msg.to.type == 'channel' and not is_sudo(msg)  then
	  delete_msg(msg.id, ok_cb, false)
            return "silent all was locked"
        end
    
        return msg
    end

  


local function run(msg, matches)
    channel_id = msg.to.id
    
    if matches[1] == 'silent' and is_sudo(msg) then
      
            
                    local hash = 'mate:'..msg.to.id
                    redis:set(hash, true)
                    return "Silent All Has Been Enabled"
  elseif matches[1] == 'unsilent' and is_sudo(msg) then
                    local hash = 'mate:'..msg.to.id
                    redis:del(hash)
                    return "Silent All Has Been Disabled"
					end
					if matches[1] == 'status' then
                    local hash = 'mate:'..msg.to.id
                    if redis:get(hash) then
                    return "Silent All Is Enable"
					else 
					return "Silent All Is Disable"

end
end
end
return {
    patterns = {
        '^[/!#](silent) all$',
        '^[/!#](unsilent) all$',
		'^[/!#]silent (status)$',
    },
    run = run,
    pre_process = pre_process
}
end

--fix for channel by @telemanager_ch

--Tnx to Sbss Team
