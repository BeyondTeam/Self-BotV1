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
local function run(msg, matches)
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
  return msg
end

return {
  patterns = {
    "^[!/#](silent)$",
 "^[!/#](unsilent)$",
    "^[!/#](silent) (.*)$",
    "^[!/#](unsilent) (.*)$"
  },
  run = run,
  pre_process = pre_process
}

end
