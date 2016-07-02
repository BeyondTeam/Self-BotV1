do

local function run(msg, matches)
  if matches[1] == "dl" and matches[2] and matches[3] then
    if is_sudo(msg) then
	    local file = "./"..matches[2].."/"..matches[3]..""
      local receiver = get_receiver(msg)
      send_document(receiver, file, ok_cb, false)
    end
  end
end

return {
  patterns = {
  "^[!#/](dl) (.*) (.*)$"
  },
  run = run
}
end
