do
--Begin Member Manager By @SoLiD021
--silent_user By @SoLiD021
local function silentuser_by_reply(extra, success, result)
 	 local user_id = result.from.peer_id
		local receiver = extra.receiver
		local chat_id = result.to.peer_id
		print(user_id)
		print(chat_id)
		if is_muted_user(chat_id, user_id) then
			return send_large_msg(receiver, " ["..user_id.."] is already silented.")
		end
			mute_user(chat_id, user_id)
		return 	send_large_msg(receiver, " ["..user_id.."] added to silent users list.")
	end

local function silentuser_by_username(extra, success, result)
		local user_id = result.peer_id
		local receiver = extra.receiver
		local chat_id = string.gsub(receiver, 'channel#id', '')
		if is_muted_user(chat_id, user_id) then
			return send_large_msg(receiver, " ["..user_id.."] is already silented.")
		end
			mute_user(chat_id, user_id)
		return send_large_msg(receiver, " ["..user_id.."] added to silent users list.")
	end

--unsilent_user By @SoLiD021
function unsilentuser_by_reply(extra, success, result)
	 local user_id = result.from.peer_id
		local receiver = extra.receiver
		local chat_id = result.to.peer_id
		print(user_id)
		print(chat_id)
		if is_muted_user(chat_id, user_id) then
			unmute_user(chat_id, user_id)
			send_large_msg(receiver, "["..user_id.."] removed from silent users list.")
else
			send_large_msg(receiver, "["..user_id.."] is not silented.")
		end
	end

local function unsilentuser_by_username(extra, success, result)
		local user_id = result.peer_id
		local receiver = extra.receiver
		local chat_id = string.gsub(receiver, 'channel#id', '')
		if is_muted_user(chat_id, user_id) then
			unmute_user(chat_id, user_id)
			send_large_msg(receiver, "["..user_id.."] removed from silent users list.")
else
			send_large_msg(receiver, "["..user_id.."] is not silented.")
		end
	end

--By @SoLiD021
local function block_by_reply(extra, success, result)
    local user_id = result.from.peer_id
    reply_msg(result.id, "User "..user_id.." has been blocked", ok_cb, true)
block_user("user#id"..user_id,ok_cb,false)
end

--By @SoLiD021
local function block_by_username(extra, success, result)
    local user_id = result.peer_id
    reply_msg(extra.msg.id, "User "..user_id.." has been blocked", ok_cb, true)
block_user("user#id"..user_id,ok_cb,false)
end

--By @SoLiD021
local function unblock_by_reply(extra, success, result)
          local user_id = result.from.peer_id
    reply_msg(result.id, "User "..user_id.." has been unblocked", ok_cb, true)
unblock_user("user#id"..user_id,ok_cb,false)
end

--By @SoLiD021
local function unblock_by_username(extra, success, result)
          local user_id = result.peer_id
    reply_msg(extra.msg.id, "User "..user_id.." has been unblocked", ok_cb, true)
unblock_user("user#id"..user_id,ok_cb,false)
end

local function run(msg, matches) 
             if is_sudo(msg) then
--By @SoLiD021
		if matches[1]:lower() == "pvblock" then
				local receiver = get_receiver(msg)
			if type(msg.reply_id) ~= "nil" then
				local receiver = get_receiver(msg)
				block = get_message(msg.reply_id, block_by_reply, {receiver = receiver, msg = msg})
			elseif matches[1]:lower() == "pvblock" and string.match(matches[2], '^%d+$') then
				local user_id = matches[2]
    reply_msg(msg.id, "User "..user_id.." has been blocked", ok_cb, true)
block_user("user#id"..user_id,ok_cb,false)
			elseif matches[1]:lower() == "pvblock" and not string.match(matches[2], '^%d+$') then
				local receiver = get_receiver(msg)
				local username = matches[2]
				local username = string.gsub(matches[2], '@', '')
				resolve_username(username, block_by_username, {receiver = receiver, msg=msg})
			end
		end

--By @SoLiD021
		if matches[1]:lower() == "pvunblock" then
			if type(msg.reply_id) ~= "nil" then
				local receiver = get_receiver(msg)
				unblock = get_message(msg.reply_id, unblock_by_reply, {receiver = receiver, msg = msg})
			elseif matches[1]:lower() == "pvunblock" and string.match(matches[2], '^%d+$') then
      local user_id = matches[2]
    reply_msg(msg.id, "User "..user_id.." has been unblocked", ok_cb, true)
unblock_user("user#id"..user_id,ok_cb,false)
			elseif matches[1]:lower() == "pvunblock" and not string.match(matches[2], '^%d+$') then
				local receiver = get_receiver(msg)
				local username = matches[2]
				local username = string.gsub(matches[2], '@', '')
				resolve_username(username, unblock_by_username, {receiver = receiver, msg=msg})
			end
		end 
   end 
if msg.to.type == "channel" and is_sudo(msg) then
		if matches[1]:lower() == "silent" then
			local chat_id = msg.to.id
			local hash = "mute_user:"..chat_id
			local user_id = ""
			if type(msg.reply_id) ~= "nil" then
				local receiver = get_receiver(msg)
				muteuser = get_message(msg.reply_id, silentuser_by_reply, {receiver = receiver, msg = msg})
			elseif matches[1]:lower() == "silent" and string.match(matches[2], '^%d+$') then
				local user_id = matches[2]
				if is_muted_user(chat_id, user_id) then
					return "["..user_id.."] is already silented."
      end
					mute_user(chat_id, user_id)
					return "["..user_id.."] added to silent users list."
			elseif matches[1]:lower() == "silent" and not string.match(matches[2], '^%d+$') then
				local receiver = get_receiver(msg)
				local username = matches[2]
				local username = string.gsub(matches[2], '@', '')
				resolve_username(username, silentuser_by_username, {receiver = receiver, msg=msg})
			end
		end

--By @SoLiD021
		if matches[1]:lower() == "unsilent" then
			local chat_id = msg.to.id
			local hash = "mute_user:"..chat_id
			local user_id = ""
			if type(msg.reply_id) ~= "nil" then
				local receiver = get_receiver(msg)
				muteuser = get_message(msg.reply_id, unsilentuser_by_reply, {receiver = receiver, msg = msg})
			elseif matches[1]:lower() == "unsilent" and string.match(matches[2], '^%d+$') then
				local user_id = matches[2]
				if is_muted_user(chat_id, user_id) then
					unmute_user(chat_id, user_id)
					return "["..user_id.."] removed from silent users list."
    else
					return "["..user_id.."] is not silented."
				end
			elseif matches[1]:lower() == "unsilent" and not string.match(matches[2], '^%d+$') then
				local receiver = get_receiver(msg)
				local username = matches[2]
				local username = string.gsub(matches[2], '@', '')
				resolve_username(username, unsilentuser_by_username, {receiver = receiver, msg=msg})
			end
		end
     if matches[1] == 'silentlist' then
			local chat_id = msg.to.id
     return muted_user_list(chat_id)
    end

			if matches[1] == 'clean' and matches[2] == 'silentlist' then

			local chat_id = msg.to.id
			local hash = "mute_user:"..chat_id
					redis:del(hash)
				return "silent list has been cleaned."
			end
       end
    end
local function pre_process(msg)
local chat_id = msg.to.id
local user_id = msg.from.id
  if msg.service then
    return msg
  end
     local hash = 'silent_gp:'..msg.to.id
    if redis:get(hash) and msg.to.type == 'channel' and not is_sudo(msg) then
	  delete_msg(msg.id, ok_cb, false)
            return 
        end
  if is_muted_user(chat_id, user_id) and msg.to.type == "channel" then
      delete_msg(msg.id, ok_cb, false)
  end
  return msg
end
return {
    patterns = {
        "^[!/#](silent)$",
        "^[!/#](silent) (.*)$",
        "^[!/#](unsilent)$",
        "^[!/#](unsilent) (.*)$",
        "^[!/#](silentlist)$",
        "^[!/#](clean) (.*)$",
        "^[!/#](pvblock)$",
        "^[!/#](pvblock) (.*)$",
        "^[!/#](pvunblock)$",
        "^[!/#](pvunblock) (.*)$",
    },
      run = run,
pre_process = pre_process
}
end
