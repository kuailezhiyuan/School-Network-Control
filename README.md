#School Network Control
在学校电脑控制联网的程序，配合goodsync使用将桌面文件同步到网盘。

当goodsync同步时联网，同步结束断网。配合密码手动开启网络。

请使用windows计划任务开机启动（设置管理员权限）。

KDaemon为守护程序，防止主程序被杀。
Guardian为主程序。
参数-goodsync为开启goodsync（开机调用
-KDaemon为守护程序被关闭时自动断网
net为手动开启网络程序。
net_auto为goodsync调用开启和关闭网络使用（添加参数-opennet运行为开启，无参数运行为关闭）

所有程序会自动检测主程序和守护程序是否自动运行，未运行断网且互相启动。所有程序需要放在同一目录下，需要管理员权限。

断网原理为更改IP和DNS，方便解决啥都不懂的小中高学生。