# Beyond Self Bot Version 1.0

**An Fun bot based on [TeleSeed](https://github.com/SEEDTEAM/TeleSeed) licensed under the [GNU General Public License](https://github.com/BeyondTeam/Self-Bot/blob/master/LICENSE)**.


# نحوه نصب کردن بر روی سرور

# به ترتیب بزنید
```
sudo apt-get install libreadline-dev libconfig-dev libssl-dev lua5.2 liblua5.2-dev lua-socket lua-sec lua-expat libevent-dev make unzip git redis-server autoconf g++ libjansson-dev libpython-dev expat libexpat1-dev
cd $HOME
git clone https://github.com/BeyondTeam/Self-Bot.git -b supergroups
cd Self-Bot
chmod +x launch.sh
./launch.sh install
./launch.sh # بعد از زدن این دستور از شما شماره و کد تایید میخواد
```
بعد از لانچ بات را خاموش کنید و به پوشه دیتا رفته و فایل کانفیگ رو باز کنید در این فایل باید خودتونو سودو کنید
```
  sudo_users = {
    157059515,
    YourID
  }
```
بعد از ان دوباره ربات خود رو لانچ کنید.

برای ران کردن ربات با اتو لانچ از دستورات زیر استفاده کنید.
```
killall screen
killall tmux
killall telegram-cli
tmux new-session -s script "bash beyond.sh -t"
```
# Sudo User

#Developer&Founder : 
#[SoLiD021](https://telegram.me/SoLiD021)

* * *

# Special Thx To :
Seed Team
And All My Friends :D

### Team Channel :

[@BeyondTeam](https://telegram.me/BeyondTeam)

موفق باشید -_-
