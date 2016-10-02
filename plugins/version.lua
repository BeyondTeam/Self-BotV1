do

local function run(msg, matches)
      local text = "Beyond Self Bot V2.5\nAn Fun Bot Based On TeleSeed Written In Lua\n\nSudo User :\nDeveloper&Founder : @SoLiD021\nDeVeloper&Manager : @CliApi\n\nTeam Channel :\n@BeyondTeam\n\nSpecial Thx To :\nSeed Team\nAnd All My Friends :D\n\nBeyond Self Bot Version 2.5 On GitHub :\nGithub.com/BeyondTeam/Self-Bot"
  if matches[1]:lower() == 'beyondself' or 'version' or 'ver' or 'git' then --change this with anything you want
reply_msg(msg.id, text, ok_cb, false)
  end
end

return {
  patterns = {
    "^[!/#]([Bb]eyondself)$",
    "^([Bb]eyondself)$",
    "^[!/#]([Vv]ersion)$",
    "^([Vv]ersion)$",
    "^([Gg]it)$",
    "^[!/#]([Gg]it)$",
    "^([Vv]er)$",
    "^[!/#]([Vv]er)$"
    },
  run = run
}
end
