do
--Begin Group Manager By @SoLiD021
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

local function usernameinfo (user)
    if user.username then
        return '@'..user.username
    end
    if user.print_name then
        return user.print_name
    end
    local text = ''
    if user.first_name then
        text = user.last_name..' '
    end
    if user.lastname then
        text = text..user.last_name
    end
    return text
end

local function whoisname(cb_extra, success, result)
    chat_type = cb_extra.chat_type
    chat_id = cb_extra.chat_id
    user_id = result.peer_id
    user_username = result.username
    if chat_type == 'chat' then
        send_msg('chat#id'..chat_id, user_id, ok_cb, false)
    elseif chat_type == 'channel' then
        send_msg('channel#id'..chat_id, user_id, ok_cb, false)
    end
end

local function whoisid(cb_extra, success, result)
    chat_id = cb_extra.chat_id
    user_id = cb_extra.user_id
    print_name = string.gsub(result.print_name, '_', ' ')
    if cb_extra.chat_type == 'chat' then
        send_msg("chat#id"..chat_id, "Name : "..print_name.."\nUsername : @"..(result.username or '').."\nUser ID : "..user_id, ok_cb, false)
    elseif cb_extra.chat_type == 'channel' then
        send_msg("channel#id"..chat_id, "Name : "..print_name.."\nUsername : @"..(result.username or '').."\nUser ID : "..user_id, ok_cb, false)
    end
end

local function get_id_who(extra, success, result)
    result = backward_msg_format(result)
    local msg = result
    local chat = msg.to.id
    local user = msg.from.id
    if msg.to.type == 'chat' then
        send_msg('chat#id'..msg.to.id, msg.from.id, ok_cb, false)
    elseif msg.to.type == 'channel' then
        send_msg('channel#id'..msg.to.id, msg.from.id, ok_cb, false)
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
    -----------------
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
                return 'Link was sent in your private message'
            else
                if msg.to.type == 'chat' then
                    send_msg('chat#id'..msg.to.id, 'Error*\nSend /newlink first', ok_cb, true)
                else
                    send_msg('channel#id'..msg.to.id, 'Error*\nSend /newlink first', ok_cb, true)
                end
            end
         end

    if matches[1] == 'linkgp' and is_sudo(msg) then
            hash = 'link:'..msg.to.id
            local linktext = redis:get(hash)
            if linktext then
                if msg.to.type == 'chat' then
                    send_msg('chat#id'..msg.to.id, 'Group Link :'..linktext, ok_cb, true)
                else
                    send_msg('channel#id'..msg.to.id, 'SuperGroup Link :'..linktext, ok_cb, true)
                end
                return ''
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
   if not string.match(matches[2], '^%d+$') then
                local member = string.gsub(matches[2], '@', '')
                resolve_username(member, kick_by_username, {chat_id=chat_id, member=member, chat_type=chat_type})
                return
     elseif string.match(matches[2], '^%d+$') then
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
   if not string.match(matches[2], '^%d+$') then
                local member = string.gsub(matches[2], '@', '')
                print(chat_id)
                resolve_username(member, add_by_username, {chat_id=chat_id, member=member, chat_type=chat_type})
                return
     elseif string.match(matches[2], '^%d+$') then
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
    if matches[1] == 'mute all' and is_sudo(msg) then
                    local hash = 'silent_gp:'..msg.to.id
                    if redis:get(hash) then
                    return "Mute All Is Already Enabled"
                else
                    redis:set(hash, true)
                    return "Mute All Has Been Enabled"
                  end
  elseif matches[1] == 'unmute all' and is_sudo(msg) then
                    local hash = 'silent_gp:'..msg.to.id
                    if not redis:get(hash) then
                    return "Mute All Is Not Enabled"
                else
                    redis:del(hash)
                    return "Mute All Has Been Disabled"
					end
             end
					if matches[1] == 'mute status' then
                    local hash = 'silent_gp:'..msg.to.id
                    if redis:get(hash) then
                    return "Mute All Is Enable"
					else 
					return "Mute All Is Disable"
        end
   end
end
---------------
         if matches[1] == 'leave' and is_sudo(msg) then
             local bot_id = our_id 
local receiver = get_receiver(msg)
       chat_del_user("chat#id"..msg.to.id, 'user#id'..bot_id, ok_cb, false)
	   leave_channel(receiver, ok_cb, false)
    end
   -------------------
        local receiver = get_receiver(msg)
    local chat = msg.to.id
    if matches[1] == 'gpid' then
         if not is_sudo(msg) then 
            return nil
            end

            if msg.to.type == 'channel' then
                send_msg(msg.to.peer_id, 'SuperGroup ID: '..msg.to.id, ok_cb, false)
            elseif msg.to.type == 'chat' then
                send_msg(msg.to.peer_id, 'Group ID: '..msg.to.id, ok_cb, false)
            end
        end
if matches[1] == 'id' then
     if not is_sudo(msg) then 
            return nil
            end
            chat_type = msg.to.type
            chat_id = msg.to.id
            if msg.reply_id then
                get_message(msg.reply_id, get_id_who, {receiver=get_receiver(msg)})
                return
            end
    if string.match(matches[2], '^%d+$') then
                print(1)
                user_info('user#id'..matches[2], whoisid, {chat_type=chat_type, chat_id=chat_id, user_id=matches[2]})
                return
            else
                local member = string.gsub(matches[2], '@', '')
                resolve_username(member, whoisname, {chat_id=chat_id, member=member, chat_type=chat_type})
                return
            end
        else
            return
        end
    end
return {
    patterns = {
        '^[!/#](setname) (.*)$',
        '^[!/#](link)$',
         "^[!/#](id)$",
        "^[!/#](gpid)$",
        "^[!/#](id) (.*)$",
        "^[#!/](leave)$",
        '^[!/#](linkgp)$',
        '^[!/#](tosuper)$',
        '^[!/#](newlink)$',
        '^[!/#](mute all)$',
        '^[!/#](unmute all)$',
        '^[!/#](mute status)$',
        '^[!/#](setlink) (.*)$',
        '^[!/#](setdes) (.*)$',
        "^[!/#](kick)$",
        "^[!/#](kick) (.*)$",
        "^[!/#](inv)$",
        "^[!/#](inv) (.*)$",
    },
      run = run
}
end
