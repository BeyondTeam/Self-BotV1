--By @SoLiD021
--By @SoLiD021
do
local function silent_by_reply(extra, success, result) 
  vardump(result)
  if result.to.peer_type == 'channel' then
    local chat = 'channel#id'..result.to.peer_id
    if tonumber(result.from.peer_id) == tonumber(our_id) then -- Ignore bot
      return "I won't silent myself"
    end
    send_large_msg(chat, "User "..result.from.first_name.." ["..result.from.peer_id.."] not alowed to chat. ")
      -- Save on redis
    local hash =  'silent:'..result.to.peer_id..':'..result.from.peer_id
    redis:set(hash, true)
  else
    return 'Use this in Your Groups'
  end
end
local function unsilent_by_reply(extra, success, result) 
  vardump(result)
  if result.to.peer_type == 'channel' then
    local chat = 'channel#id'..result.to.peer_id
    if tonumber(result.from.peer_id) == tonumber(our_id) then -- Ignore bot
      return "I won't silent myself"
    end
    send_large_msg(chat, "User "..result.from.first_name.." ["..result.from.peer_id.."] alowed to chat. ")
      -- Save on redis
    local hash =  'silent:'..result.to.peer_id..':'..result.from.peer_id
    redis:del(hash)
  else
    return 'Use this in Your Groups'
   end
end

local function add_by_reply(extra, success, result)
    result = backward_msg_format(result)
    local msg = result
    local chat = msg.to.id
    local user = msg.from.id
    if msg.to.type == 'chat' then
        chat_add_user('chat#id'..chat, 'user#id'..user, ok_cb, false)
    elseif msg.to.type == 'channel' then
        channel_invite('channel#id'..chat, 'user#id'..user, ok_cb, false)
    end
end

local function add_by_username(cb_extra, success, result)
    local chat_type = cb_extra.chat_type
    local chat_id = cb_extra.chat_id
    local user_id = result.peer_id
    local user_username = result.username
    print(chat_id)
    if chat_type == 'chat' then
        chat_add_user('chat#id'..chat_id, 'user#id'..user_id, ok_cb, false)
    elseif chat_type == 'channel' then
        channel_invite('channel#id'..chat_id, 'user#id'..user_id, ok_cb, false)
    end
end

local function kick_user(user_id, chat_id)
    local chat = 'chat#id'..chat_id
    local user = 'user#id'..user_id
    local channel = 'channel#id'..chat_id
    if user_id == tostring(our_id) then
        print("I won't kick myself!")
    else
        chat_del_user(chat, user, ok_cb, true)
        channel_kick(channel, user, ok_cb, true)
    end
end

local function chat_kick(extra, success, result)
    result = backward_msg_format(result)
    local msg = result
    local chat = msg.to.id
    local user = msg.from.id
    local chat_type = msg.to.type
    if chat_type == 'chat' then
        chat_del_user('chat#id'..chat, 'user#id'..user, ok_cb, false)
    elseif chat_type == 'channel' then
        channel_kick('channel#id'..chat, 'user#id'..user, ok_cb, false)
    end
end

local function kick_by_username(cb_extra, success, result)
    chat_id = cb_extra.chat_id
    user_id = result.peer_id
    chat_type = cb_extra.chat_type
    user_username = result.username
    if chat_type == 'chat' then
        chat_del_user('chat#id'..chat_id, 'user#id'..user_id, ok_cb, false)
    elseif chat_type == 'channel' then
        channel_kick('channel#id'..chat_id, 'user#id'..user_id, ok_cb, false)
    end
end

local function run(msg, matches)
       if matches[1] == 'setname' and is_sudo(msg) then
            local hash = 'name:enabled:'..msg.to.id
            if not redis:get(hash) then
                if msg.to.type == 'chat' then
                    rename_chat(msg.to.peer_id, matches[2], ok_cb, false)
                else
                    rename_channel(msg.to.peer_id, matches[2], ok_cb, false)
                end
            end
            return
        end

if matches[1] == 'newlink' and is_sudo(msg) then
        	local receiver = get_receiver(msg)
            local hash = 'link:'..msg.to.id
    		local function cb(extra, success, result)
    			if result then
    				redis:set(hash, result)
    			end
	            if success == 0 then
	                return send_large_msg(receiver, 'Error*\nNewlink not created\nI am Not Group Creator', ok_cb, true)
	            end
    		end
    		if msg.to.type == 'chat' then
                result = export_chat_link(receiver, cb, true)
            else
                result = export_channel_link(receiver, cb, true)
            end
    		if result then
	            if msg.to.type == 'chat' then
	                send_msg('chat#id'..msg.to.id, 'Newlink created', ok_cb, true)
	            else
	                send_msg('channel#id'..msg.to.id, 'Newlink created', ok_cb, true)
	            end
	        end
        end

if matches[1] == 'setlink' and is_sudo(msg) then
            hash = 'link:'..msg.to.id
            redis:set(hash, matches[2])
            if msg.to.type == 'chat' then
                    send_msg('chat#id'..msg.to.id, 'Link Has Been Setted', ok_cb, true)
            else
                    send_msg('channel#id'..msg.to.id, 'Link Has Been Setted', ok_cb, true)
            end
        end

    if matches[1] == 'link' and is_sudo(msg) then
            hash = 'link:'..msg.to.id
            local linktext = redis:get(hash)
            if linktext then
                if msg.to.type == 'chat' then
                    send_msg('user#id'..msg.from.id, 'Group Link :'..linktext, ok_cb, true)
                else
                    send_msg('user#id'..msg.from.id, 'SuperGroup Link :'..linktext, ok_cb, true)
                end
                return 'Link was sent in your pv'
            else
                if msg.to.type == 'chat' then
                    send_msg('chat#id'..msg.to.id, 'Error*\nSend /newlink first', ok_cb, true)
                else
                    send_msg('channel#id'..msg.to.id, 'Error*\nSend /newlink first', ok_cb, true)
                end
            end
         end

    if matches[1] == 'tosuper' then
        if msg.to.type == 'chat' then
            if is_sudo(msg) then
                chat_upgrade('chat#id'..msg.to.id, ok_cb, false)
                return 'Chat Upgraded To SuperGroup.'
            end
        else
            return 
        end
     end

if matches[1] == 'kick' and is_sudo(msg) then
            local chat_id = msg.to.id
            local chat_type = msg.to.type
            if msg.reply_id then
                get_message(msg.reply_id, chat_kick, false)
                return
            end
            if matches[1] == 'kick' and is_sudo(msg) then
                local member = string.gsub(matches[2], '@', '')
                resolve_username(member, kick_by_username, {chat_id=chat_id, member=member, chat_type=chat_type})
                return
            else
                local user_id = matches[2]
                if msg.to.type == 'chat' then
                    chat_del_user('chat#id'..msg.to.id, 'user#id'..matches[2], ok_cb, false)
                elseif msg.to.type == 'channel' then
                    channel_kick('channel#id'..msg.to.id, 'user#id'..matches[2], ok_cb, false)
                end
            end
        end

   if matches[1] == 'inv' and is_sudo(msg) then
            local chat_id = msg.to.id
            local chat_type = msg.to.type
            if msg.reply_id then
                get_message(msg.reply_id, add_by_reply, false)
                return
            end
   if matches[1] == 'inv' and is_sudo(msg) then
                local member = string.gsub(matches[2], '@', '')
                print(chat_id)
                resolve_username(member, add_by_username, {chat_id=chat_id, member=member, chat_type=chat_type})
                return
            else
                local user_id = matches[2]
                if chat_type == 'chat' then
                    chat_add_user('chat#id'..chat_id, 'user#id'..user_id, ok_cb, false)
                elseif chat_type == 'channel' then
                    channel_invite('channel#id'..chat_id, 'user#id'..user_id, ok_cb, false)
              end
            end
    end

local chat = 'channel#id'..msg.to.id
        if msg.to.type == 'channel' and matches[1] == 'setdes' and is_sudo(msg) then
        local about = matches[2]
        channel_set_about(chat, about, ok_cb, false)
        return 'Description has been setted'
    end

if msg.to.type == "channel" then
    if matches[1] == "silent" and is_sudo(msg) then
      if type(msg.reply_id)~= "nil" then
        msgr = get_message(msg.reply_id, silent_by_reply, false)
      elseif string.match(matches[2], '^%d+$') then
        local channel = msg.to.id
        local user = matches[2]
        local hash = 'silent:'..channel..':'..user
        redis:set(hash, true)
        return "User ["..matches[2].."] not alowed to chat."
      end
    end
    if matches[1] == "unsilent" and is_sudo(msg) then
   if type(msg.reply_id)~="nil" then
     msgr = get_message(msg.reply_id, unsilent_by_reply, false)
   elseif string.match(matches[2], '^%d+$') then
     local channel = msg.to.id
  local user = matches[2]
     local hash = 'silent:'..channel..':'..user
        redis:del(hash)
        return "User ["..matches[2].."] alowed to chat."
   end
    end
  end
    
    if matches[1] == 'mute all' and is_sudo(msg) then
      
            
                    local hash = 'mate:'..msg.to.id
                    redis:set(hash, true)
                    return "Mute All Has Been Enabled"
  elseif matches[1] == 'unmute all' and is_sudo(msg) then
                    local hash = 'mate:'..msg.to.id
                    redis:del(hash)
                    return "Mute All Has Been Disabled"
					end
					if matches[1] == 'mute status' then
                    local hash = 'mate:'..msg.to.id
                    if redis:get(hash) then
                    return "Mute All Is Enable"
					else 
					return "Mute All Is Disable"

end
end
end

local function pre_process (msg)
  if msg.service then
    return msg
  end
  
  local lock = "silent:"..msg.to.id..":"..msg.from.id
  local enable = redis:get(lock)
  if enable and msg.to.type == "channel" then
      delete_msg(msg.id, ok_cb, false)
  end
    local hash = 'mate:'..msg.to.id
    if redis:get(hash) and msg.from.id and msg.to.type == 'channel' and not is_sudo(msg)  then
	  delete_msg(msg.id, ok_cb, false)
            return "mute all was enabled"
        end
  return msg
end

return {
    patterns = {
        '^[!/#](setname) (.*)$',
        '^[!/#](link)$',
        '^[!/#](tosuper)$',
        '^[!/#](newlink)$',
        '^[!/#](setlink) (.*)$',
        '^[!/#](setdes) (.*)$',
        "^[!/#](kick)$",
        "^[!/#](kick) (.*)$",
        "^[!/#](silent)$",
        "^[!/#](silent) (.*)$",
        "^[!/#](unsilent)$",
        "^[!/#](unsilent) (.*)$",
        "^[/!#](mute all)$",
        "^[/!#](unmute all)$",
		     "^[/!#](mute status)$",
        "^[!/#](inv)$",
        "^[!/#](inv) (.*)$",
    },
      run = run,
pre_process = pre_process
}
end
