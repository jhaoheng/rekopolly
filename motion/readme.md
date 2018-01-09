# info
- https://github.com/Motion-Project/motion
- guide : http://htmlpreview.github.io/?https://github.com/Motion-Project/motion/blob/master/motion_guide.html
- install in raspberry : `apt-get install motion -y`
    - `http://www.instructables.com/id/Raspberry-Pi-Motion-Detection-Security-Camera/#step4`
- `motion.conf` : Override the default motino.conf in `/etc/motion/motion.conf`
    - start : `motion -c motion.conf`
    - check `target_dir` : './raspi-security-ipcam/dev/tmp'
    - use 'http://localhost:8081', could see the live.

# why motion
這篇作者有說
1. PiCAM 的應用程序，只能夠給 PiCAM 使用，與其他廉價的多功能網路攝影機比，相對昂貴 
    - 為了讓更多的用戶接觸，所以在範例中，挑選一個普通的 usb 相機
2. 關於為何不使用 opencv，而使用 motion
    - 佔用大量的內存
    - 設定麻煩

