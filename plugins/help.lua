do
    
function run(msg, matches)
  local help = [[Beyond Self Commands

🔴دستورات مدیریتی ربات👇

🔴!bot on
🔹فعال کردن بوت در یک گروه خاص

🔴!bot off
🔹غیر فعال کردن بوت در یک گروه خاص

🔴!plist
🔹مشاهده لیست پلاگین ها

🔴!pl + (plugin name)
🔹فعال کردن پلاگینی با نام (plugin name)

🔴!pl - (plugin name)
🔹غیر فعال کردن پلاگینی با نام (plugin name)

🔴!reload
🔹آپدیت کردن لیست پلاگین ها

🔴!pl - (name) chat
🔹غیر فعال کردن پلاگین (name) در گروه مورد نظر

🔴!pl + (name) chat
🔹فعال کردن پلاگین (name) در گروه مورد نظر

🔴!save (name) (by reply)
🔹اضافه کردن پلاگین به لیست پلاگین ها با رپلی روی فایل پلاگین مورد نظر

🔴!send (name)
🔹ارسال پلاگین با نام

🔴!file (folder) (name.lua) 👉 (by reply)
🔹اضافه کردن فایل یا پلاگین به پوشه
مورد نظر با ریپلی
❗بستگی به نوع فایل داره میتونه فرمت تغییر کنه مثلا photo.jpg❗

🔴!dl (folder) (name.lua)
🔹دانلود فایل مورد نظر از پوشه خاص
❗بستگی به نوع فایل داره میتونه فرمت تغییر کنه مثلا sticker.webp❗

🔴دستورات مدیریتی گروه👇

🔴!setname (name)
🔹تغیر نام گروه به (name)

🔴!link 
🔹دریافت لینک گروه در پیوی

🔴!newlink
🔹ساخت لینک جدید

🔴!setlink [link]
🔹ثبت لینک گروه مورد نظر

🔴!tosuper
🔹تبدیل گروه معمولی به سوپر گوه

🔴!setdes (text)
🔹تغیر دسکریپشن گروه به (text)

🔴!kick @username (by reply)
🔹اخراج فردی با آیدی @username (حتی با ریپلای)

🔴!inv @username (by reply)
🔹ادد کردن فردی با آیدی @username به گروه (حتی با ریپلای)

🔴!id @username (by reply)
🔹دریافت آیدی عددی فردی با آیدی @username (حتی با ریپلای)

🔴!gpid
🔹دریافت آیدی گروه

🔴فقط در سوپر گروه 👇

🔴!silent [id|reply]
🔹بیصدا کردن فرد مورد نظر در سوپر گروه با (آیدی و ریپلی)

🔴!unsilent [id|reply]
🔹درآوردن فرد مورد نظر از حالت بیصدا در سوپر گروه با (آیدی و ریپلی)

🔴!silent all
🔹بیصدا کردن همه در سوپر گروه

🔴!unsilent all
🔹دراوردن سوپر گروه از حالت بیصدا

🔴!silent status
🔹مشاهده وضعیت بیصدا در سوپر گروه

🔴دستورات سرگرمی👇

🔴!sticker (by reply)
🔹تبدیل عکس به استیکر با ریپلی
🔴!photo (by reply)
🔹تبدیل استیکر به عکس با ریپلی

➖➖➖➖➖➖
Team Channel : 😎@BeyondTeam 😎
➖➖➖➖➖➖]]
    if matches[1] == 'help' and is_sudo(msg) then
      send_large_msg("user#id"..msg.from.id, help)      
   return 'Help was sent in your private message'
    end
end 

return {
  patterns = {
    "^[!/#](help)$"
  },
  run = run
}
end
