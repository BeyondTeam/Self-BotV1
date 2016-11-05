--[[
################################
#                              #
#                     Solid Plugin           #
#                              #
#                              #
#   by @SoLiD021 ⇨Saeid⇦    #
#                              #
#                              #
#   Team Channel @BeyondTeam   #
#	                           #
#                              #
#     Update: 6 October 2016    #
#                              #
#                              #
#    Special Thx To  @Pokr_face for idea    #
#                              #
################################
]]
do
local function self_names( name )
  for k,v in pairs(_self.names) do
    if name == v then
      return k
    end
  end
  -- If not found
  return false
end

local function self_answers( answer )
  for k,v in pairs(_self.answers) do
    if answer == v then
      return k
    end
  end
  -- If not found
  return false
end

local function reload_plugins( ) 
  plugins = {} 
  load_plugins() 
end

local function namelist(msg)
local namelist = _self.names
local text = "Names list :\n"
for i=1,#namelist do
    text = text..i.." - "..namelist[i].."\n"
end
return text
end

local function answerlist(msg)
local answerlist = _self.answers
local text = "Answers list :\n"
for i=1,#answerlist do
    text = text..i.." - "..answerlist[i].."\n"
end
return text
end

local function set_name( name )
  -- Check if name founded
  if self_names(name) then
    return 'Name '..name..' founded'
  end
    -- Add to the self table
    table.insert(_self.names, name)
    save_self()
    reload_plugins( )
    -- Reload the plugins
    return 'New name '..name..' added to name list'
end

local function set_answer( answer )
  -- Check if name founded
  if self_answers(answer) then
    return 'Word '..answer..' founded'
  end
    -- Add to the self table
    table.insert(_self.answers, answer)
    save_self()
    reload_plugins( )
    -- Reload the plugins
    return 'New word '..answer..' added to answer list'
end

local function rem_name( name )
  local k = self_names(name)
  -- Check if name not founded
  if not k then
    return 'Name '..name..' not founded'
  end
  -- remove and reload
  table.remove(_self.names, k)
  save_self( )
  reload_plugins(true)
  return 'Name '..name..' removed from name list'
end

local function rem_answer( answer )
  local k = self_answers(answer)
  -- Check if answer not founded
  if not k then
    return 'word '..answer..' not founded'
  end
  -- remove and reload
  table.remove(_self.answers, k)
  save_self( )
  reload_plugins(true)
  return 'Word '..answer..' removed from answer list'
end

function run(msg, matches)
local reply_id = msg['id']
local answer = _self.answers
local text = answer[math.random(#answer)]

			if matches[1]:lower() == "addname" and is_sudo(msg) then
      local name = matches[2]
      return set_name(name)
      elseif matches[1]:lower() == "remname" and is_sudo(msg) then
      local name = matches[2]
      return rem_name(name)
			elseif matches[1]:lower() == "setanswer" and is_sudo(msg) then
      local answer = matches[2]
      return set_answer(answer)
      elseif matches[1]:lower() == "remanswer" and is_sudo(msg) then
      local answer = matches[2]
      return rem_answer(answer)
         elseif matches[1]:lower() == 'namelist' and is_sudo(msg) then
return reply_msg(msg.id, namelist(msg),ok_cb,false)
         elseif matches[1]:lower() == 'answerlist' and is_sudo(msg) then
return reply_msg(msg.id, answerlist(msg),ok_cb,false)
    end
if self_names(matches[1]) then
    if not is_sudo(msg) then
reply_msg(reply_id, text, ok_cb, false)
end
end 
end
return {
patterns = {
"^[!/]([Aa]ddname) (.*)$",
"^[!/]([Rr]emname) (.*)$",
"^[!/]([Nn]amelist)$",
"^[!/]([Ss]etanswer) (.*)$",
"^[!/]([Rr]emanswer) (.*)$",
"^[!/]([Aa]nswerlist)$",
"^(.*)$"
},
run = run
}

end
--End solid.lua By @SoLiD021
