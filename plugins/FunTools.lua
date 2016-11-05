do

--------------------------
local function clean_msg(extra, suc, result)
  for i=1, #result do
    delete_msg(result[i].id, ok_cb, false)
  end
  if tonumber(extra.con) == #result then
    send_msg(extra.chatid, ''..#result..' messages were deleted', ok_cb, false)
  else
    send_msg(extra.chatid, 'Error Deleting messages', ok_cb, false)  
end 
end
-----------------------
local function toimage(msg, success, result)
  local receiver = get_receiver(msg)
  if success then
    local file = './data/tophoto/'..msg.from.id..'.jpg'
    print('File downloaded to:', result)
    os.rename(result, file)
    print('File moved to:', file)
    send_photo(get_receiver(msg), file, ok_cb, false)
    redis:del("sticker:photo")
  else
    print('Error downloading: '..msg.id)
    send_large_msg(receiver, 'Failed, please try again!', ok_cb, false)
  end
end
-----------------------
local function tosticker(msg, success, result)
  local receiver = get_receiver(msg)
  if success then
    local file = './data/tosticker/'..msg.from.id..'.webp'
    print('File downloaded to:', result)
    os.rename(result, file)
    print('File moved to:', file)
    send_document(get_receiver(msg), file, ok_cb, false)
    redis:del("photo:sticker")
  else
    print('Error downloading: '..msg.id)
    send_large_msg(receiver, 'Failed, please try again!', ok_cb, false)
  end
end

------------------------
local function get_weather(location)
  print("Finding weather in ", location)
  local BASE_URL = "http://api.openweathermap.org/data/2.5/weather"
  local url = BASE_URL
  url = url..'?q='..location..'&APPID=eedbc05ba060c787ab0614cad1f2e12b'
  url = url..'&units=metric'
  local b, c, h = http.request(url)
  if c ~= 200 then return nil end

   local weather = json:decode(b)
   local city = weather.name
   local country = weather.sys.country
   local temp = 'دمای شهر '..city..' هم اکنون '..weather.main.temp..' درجه سانتی گراد می باشد\n____________________\n @BeyondTeam :)'
   local conditions = 'شرایط فعلی آب و هوا : '

   if weather.weather[1].main == 'Clear' then
     conditions = conditions .. 'آفتابی☀'
   elseif weather.weather[1].main == 'Clouds' then
     conditions = conditions .. 'ابری ☁☁'
   elseif weather.weather[1].main == 'Rain' then
     conditions = conditions .. 'بارانی ☔'
   elseif weather.weather[1].main == 'Thunderstorm' then
     conditions = conditions .. 'طوفانی ☔☔☔☔'
 elseif weather.weather[1].main == 'Mist' then
     conditions = conditions .. 'مه 💨'
  end

  return temp .. '\n' .. conditions
end
--------------------------
local function calc(exp)
   url = 'http://api.mathjs.org/v1/'
  url = url..'?expr='..URL.escape(exp)
   b,c = http.request(url)
   text = nil
  if c == 200 then
    text = 'Result = '..b..'\n____________________\n @BeyondTeam :)'
  elseif c == 400 then
    text = b
  else
    text = 'Unexpected error\n'
      ..'Is api.mathjs.org up?'
  end
  return text
end
------------------------------
local function saveplug(extra, success, result)
  local msg = extra.msg
  local name = extra.name
  local receiver = get_receiver(msg)
  if success then
    local file = 'plugins/'..name..'.lua'
    print('File saving to:', result)
    os.rename(result, file)
    print('File moved to:', file)
  else
    print('Error downloading: '..msg.id)
    send_large_msg(receiver, 'Failed, please try again!', ok_cb, false)
  end
end
------------------------
local function savefile(extra, success, result)
  local msg = extra.msg
  local name = extra.name
  local adress = extra.adress
  local receiver = get_receiver(msg)
  if success then
    local file = './'..adress..'/'..name..''
    print('File saving to:', result)
    os.rename(result, file)
    print('File moved to:', file)
  else
    print('Error downloading: '..msg.id)
    send_large_msg(receiver, 'Failed, please try again!', ok_cb, false)
  end
end
--------------------------
function run(msg, matches) 
	 --------------------------
  if matches[1] == 'clean' and matches[2] == "msg" and is_sudo(msg) then
    if msg.to.type == "user" then 
      return 
      end
    if msg.to.type == 'chat' then
      return  "Only in the Super Group" 
      end
    if not is_owner(msg) then 
      return "You Are Not Allow To clean Msgs!"
      end
    if tonumber(matches[3]) > 100 or tonumber(matches[3]) < 10 then
      return "Minimum clean 10 and maximum clean is 100"
      end
   get_history(msg.to.peer_id, matches[3] + 1 , clean_msg , { chatid = msg.to.peer_id,con = matches[3]})
   end
  --------------------------
      if matches[1] == "save" and matches[2] and is_sudo(msg) then
           local receiver = get_receiver(msg)
    local group = msg.to.id
    if msg.reply_id then
   local name = matches[2]
load_document(msg.reply_id, saveplug, {msg=msg,name=name})
        return 'Plugin '..name..' has been saved.'
    end
end
------------------------
      if matches[1] == "file" and matches[2] and matches[3] and is_sudo(msg) then
          local receiver = get_receiver(msg)
    local group = msg.to.id
    if msg.reply_id then
    local adress = matches[2]
   local name = matches[3]
load_document(msg.reply_id, savefile, {msg=msg,name=name,adress=adress})
        return 'File '..name..' has been saved in: \n./'..adress
      end
      
         if not is_sudo(msg) then
           return "You Are Not Solid :/"
         end
end
---------------------------
if matches[1] == "dl" and matches[2] and matches[3] then
    if is_sudo(msg) then
	    local file = "./"..matches[2].."/"..matches[3]..""
      local receiver = get_receiver(msg)
      send_document(receiver, file, ok_cb, false)
    end
  end
  -------------------------
    if matches[1] == 'addplugin' and is_sudo(msg) then
        if not is_sudo(msg) then
           return "You Are Not Allow To Add Plugin"
           end
   name = matches[2]
   text = matches[3]
   file = io.open("./plugins/"..name, "w")
   file:write(text)
   file:flush()
   file:close()
   return "Add plugin successful "
end
------------------------
   --------------------------
      if matches[1] == "dl" and matches[2] == "plugin" and is_sudo(msg) then
     if not is_sudo(msg) then
    return "You Are Not Allow To Download Plugins!"
  end
   receiver = get_receiver(msg)
      send_document(receiver, "./plugins/"..matches[3]..".lua", ok_cb, false)
      send_document(receiver, "./plugins/"..matches[3], ok_cb, false)
    end
    --------------------------
if matches[1] == "calc" and matches[2] and is_sudo(msg) then 
    if msg.to.type == "user" then 
       return 
       end
    return calc(matches[2])
end
--------------------------
if matches[1] == 'weather' and is_sudo(msg) then
    city = matches[2]
  local wtext = get_weather(city)
  if not wtext then
    wtext = 'مکان وارد شده صحیح نیست'
  end
  return wtext
end
---------------------
if matches[1] == 'time' and is_sudo(msg) then
local url , res = http.request('http://api.gpmod.ir/time/')
if res ~= 200 then
 return "No connection"
  end
  local colors = {'blue','green','yellow','magenta','Orange','DarkOrange','red'}
  local fonts = {'mathbf','mathit','mathfrak','mathrm'}
local jdat = json:decode(url)
local url = 'http://latex.codecogs.com/png.download?'..'\\dpi{600}%20\\huge%20\\'..fonts[math.random(#fonts)]..'{{\\color{'..colors[math.random(#colors)]..'}'..jdat.ENtime..'}}'
local file = download_to_file(url,'time.webp')
send_document(get_receiver(msg) , file, ok_cb, false)

end
--------------------
if matches[1] == 'voice' and is_sudo(msg) then
 local text = matches[2]

  local b = 1

  while b ~= 0 do
    textc = text:trim()
    text,b = text:gsub(' ','.')
    
    
  if msg.to.type == 'user' then 
      return nil
      else
  local url = "http://tts.baidu.com/text2audio?lan=en&ie=UTF-8&text="..textc
  local receiver = get_receiver(msg)
  local file = download_to_file(url,'Self-Bot.mp3')
 send_audio('channel#id'..msg.to.id, file, ok_cb , false)
end
end
end

 --------------------------
   if matches[1] == "tr" and is_sudo(msg) then 
     url = https.request('https://translate.yandex.net/api/v1.5/tr.json/translate?key=trnsl.1.1.20160119T111342Z.fd6bf13b3590838f.6ce9d8cca4672f0ed24f649c1b502789c9f4687a&format=plain&lang='..URL.escape(matches[2])..'&text='..URL.escape(matches[3]))
     data = json:decode(url)
   return 'زبان : '..data.lang..'\nترجمه : '..data.text[1]..'\n____________________\n @BeyondTeam :)'
end
-----------------------
if matches[1] == 'short' and is_sudo(msg) then
 local yon = http.request('http://api.yon.ir/?url='..URL.escape(matches[2]))
  local jdat = json:decode(yon)
  local bitly = https.request('https://api-ssl.bitly.com/v3/shorten?access_token=f2d0b4eabb524aaaf22fbc51ca620ae0fa16753d&longUrl='..URL.escape(matches[2]))
  local data = json:decode(bitly)
  local yeo = http.request('http://yeo.ir/api.php?url='..URL.escape(matches[2])..'=')
  local opizo = http.request('http://api.gpmod.ir/shorten/?url='..URL.escape(matches[2])..'&username=mersad565@gmail.com')
  local u2s = http.request('http://u2s.ir/?api=1&return_text=1&url='..URL.escape(matches[2]))
  local llink = http.request('http://llink.ir/yourls-api.php?signature=a13360d6d8&action=shorturl&url='..URL.escape(matches[2])..'&format=simple')
    return ' 🌐لینک اصلی :\n'..data.data.long_url..'\n\nلینکهای کوتاه شده با 6 سایت کوتاه ساز لینک : \n》کوتاه شده با bitly :\n___________________________\n'..data.data.url..'\n___________________________\n》کوتاه شده با yeo :\n'..yeo..'\n___________________________\n》کوتاه شده با اوپیزو :\n'..opizo..'\n___________________________\n》کوتاه شده با u2s :\n'..u2s..'\n___________________________\n》کوتاه شده با llink : \n'..llink..'\n___________________________\n》لینک کوتاه شده با yon : \nyon.ir/'..jdat.output..'\n____________________\n @BeyondTeam :)'
end
------------------------
 local receiver = get_receiver(msg)
    local group = msg.to.id
    if msg.reply_id then
       if msg.to.type == 'document' and redis:get("sticker:photo") then
        if redis:set("sticker:photo", "waiting") then
        end
       end
    
      if matches[1]:lower() == "photo" and is_sudo(msg) then
     redis:get("sticker:photo")
    send_large_msg(receiver, 'By @BeyondTeam :)', ok_cb, false)
        load_document(msg.reply_id, toimage, msg)
    end
end
------------------------
	    local receiver = get_receiver(msg)
    local group = msg.to.id
    if msg.reply_id then
       if msg.to.type == 'photo' and redis:get("photo:sticker") then
        if redis:set("photo:sticker", "waiting") then
        end
       end
      if matches[1]:lower() == "sticker" and is_sudo(msg) then
     redis:get("photo:sticker")  
    send_large_msg(receiver, 'By @BeyondTeam :)', ok_cb, false)
        load_photo(msg.reply_id, tosticker, msg)
    end
end
------------------------
if matches[1] == "delplugin" and is_sudo(msg) then
	      if not is_sudo(msg) then 
             return "You Are Not Allow To Delete Plugins!"
             end 
        io.popen("cd plugins && rm "..matches[2]..".lua")
        return "Delete plugin successful "
     end
     ---------------
     if matches[1] == "sticker" and is_sudo(msg) then 
local eq = URL.escape(matches[2])
local w = "500"
local h = "500"
local txtsize = "150"
local txtclr = "ff2e4357"
if matches[3] then 
  txtclr = matches[3]
end
if matches[4] then 
  txtsize = matches[4]
  end
  if matches[5] and matches[6] then 
  w = matches[5]
  h = matches[6]
  end
  local url = "https://assets.imgix.net/examples/clouds.jpg?blur=150&w="..w.."&h="..h.."&fit=crop&txt="..eq.."&txtsize="..txtsize.."&txtclr="..txtclr.."&txtalign=middle,center&txtfont=Futura%20Condensed%20Medium&mono=ff6598cc"

  local receiver = get_receiver(msg)
local  file = download_to_file(url,'text.webp')
 send_document('channel#id'..msg.to.id, file, ok_cb , false)
end
 -------------------
   if matches[1] == "version"  then --change this with anything you want
        local text = "Beyond Self Bot V2.7\nAn Fun Bot Based On TeleSeed Written In Lua\n\nSudo User :\nDeveloper&Founder : @SoLiD021\nDeVeloper&Manager : @CliApi\n\nTeam Channel :\n@BeyondTeam\n\nSpecial Thx To :\nSeed Team\nAnd All My Friends :D\n\nBeyond Self Bot Version 2.7 On GitHub :\nGithub.com/BeyondTeam/Self-Bot"
return reply_msg(msg.id, text, ok_cb, false)
  end
---------------
if matches[1]:lower() == "markread" and is_sudo(msg) then
     if matches[2] == "on" then
      redis:set("bot:markread", "on")
      return "Mark read is on now"
     elseif matches[2] == "off" then
      redis:del("bot:markread")
      return "Mark read is off now"
     end
  end
     if matches[1] == "photo" and is_sudo(msg) then 
local eq = URL.escape(matches[2])
local w = "500"
local h = "500"
local txtsize = "150"
local txtclr = "ff2e4357"
if matches[3] then 
  txtclr = matches[3]
end
if matches[4] then 
  txtsize = matches[4]
  end
  if matches[5] and matches[6] then 
  w = matches[5]
  h = matches[6]
  end
  local url = "https://assets.imgix.net/examples/clouds.jpg?blur=150&w="..w.."&h="..h.."&fit=crop&txt="..eq.."&txtsize="..txtsize.."&txtclr="..txtclr.."&txtalign=middle,center&txtfont=Futura%20Condensed%20Medium&mono=ff6598cc"

  local receiver = get_receiver(msg)
local  file = download_to_file(url,'text.jpg')
 send_photo('channel#id'..msg.to.id, file, ok_cb , false)
end
end
end
return {               
patterns = {
   "^[!/]([Aa]ddplugin) (.+) (.*)$",
    "^[!/]([Dd]l) ([Pp]lugin) (.*)$",
   "^[!/]([Cc]lean) (msg) (%d*)$",
   "^[!/]([Dd]elplugin) (.*)$",
   "^[!/#](weather) (.*)$",
   "^[!/](calc) (.*)$",
   "^[#!/](time)$",
   "^[!/#](voice) +(.*)$",
    "^[!/#](save) (.*)$",
    "^[!/#]([Ff]ile) (.*) (.*)$",
    "^[!#/](dl) (.*) (.*)$",
   "^[!/]([Tt]r) ([^%s]+) (.*)$",
   "^[!/]([Mm]ean) (.*)$",
   "^[!/]([Ss]hort) (.*)$",
   "^[#!/]([Ss]ticker)$",
   "^[#!/](photo)$",
     "^[!/](photo) (.+)$",
    "^[!/](sticker) (.+)$",
    "^[!/#]([Vv]ersion)$",
    "^([Vv]ersion)$",
      "^[!/]([Mm]arkread) (.*)$",
    "^([Gg]it)$",
    "^[!/#]([Gg]it)$",
   "%[(document)%]",
   "%[(photo)%]",
 }, 
run = run,
}

--by @BeyondTeam :)
--By @CliApi
