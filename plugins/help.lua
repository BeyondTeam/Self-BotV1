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

🔴!dl plugin name
🔹دریافت پلاگین از سرور به صورت فایل
🔴!pvblock [username|id|reply]
🔹بلاک کردن فرد مورد نظر با (یوزرنیم و آیدی و ریپلی)
🔴!pvunblock [username|id|reply]
🔹درآوردن فرد مورد نظر از بلاک با (یوزریم و آیدی و ریپلی)

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

🔴!silent [username|id|reply]
🔹بیصدا کردن فرد مورد نظر در سوپر گروه با (یوزرنیم و آیدی و ریپلی)

🔴!unsilent [username|id|reply]
🔹درآوردن فرد مورد نظر از حالت بیصدا در سوپر گروه با (یوزریم و آیدی و ریپلی)

🔴!silentlist
🔹نمایش افراد سایلنت شده

🔴!clean silentlist
🔹پاک کردن لیست افراده سایلنت شده

🔴!mute all
🔹بیصدا کردن همه در سوپر گروه

🔴!unmute all
🔹دراوردن سوپر گروه از حالت بیصدا

🔴!mute status
🔹مشاهده وضعیت بیصدا در سوپر گروه

🔴دستورات سرگرمی👇

🔴!sticker (by reply)
🔹تبدیل عکس به استیکر با ریپلی
🔴!photo (by reply)
🔹تبدیل استیکر به عکس با ریپلی

🔴!tr fa-en word
🔹ترجمه کلمات از فارسی به انگلیسی یا بالعکس

🔴!sticker name/word/emoji
🔹تبدیل کلمات /اسم ها و اموجی های خود به استیکر

🔴!photo name/word/emoji
🔹تبدیل کلمات /اسم ها و اموجی های خود به عکس

🔴!calc number +-*÷
🔹ماشین حساب با چهار عمل اصلی ضرب/جمع/تفریق/تقسیم

🔴!delplugin nameplugin
🔹حذف افزونه بدون رفتن به سرور از طریق تلگرام بدون پسوند.lua
مثال: !delplugin BeyondTeam

🔴!weather city
🔹دریافت وضعیت آب و هوای شهر مورد نظر

🔴!time
🔹مشاهده زمان فعلی بصورت استیکر

🔴!voice text
🔹تبدیل متن به صدا

🔴!clean msg number
🔹حذف پیام های اخیر سوپرگروه
مثال : !clean msg 100

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
