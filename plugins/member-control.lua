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
     if matches[1] == 'antiflood' and is_sudo(msg) then
local hash = 'anti-flood'
--Enable Anti-flood
     if matches[2] == 'on' then
    redis:del(hash)
   return reply_msg(msg.id, 'Private flood protection has been enabled', ok_cb, false)
--Disable Anti-flood
     elseif matches[2] == 'off' then
    redis:set(hash, true)
   return reply_msg(msg.id, 'Private flood protection has been disabled', ok_cb, false)
-- Anti-flood Status
      elseif matches[2] == 'status' then
      if not redis:get(hash) then
   return reply_msg(msg.id, 'Anti flood is enable', ok_cb, false)
       else
   return reply_msg(msg.id, 'Anti flood is disable', ok_cb, false)
                   end
             end
       end
                if matches[1] == 'pvfloodtime' then
                    if not matches[2] then
                    else
                        hash = 'flood_time'
                        redis:set(hash, matches[2])
            return reply_msg(msg.id, 'Private flood time check has been set to : '..matches[2]..'', ok_cb, false)
                    end
                elseif matches[1] == 'pvsetflood' then
                    if not matches[2] then
                    else
                        hash = 'flood_max'
                        redis:set(hash, matches[2])
            return reply_msg(msg.id, 'Private flood has been set to : '..matches[2]..'', ok_cb, false)
                    end
                 end

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

    local hash = 'flood_max'
    if not redis:get(hash) then
        MSG_NUM_MAX = 5
    else
        MSG_NUM_MAX = tonumber(redis:get(hash))
    end

    local hash = 'flood_time'
    if not redis:get(hash) then
        TIME_CHECK = 3
    else
        TIME_CHECK = tonumber(redis:get(hash))
    end
    if msg.to.type == 'user' then
        --Checking flood
        local hashse = 'anti-flood'
        if not redis:get(hashse) then
            print('anti-flood enabled')
            -- Check flood
            if msg.from.type == 'user' then
                if not is_sudo(msg) then
                    -- Increase the number of messages from the user on the chat
                    local hash = 'flood:'..user_id..':msg-number'
                    local msgs = tonumber(redis:get(hash) or 0)
                    if msgs > MSG_NUM_MAX then
if redis:get('user:'..user_id..':flooder') then
return
else
    reply_msg(msg.id, "You are blocked because of flooding!", ok_cb, true)
block_user("user#id"..user_id,ok_cb,false)
send_large_msg("user#id"..our_id,'User [ '..('@'..msg.from.username or msg.from.first_name)..' ] '..msg.from.id..' has been blocked because of flooding!')
redis:setex('user:'..user_id..':flooder', 30, true)
                       end
                    end
                    redis:setex(hash, TIME_CHECK, msgs+1)
                end
            end
        end
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
        "^[!/#](antiflood) (.*)$",
        "^[!/#](pvfloodtime) (%d+)$",
        "^[!/#](pvsetflood) (%d+)$",
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
--end member-control by @SoLiD021
