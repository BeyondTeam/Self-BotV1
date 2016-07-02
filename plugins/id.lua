
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
    if cb_extra.chat_type == 'chat' then
        send_msg('chat#id'..chat_id, user_id, ok_cb, false)
    elseif cb_extra.chat_type == 'channel' then
        send_msg('channel#id'..chat_id, user_id, ok_cb, false)
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
    local receiver = get_receiver(msg)
    local chat = msg.to.id
    -- Id of the user and info about group / channel
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
    if matches[1] == 'id' and matches[2] == '@[%a%d]' and is_sudo(msg) then
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
    "^[!/#](id)$",
    "^[!/#](gpid)$",
    "^[!/#](id) (.*)$"
  },
  run = run
}
