do

function run(msg, matches)
local reply_id = msg['id']
local text = 'بلی؟'
--در اینجا میتونین جواب رو تعیین کنید
if matches[1] == 'سلید' or 'solid' or 'سعید' or 'saeid' or 'saeed' then
    if not is_sudo(msg) then
--در این قسمت میتونید اسم خودتون رو بزارید
--یادتون باشه وقتی اسم خودتون رو گذاشتید پترن هارو هم تغییر بدید
reply_msg(reply_id, text, ok_cb, false)
end
end 
end
return {
patterns = {
    "^سلید$",
    "^سعید$",
"^([Ss]aeid)$",
"^([Ss]aeed)$",
"^([Ss]olid)$"
},
run = run
}

end
