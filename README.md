**正如其名，免费不限量备份数据，不限于网站数据，图片、数据库文件等任何资源。**

## 如何工作

现在很多的大型网站有提供上传图片功能，并且允许上传的图片体积还不小，那么就可以将此利用起来**将文件包装为图片进行上传**。例如以往很多人在图片里藏毒，藏密码，这里只是藏了一个文件而已。

对于大的文件只需要进行分片存储上传就行了，恢复时按顺序合成就能得到完整有效的文件。

**所以本质是白嫖了大厂的云存储，且下载时能够得到满速下载。**

## 如何去做

如示例中的 bash 脚本一样，我提供了两个文件。

- backup.sh 免费备份脚本
- web_backup.sh 备份网站示例脚本

前者是主要备份脚本工作的内容流程，后者是如何将其利用起来定期备份你的网站数据，里面都有参考。

简单示例：

**备份网站**

你将得到 `web.tar.gz.fbi`文件元信息文件(或种子文件)，用来恢复数据。

```
./backup.sh upload /tmp/web.tar.gz
```

**恢复数据**

```
./backup.sh download web.tar.gz.fbi
```

## 数据安全

脚本中并没有对数据进行加密，你所上传的文件虽然是被打碎了，但依然可以被对方网站人员拿到进行合并，且URL一般具有公开匿名访问特征，任何人都可以访问到。

**所以它更大的意义是用于备份，为了保证数据安全，建议你采用 zip 将文件进行打包加密，或 openssl 进行加密，再去备份。**（web_backup.sh 有演示）

密码使用建议为双字节字符，如`お早う2022everyday!`、`圣诞快乐2o21🎄~`等

**能够存储多久?**

这个是一个不确定性问题，有可能很长，有可能很短，取决于厂商风控，以及不被访问的图片会不会被定期归档删除等。

**建议用来做每日计划任务备份，过于久远的不要考虑，可以用来缓解近期的数据丢失等问题。**



## 价值意义

在此之前我也已经用过此类方式一年多了，不过都是极小量的数据备份和朋友间的文件分享等，即没有滥用所以能够稳定的使用。

分享这个脚本出来一定会被滥用，且遭到对方厂商风控封禁等，或很快无法使用，但思路是一样简单的，有需要的可以根据此思路写出更多程序来掩盖特征，来对抗文件特征检查等风控行为。

在此之前看到很多人拿 TG 当网盘备份数据，确实也更方便，不限容量，文件永久保存，接口都是公开透明的，等等一系列的优点。但 TG 只有一个，无论它是不是付费的，但它保留有你免费的权益，起码它是在用心做软件的，**我更希望你们将白嫖的行为移动到这群只为利益的无良大厂上**。



**若脚本内的接口不能用了，可自行替换更多其他厂商的接口，也建议直接拿到后改掉接口不要用默认的上传接口，也不要在我的帖子中回复任何厂商名字、关键字。**



思路扩展，不要这么局限性了~

- 其实你仔细观察就会发现，很多厂商是没有设置 CORS 限制的，也就意味着你可以将视频文件进行上传，并通过 JS 分片拉取，再转换成视频流渲染在网页里。

- 还有就是你与你朋友分享文件时，用网盘过于麻烦还限速，为什么不用这种东西进行分享呢？

自己发现更多的乐趣吧~





