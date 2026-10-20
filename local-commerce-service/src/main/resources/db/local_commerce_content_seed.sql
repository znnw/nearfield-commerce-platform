SET NAMES utf8mb4;

START TRANSACTION;

INSERT INTO tb_user (id, phone, password, nick_name, icon) VALUES
(2001, '13758012001', '', '林知夏', '/imgs/icons/avatar-lin.svg'),
(2002, '13758012002', '', '周野', '/imgs/icons/avatar-zhou.svg'),
(2003, '13758012003', '', '顾南舟', '/imgs/icons/avatar-gu.svg'),
(2004, '13758012004', '', '夏栀', '/imgs/icons/avatar-xia.svg'),
(2005, '13758012005', '', '乔一', '/imgs/icons/avatar-qiao.svg'),
(2006, '13758012006', '', '陈屿', '/imgs/icons/avatar-chen.svg'),
(2007, '13758012007', '', '苏禾', '/imgs/icons/avatar-su.svg'),
(2008, '13758012008', '', '唐小满', '/imgs/icons/avatar-tang.svg'),
(2009, '13758012009', '', '莫青', '/imgs/icons/avatar-mo.svg'),
(2010, '13758012010', '', '江雾', '/imgs/icons/avatar-jiang.svg')
ON DUPLICATE KEY UPDATE
phone = VALUES(phone),
nick_name = VALUES(nick_name),
icon = VALUES(icon);

INSERT INTO tb_user_info
(user_id, city, introduce, fans, followee, gender, birthday, credits, level) VALUES
(2001, '杭州', '在运河边寻找不赶时间的小店', 128, 76, 2, '1996-04-18', 1680, 5),
(2002, '杭州', '咖啡、骑行和城市散步', 96, 112, 1, '1994-09-07', 1420, 4),
(2003, '杭州', '只记录值得再去的餐厅', 215, 58, 1, '1992-12-03', 2360, 6),
(2004, '杭州', '甜品和日落都要慢慢吃', 173, 91, 2, '1997-06-21', 1890, 5),
(2005, '杭州', '周末探店半径五公里', 84, 67, 2, '1998-02-14', 980, 3),
(2006, '杭州', '老城区的面和酒', 142, 45, 1, '1991-11-26', 2070, 6),
(2007, '杭州', '带娃吃饭也要有审美', 66, 38, 2, '1990-08-09', 760, 3),
(2008, '杭州', '运动之后认真补一顿', 119, 87, 1, '1995-03-30', 1350, 4),
(2009, '杭州', '深夜食堂观察员', 201, 103, 1, '1993-07-12', 2210, 6),
(2010, '杭州', '住在拱墅，吃在街巷', 58, 41, 2, '1999-01-16', 640, 2)
ON DUPLICATE KEY UPDATE
city = VALUES(city),
introduce = VALUES(introduce),
fans = VALUES(fans),
followee = VALUES(followee),
gender = VALUES(gender),
birthday = VALUES(birthday),
credits = VALUES(credits),
level = VALUES(level);

UPDATE tb_user
SET nick_name = '风吹半夏',
    icon = '/imgs/icons/avatar-jiang.svg'
WHERE id = 1029;

INSERT INTO tb_user_info
(user_id, city, introduce, fans, followee, gender, birthday, credits, level) VALUES
(1029, '杭州', '把城市里好看的角落装进相册', 232, 88, 2, '1997-10-21', 1940, 5)
ON DUPLICATE KEY UPDATE
city = VALUES(city),
introduce = VALUES(introduce),
fans = VALUES(fans),
followee = VALUES(followee),
gender = VALUES(gender),
birthday = VALUES(birthday),
credits = VALUES(credits),
level = VALUES(level);

UPDATE tb_user
SET nick_name = CONCAT(
        ELT(MOD(id, 20) + 1,
            '阿梨', '小满', '临江', '木木', '三七', '北北', '一禾', '山茶', '知秋', '阿洛',
            '南乔', '半糖', '清和', '有余', '岛屿', '小鹿', '迟迟', '云栖', '拾光', '十一月'),
        '的',
        ELT(MOD(id, 12) + 1,
            '周末', '饭搭子', '散步册', '小馆', '咖啡杯', '巷口',
            '探店记', '晚风', '食光', '街区', '日常', '地图')
    ),
    icon = CONCAT('/imgs/icons/avatar-',
        ELT(MOD(id, 10) + 1,
            'lin', 'zhou', 'gu', 'xia', 'qiao',
            'chen', 'su', 'tang', 'mo', 'jiang'),
        '.svg')
WHERE icon = ''
  AND LEFT(nick_name, 5) = 'user_'
  AND id <> 1029;

UPDATE tb_user
SET nick_name = '西溪慢行',
    icon = '/imgs/icons/avatar-xia.svg'
WHERE icon = '';

UPDATE tb_blog
SET user_id = 2003,
    shop_id = 10,
    title = '周末在运河上街唱到打烊，这家KTV比想象中干净',
    images = '/imgs/blogs/11/12/8b37d208-9414-4e78-b065-9199647bb3e3.jpg',
    content = '<p>下午场人不多，包间没有明显烟味，麦克风和点歌屏都很灵敏。</p><p>曲库更新得比预期快，唱累了还可以出来买饮料。适合朋友临时约一场，不用把周末排得太满。</p>',
    liked = 12,
    comments = 3,
    create_time = '2026-10-05 20:15:00',
    update_time = NOW()
WHERE id = 7;

UPDATE tb_blog
SET user_id = 2004,
    shop_id = 4,
    title = '乐堤港的晚风配一杯气泡水，周末就该这样慢下来',
    images = '/imgs/blogs/14/3/52b290eb-8b5d-403b-8373-ba0bb856d18e.jpg',
    content = '<p>吃完晚饭沿着河边走，最后又回到乐堤港坐了一会儿。</p><p>点了一杯不甜的气泡水，看楼下的人来来往往。没有安排下一站的周末，反而最舒服。</p>',
    liked = 9,
    comments = 1,
    create_time = '2026-10-06 19:42:00',
    update_time = NOW()
WHERE id = 24;

UPDATE tb_blog
SET user_id = 2006,
    shop_id = 8,
    title = '第二次来浅草屋，这次点了招牌鳗鱼饭',
    images = '/imgs/blogs/13/12/f822a9cf-f0dd-405f-81ba-ff93bd07ccf8.jpg',
    content = '<p>第一次来只点了寿司，这次专门试了鳗鱼饭。酱汁不会盖住鱼肉的香味，米饭也粒粒分明。</p><p>工作日晚餐不用排队，窗边位置安静。下次想再试试他们家的天妇罗。</p>',
    liked = 7,
    comments = 2,
    create_time = '2026-10-07 18:36:00',
    update_time = NOW()
WHERE id = 25;

REPLACE INTO tb_blog
(id, shop_id, user_id, title, images, content, liked, comments, create_time, update_time) VALUES
(26, 8, 2001, '运河边这家寿司店，工作日晚餐刚刚好',
 '/imgs/blogs/0/0/feb2a83e-5646-46c0-a982-5e43fed31b22.jpg,/imgs/blogs/3/14/a6b9ec21-6708-4d6d-8f77-ed31c856e5b2.jpg,/imgs/blogs/2/3/39d65be4-af94-458d-b6de-bc8ca20735bb.jpg',
 '<p>工作日晚餐不想吃得太隆重，逛到运河上街就进了这家寿司店。</p><p>鳗鱼饭的酱汁不齁，茶碗蒸很细，坐在窗边能看到运河的灯。人均八十左右，适合下班后慢慢吃完再走一圈。</p>',
 47, 8, '2026-10-18 18:20:00', NOW()),
(27, 4, 2002, '骑行到乐堤港，为一杯冰咖啡停一下',
 '/imgs/blogs/13/1/6b091b4c-7870-4df8-9b21-5db9852db005.jpg,/imgs/blogs/15/9/cea51d9b-ac15-49f6-b9f1-9cf81e9b9c85.jpg',
 '<p>从大关一路骑到乐堤港，风不大，正好停下来喝杯冰咖啡。</p><p>店里的音乐不吵，靠窗位置能看到河面。咖啡偏坚果调，配一块柠檬磅蛋糕，休息二十分钟再继续骑。</p>',
 42, 6, '2026-10-18 15:10:00', NOW()),
(28, 3, 2003, '不赶时间的杭帮菜，三个人点了七道菜',
 '/imgs/blogs/4/1/fa74a6d6-3026-4cb7-b0b6-35abb1e52d11.jpg,/imgs/blogs/4/7/863cc302-d150-420d-a596-b16e9232a1a6.jpg',
 '<p>三个人点了七道菜，没有踩雷。东坡肉酥但不散，龙井虾仁清清爽爽，时蔬也很新鲜。</p><p>上菜节奏舒服，服务员会提醒分量。人均六十出头，适合带家里人吃一顿不赶时间的饭。</p>',
 38, 5, '2026-10-17 20:05:00', NOW()),
(29, 7, 2004, '烤鱼也能吃得很清爽，微辣刚刚好',
 '/imgs/blogs/10/7/7e97f47d-eb49-4dc9-a583-95faa7aed287.jpg,/imgs/blogs/1/2/4a7b496b-2a08-4af7-aa95-df2c3bd0ef97.jpg',
 '<p>本来担心烤鱼太重口，选了微辣之后反而很舒服。鱼皮烤得脆，配菜吸满汤汁。</p><p>推荐加藕片和豆皮，最后再下一份手工面。两个人点小份就够了，冬天吃完整个人都暖起来。</p>',
 35, 4, '2026-10-17 12:40:00', NOW()),
(30, 2, 2005, '铜锅涮肉的正确打开方式，是慢慢涮',
 '/imgs/blogs/2/6/b0756279-65da-4f2d-b62a-33f74b06454a.jpg,/imgs/blogs/9/12/ac2ce2fb-0605-4f14-82cc-c962b8c86688.jpg',
 '<p>铜锅端上来先别急着下肉，清汤滚起来之后慢慢涮，羊肉的香味会更明显。</p><p>麻酱里加一点香菜和辣椒油，再配糖蒜。店里座位不挤，适合三五个人边聊边吃。</p>',
 33, 3, '2026-10-16 19:30:00', NOW()),
(31, 6, 2006, '工作日午后的老北京涮锅，安静得像包场',
 '/imgs/blogs/0/5/e3e7c9e7-6654-4065-b47a-b86eb4541c33.jpg,/imgs/blogs/1/2/f052df92-fc05-41a6-866e-d6da63b27645.jpg',
 '<p>下午两点多到店，人不多，铜锅冒着热气，整个空间很安静。</p><p>手切羊肉和冻豆腐都不错，酸梅汤解腻。工作日来吃比晚上舒服很多，不用排队，也能慢慢坐。</p>',
 30, 2, '2026-10-16 14:18:00', NOW()),
(32, 1, 2007, '带小朋友吃茶餐厅，居然全程没闹',
 '/imgs/blogs/4/0/26a7cd7e-6320-432c-a0b4-1b7418f45ec7.jpg,/imgs/blogs/14/3/52b290eb-8b5d-403b-8373-ba0bb856d18e.jpg',
 '<p>带小朋友来吃茶餐厅，原本担心坐不住，结果一份菠萝油和冻柠茶就把注意力留住了。</p><p>叉烧不柴，炒河粉锅气足。店员主动拿了儿童餐具，整体体验比预期轻松。</p>',
 27, 5, '2026-10-15 18:52:00', NOW()),
(33, 9, 2008, '爬完半山来一锅羊蝎子，整个人都活了',
 '/imgs/blogs/3/12/9b19dd28-1eb1-4b70-bdc2-95544eecfeb2.jpg,/imgs/blogs/13/12/f822a9cf-f0dd-405f-81ba-ff93bd07ccf8.jpg',
 '<p>半山下来已经饿透，直接点了一锅羊蝎子。汤底香而不膻，肉也炖得软。</p><p>先啃骨头再涮蔬菜，最后加一份手工面。三个人吃得很满足，冬天还会再来。</p>',
 24, 3, '2026-10-14 13:26:00', NOW()),
(34, 5, 2009, '十一点后的海底捞，热闹但不吵',
 '/imgs/blogs/4/10/2f07e3c9-ddce-482d-9ea7-c21450f8d7cd.jpg,/imgs/blogs/11/3/b5a49c90-e855-4026-a346-4dea17b1a407.jpg',
 '<p>十一点之后商场安静下来，海底捞还是很热闹，但这一桌坐得挺舒服。</p><p>番茄锅和清油锅各一半，虾滑和肥牛稳定发挥。夜宵时段服务员没有那么忙，体验反而更从容。</p>',
 21, 4, '2026-10-13 23:08:00', NOW()),
(35, 11, 2010, 'KTV隔音不错，适合朋友局',
 '/imgs/blogs/1/2/f052df92-fc05-41a6-866e-d6da63b27645.jpg,/imgs/blogs/11/3/b5a49c90-e855-4026-a346-4dea17b1a407.jpg',
 '<p>朋友生日订了小包间，隔音比想象中好，唱歌不用一直提音量。</p><p>曲库更新挺快，点歌屏也好用。果盘和小食分量正常，整体适合六到八个人聚会。</p>',
 19, 2, '2026-10-12 21:40:00', NOW()),
(36, 8, 1, '一碗热汤和一份鳗鱼饭，把工作日收尾',
 '/imgs/blogs/15/9/cea51d9b-ac15-49f6-b9f1-9cf81e9b9c85.jpg,/imgs/blogs/4/10/2f07e3c9-ddce-482d-9ea7-c21450f8d7cd.jpg',
 '<p>工作日最后一顿想吃点热的，点了一份鳗鱼饭和一碗味噌汤。</p><p>鳗鱼表面焦香，米饭软硬刚好。吃完沿着运河走回家，忙碌的一天算是有了一个不错的收尾。</p>',
 16, 2, '2026-10-11 19:16:00', NOW()),
(37, 10, 2, '周末不赶场，唱两小时刚刚好',
 '/imgs/blogs/13/12/f822a9cf-f0dd-405f-81ba-ff93bd07ccf8.jpg,/imgs/blogs/0/0/feb2a83e-5646-46c0-a982-5e43fed31b22.jpg',
 '<p>周末没有安排远行，就和朋友在运河上街唱两个小时。</p><p>下午场人少，音效稳定，唱累了还能出来买杯饮料。比赶景点更适合放松。</p>',
 14, 1, '2026-10-10 16:32:00', NOW());

COMMIT;
