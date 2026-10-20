SET NAMES utf8mb4;

START TRANSACTION;

REPLACE INTO tb_shop_type (id, name, icon, sort, create_time, update_time) VALUES
(11, '甜品烘焙', '/types/dessert.svg', 11, NOW(), NOW()),
(12, '景点游玩', '/types/travel.svg', 12, NOW(), NOW());

REPLACE INTO tb_shop
(id, name, type_id, images, area, address, x, y, avg_price, sold, comments, score, open_hours, create_time, update_time) VALUES
(31, 'RUSON(黄龙店)', 11, '/imgs/shops/dessert-a.svg', '西湖北线/黄龙', '曙光路122号黄龙商圈', 120.130000, 30.271000, 42, 3800, 4222, 45, '08:30-21:00', NOW(), NOW()),
(32, '猫里有甜', 11, '/imgs/shops/dessert-b.svg', '开发区/高教园', '学源街文创街区12号', 120.340000, 30.310000, 56, 2200, 2691, 50, '10:00-21:30', NOW(), NOW()),
(33, '三花屋 Mihhanaya', 11, '/imgs/shops/dessert-a.svg', '水晶城', '上塘路458号水晶城1层', 120.158500, 30.310000, 55, 1900, 2158, 45, '09:30-20:30', NOW(), NOW()),
(34, 'Foamy-Foamy(杭州国大城市广场店)', 11, '/imgs/shops/dessert-b.svg', '武林广场', '延安路609号国大城市广场', 120.163000, 30.274000, 52, 6000, 6649, 45, '10:00-22:00', NOW(), NOW()),
(35, 'Cycle&Cycle(中山北路店)', 11, '/imgs/shops/dessert-a.svg', '武林广场', '中山北路与凤起路交叉口', 120.166000, 30.276000, 36, 9000, 10480, 40, '07:30-20:00', NOW(), NOW()),
(36, '熊猫家日式面包蛋糕店(滨江店)', 11, '/imgs/shops/dessert-b.svg', '开发区/高教园', '江南大道与江陵路交叉口', 120.210000, 30.208000, 34, 1500, 1767, 45, '09:00-21:00', NOW(), NOW()),
(37, '富贵面包公司(运河店)', 11, '/imgs/shops/dessert-a.svg', '信义坊/胜利河美食街', '霞湾巷8号富义仓边', 120.145000, 30.310000, 35, 5200, 5805, 45, '08:30-20:30', NOW(), NOW()),
(38, '布歌东京(嘉里中心店)', 11, '/imgs/shops/dessert-b.svg', '凤起路沿线', '延安路385号嘉里中心B1层', 120.162000, 30.260000, 112, 2100, 2469, 45, '10:00-22:00', NOW(), NOW()),
(39, 'CHOCMONS巧克怪兽(屏风街店)', 11, '/imgs/shops/dessert-a.svg', '武林广场', '屏风街58号', 120.167000, 30.269000, 42, 3200, 3489, 40, '08:00-20:30', NOW(), NOW()),
(40, '23 SERIES', 11, '/imgs/shops/dessert-b.svg', '吴山广场/河坊街', '惠民路23号', 120.168000, 30.240000, 56, 600, 670, 45, '10:30-21:30', NOW(), NOW()),
(41, 'INLOVE KTV(西溪印象城店)', 2, '/imgs/shops/karaoke-a.svg', '西溪', '余杭塘路与五常大道交叉口印象城', 120.060000, 30.270000, 76, 2500, 2877, 45, '12:00-06:00', NOW(), NOW()),
(42, '唛歌KTV(西城广场店)', 2, '/imgs/shops/karaoke-b.svg', '西城广场', '文二西路551号西城广场', 120.100000, 30.280000, 60, 5000, 5634, 45, '12:00-02:00', NOW(), NOW()),
(43, '开乐迪KTV.AI辅唱(空港新天地店)', 2, '/imgs/shops/karaoke-a.svg', '萧山机场', '空港大道空港新天地', 120.430000, 30.230000, 56, 900, 1061, 45, '12:00-03:00', NOW(), NOW()),
(44, '温莎KTV(湖墅南路店)', 2, '/imgs/shops/karaoke-b.svg', '湖墅南路', '湖墅南路458号', 120.150000, 30.290000, 74, 11000, 13028, 45, '12:00-06:00', NOW(), NOW()),
(45, '90KTV(金海城店)', 2, '/imgs/shops/karaoke-a.svg', '九堡新天地文化创意园', '九环路与九华路交叉口', 120.290000, 30.310000, 61, 1000, 1213, 45, '12:00-03:00', NOW(), NOW()),
(46, '杭州美莱医疗美容医院', 6, '/imgs/shops/beauty-a.svg', '西湖北线/黄龙', '曙光路122号世贸中心', 120.130000, 30.271000, 7000, 500, 11657, 45, '09:00-20:00', NOW(), NOW()),
(47, '杭州奥拉克医疗美容门诊部', 6, '/imgs/shops/beauty-b.svg', '高新文教区', '文三路与古翠路交叉口', 120.120000, 30.280000, 3190, 300, 5525, 45, '09:00-20:00', NOW(), NOW()),
(48, '杭州韩美医疗美容', 6, '/imgs/shops/beauty-a.svg', '古荡商圈', '古墩路188号', 120.120000, 30.285000, 1729, 200, 810, 50, '09:00-19:30', NOW(), NOW()),
(49, '杭州仁术医疗美容(萧山院)', 6, '/imgs/shops/beauty-b.svg', '北干商圈', '金城路168号', 120.260000, 30.180000, 2118, 400, 4302, 40, '09:00-20:00', NOW(), NOW()),
(50, '优健健身工作室(文三西路店)', 4, '/imgs/shops/gym-a.svg', '文三路沿线', '文三西路118号', 120.130000, 30.282000, 506, 600, 677, 50, '07:00-22:30', NOW(), NOW()),
(51, 'i77普拉提健身馆(阿里店)', 4, '/imgs/shops/gym-b.svg', '海创园', '文一西路969号阿里园区旁', 120.030000, 30.280000, 642, 280, 305, 50, '09:00-21:30', NOW(), NOW()),
(52, 'AFTERWORK健身(西湖云澜谷店)', 4, '/imgs/shops/gym-a.svg', '西溪', '西溪路与紫金港路交叉口', 120.060000, 30.270000, 1646, 300, 340, 50, '07:00-22:30', NOW(), NOW()),
(53, '乐刻健身(古墩印象城店升级馆5.0)', 4, '/imgs/shops/gym-b.svg', '古墩路沿线', '古墩路588号印象城', 120.100000, 30.300000, 895, 380, 407, 40, '00:00-24:00', NOW(), NOW()),
(54, 'G20峰会体验馆售票处', 12, '/imgs/shops/travel-a.svg', '奥体博览中心', '奔竞大道353号奥体中心', 120.230000, 30.230000, NULL, 200, 240, 45, '09:00-17:00', NOW(), NOW()),
(55, '千岛湖湖人皮划艇俱乐部', 12, '/imgs/shops/travel-b.svg', '明珠花园', '千岛湖镇阳光路湖畔', 119.042000, 29.608000, NULL, 180, 219, 45, '08:30-17:30', NOW(), NOW()),
(56, '林彪行宫(704工程)', 12, '/imgs/shops/travel-a.svg', '龙井/虎跑', '龙井路南侧704工程旧址', 120.120000, 30.220000, NULL, 900, 1095, 50, '08:30-16:30', NOW(), NOW()),
(57, '白云源风景区', 12, '/imgs/shops/travel-b.svg', '富春江景区', '富阳区富春江镇白云源', 119.960000, 29.960000, NULL, 1000, 1265, 45, '08:00-17:00', NOW(), NOW()),
(58, '千岛湖梅峰岛景区', 12, '/imgs/shops/travel-a.svg', '千岛湖风景区', '淳安县千岛湖中心湖区', 119.042000, 29.608000, NULL, 1300, 1520, 50, '08:00-16:30', NOW(), NOW());

REPLACE INTO tb_blog
(id, shop_id, user_id, title, images, content, liked, comments, create_time, update_time) VALUES
(46, 37, 2003, '运河边刚出炉的盐面包，下午四点最好吃',
 '/imgs/shops/dessert-a.svg,/imgs/shops/dessert-b.svg',
 '<p>路过富义仓时闻到烘焙香，顺手买了盐面包和红豆包。外皮薄脆，里面还是有韧性的。</p><p>下午四点左右正好赶上新一炉，坐在河边吃完再走很舒服。肉桂卷偏甜，适合配不加糖的咖啡。</p>',
 45, 6, '2026-10-18 16:40:00', NOW()),
(47, 50, 2008, '私教先做体测，没有一上来就推年卡',
 '/imgs/shops/gym-a.svg,/imgs/shops/gym-b.svg',
 '<p>第一次体验先做了基础体测和动作评估，教练把膝盖发力的细节讲得很清楚。</p><p>体验课强度适中，结束后给的是训练建议，没有急着推长期课程。场地不大但器械维护得不错。</p>',
 43, 5, '2026-10-18 11:25:00', NOW()),
(48, 46, 2004, '先做皮肤检测再决定项目，整个过程比较克制',
 '/imgs/shops/beauty-a.svg,/imgs/shops/beauty-b.svg',
 '<p>到店后先做了检测，医生把近期不适合做的项目直接排除掉了，没有强行加项。</p><p>沟通时间比较充分，注意事项也写在离店单上。整体感受专业，后续是否继续体验会再观察。</p>',
 39, 4, '2026-10-17 17:10:00', NOW()),
(49, 41, 2009, '西溪印象城这家KTV，下午场性价比不错',
 '/imgs/shops/karaoke-a.svg,/imgs/shops/karaoke-b.svg',
 '<p>下午场人不多，小包间也够四个人坐。点歌屏反应快，麦克风电量充足。</p><p>隔音正常，唱两小时不会被隔壁影响。商场里吃饭方便，适合周末临时约朋友。</p>',
 34, 3, '2026-10-16 16:18:00', NOW()),
(50, 54, 2007, '奥体中心的G20体验馆，雨天也能逛',
 '/imgs/shops/travel-a.svg,/imgs/shops/travel-b.svg',
 '<p>场馆主要看会议空间和布置，动线不长，带长辈来也不会太累。</p><p>建议提前确认开放时间，现场有讲解牌。雨天作为室内行程比较合适，周边还能顺路逛奥体。</p>',
 29, 2, '2026-10-15 13:50:00', NOW()),
(51, 58, 2010, '坐船上梅峰岛，湖面比照片更开阔',
 '/imgs/shops/travel-a.svg,/imgs/shops/travel-b.svg',
 '<p>上岛需要坐船，天气好的时候湖面层次很清楚。梅峰观景台视野开阔，步行强度不高。</p><p>建议避开正午，带水和防晒。岛上停留时间不用太久，和中心湖区其他岛一起安排更顺路。</p>',
 26, 2, '2026-10-14 10:32:00', NOW());

UPDATE tb_shop
SET images = CASE id
    WHEN 31 THEN '/imgs/shops/photos/31-ruson.jpg'
    WHEN 32 THEN '/imgs/shops/photos/32-catcake.jpg'
    WHEN 33 THEN '/imgs/shops/photos/33-mihhanaya.jpg'
    WHEN 34 THEN '/imgs/shops/photos/34-foamy.jpg'
    WHEN 35 THEN '/imgs/shops/photos/35-cycle.jpg'
    WHEN 36 THEN '/imgs/shops/photos/36-panda.jpg'
    WHEN 37 THEN '/imgs/shops/photos/37-fugui.jpg'
    WHEN 38 THEN '/imgs/shops/photos/38-bugedongjing.jpg'
    WHEN 39 THEN '/imgs/shops/photos/39-chocmons.jpg'
    WHEN 40 THEN '/imgs/shops/photos/40-23series.jpg'
    WHEN 41 THEN '/imgs/shops/photos/41-inlove-xixi.jpg'
    WHEN 42 THEN '/imgs/shops/photos/42-mago.jpg'
    WHEN 43 THEN '/imgs/shops/photos/43-kaileidi-airport.jpg'
    WHEN 44 THEN '/imgs/shops/photos/44-windsor.jpg'
    WHEN 45 THEN '/imgs/shops/photos/45-90ktv.jpg'
    WHEN 46 THEN '/imgs/shops/photos/46-meilai.jpg'
    WHEN 47 THEN '/imgs/shops/photos/47-oracle.jpg'
    WHEN 48 THEN '/imgs/shops/photos/48-hanmei.jpg'
    WHEN 49 THEN '/imgs/shops/photos/49-renshu.jpg'
    WHEN 50 THEN '/imgs/shops/photos/50-youjian.jpg'
    WHEN 51 THEN '/imgs/shops/photos/51-i77.jpg'
    WHEN 52 THEN '/imgs/shops/photos/52-afterwork.jpg'
    WHEN 53 THEN '/imgs/shops/photos/53-leke-gudun.jpg'
    WHEN 54 THEN '/imgs/shops/photos/54-g20.jpg'
    WHEN 55 THEN '/imgs/shops/photos/55-kayak.jpg'
    WHEN 56 THEN '/imgs/shops/photos/56-704.jpg'
    WHEN 57 THEN '/imgs/shops/photos/57-baiyunyuan.jpg'
    WHEN 58 THEN '/imgs/shops/photos/58-meifeng.jpg'
    ELSE images
END,
update_time = NOW()
WHERE id BETWEEN 31 AND 58;

UPDATE tb_blog
SET images = CASE id
    WHEN 46 THEN '/imgs/shops/photos/37-fugui.jpg'
    WHEN 47 THEN '/imgs/shops/photos/50-youjian.jpg'
    WHEN 48 THEN '/imgs/shops/photos/46-meilai.jpg'
    WHEN 49 THEN '/imgs/shops/photos/41-inlove-xixi.jpg'
    WHEN 50 THEN '/imgs/shops/photos/54-g20.jpg'
    WHEN 51 THEN '/imgs/shops/photos/58-meifeng.jpg'
    ELSE images
END,
update_time = NOW()
WHERE id BETWEEN 46 AND 51;

COMMIT;
