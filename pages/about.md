---
layout: page
title: About
description: キボウの道をジグザグ進もう
keywords: yescafe, Yestercafe, Ivan Chien, self
comments: true
menu: 关于
permalink: /about/
---
## 关于我

**姓名:**  
&nbsp;&nbsp;不公开  
**英文名:**   
&nbsp;&nbsp;Ivan Chien  
**常用昵称:**   
&nbsp;&nbsp;qyc027, Yescafe, Yestercafe  
**性别:**   
&nbsp;&nbsp;男    
**生日:**   
&nbsp;&nbsp;2000.12.8  
**职业:**   
&nbsp;&nbsp;某四非大学学生  
**QQ:**  
&nbsp;&nbsp;2559535938  
**电子邮箱:**  
&nbsp;&nbsp;[qyc027@gmail.com](mailto:qyc027@gmail.com)  
&nbsp;&nbsp;[qyc027@outlook.com](mailto:qyc027@outlook.com)  
&nbsp;&nbsp;[2559535938@qq.com](mailto:2559535938)  
**坐标:**  
&nbsp;&nbsp;安徽合肥 (Heifei, Anhui, PRC)  

某**四非大学**二本计算机科学与技术(加了一些奇怪的后缀)专业的18级大学**狗**. ACM校队划水**狗**一枚, 休伯立安号舰长, 罗德岛博士, 音游苦手.  
**没有**特长, 特短特别**多**, 在此不做一一列举了.  

## 爱好  

- 吹逼
- 和别人一起吹逼
- 打代码
- 看番  
- [邦多利 (ガルパ, Bandori! Girls Band Party)](https://bang-dream.com/)  
- [听歌](https://music.163.com/#/playlist?id=308954103)  
- 羽毛球 (这个我自己都不信的)  
- 自言自语 ([Hitorigoto](https://music.163.com/#/song?id=474567613))  
- 唱歌 (雾)   
- [花钱](https://www.taobao.com/)
- [搓麻将 (误)](https://majsoul.union-game.com)

## 联系

{% for website in site.data.social %}
* {{ website.sitename }}：[@{{ website.name }}]({{ website.url }})
{% endfor %}

## Skill Keywords

{% for category in site.data.skills %}
### {{ category.name }}
<div class="btn-inline">
{% for keyword in category.keywords %}
<button class="btn btn-outline" type="button">{{ keyword }}</button>
{% endfor %}
</div>
{% endfor %}
