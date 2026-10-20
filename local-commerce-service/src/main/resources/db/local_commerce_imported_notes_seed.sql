SET NAMES utf8mb4;

START TRANSACTION;

INSERT INTO tb_blog
(id, shop_id, user_id, title, images, content, liked, comments, create_time, update_time)
VALUES
(
    52, 50, 2001,
    '坚持训练两个月，体态和状态都回来了',
    '/imgs/blogs/imported/gym-review-01.jpg,/imgs/blogs/imported/gym-review-02.jpg,/imgs/blogs/imported/gym-review-03.jpg',
    '<p>坚持训练两个月，最直观的变化不是体重，而是整个人的精神和工作状态。教练每次都会把动作细节讲清楚，也会根据我的时间调整训练安排，不是上完课就不管了。</p><p>器械区维护得很干净，常用设备旁边放着酒精和毛巾。下班后过来练一小时，场馆不拥挤，节奏刚刚好，适合长期坚持。</p>',
    56, 8, '2026-10-19 10:20:00', NOW()
),
(
    53, 20, 2007,
    '给小朋友安排体能课，运动也可以很有趣',
    '/imgs/blogs/imported/gym-review-04.jpg,/imgs/blogs/imported/gym-review-05.jpg,/imgs/blogs/imported/gym-review-06.jpg',
    '<p>原本担心小朋友坐不住，体验之后才发现课程安排得很灵活。热身、跳跃和基础动作会拆成小游戏，孩子练得开心，也不会一下子消耗太多体力。</p><p>教练会先了解孩子的运动习惯，再安排适合的强度。场地留出了足够的活动空间，家长在休息区也能看到训练过程，整体比较安心。</p>',
    42, 6, '2026-10-19 09:35:00', NOW()
),
(
    54, 3, 2003,
    '一桌杭帮菜，把清鲜和烟火气都吃到了',
    '/imgs/blogs/imported/food-longjing-shrimp.jpg,/imgs/blogs/imported/food-west-lake-fish.jpg,/imgs/blogs/imported/food-dongpo-pork.jpg',
    '<p>龙井虾仁入口清甜，虾肉有弹性，茶香没有盖住食材本身的味道。西湖醋鱼酸甜比较克制，鱼肉很嫩，配着汤汁吃刚好。</p><p>东坡肉是整桌最有烟火气的一道，肥而不腻，酱汁拌饭很香。三个人点这几道菜分量刚好，适合带家里人慢慢吃一顿。</p>',
    48, 7, '2026-10-18 19:40:00', NOW()
),
(
    55, 1, 2006,
    '片儿川、叫化鸡和宋嫂鱼羹，杭州味道都在这一桌',
    '/imgs/blogs/imported/food-pianer-noodles.jpg,/imgs/blogs/imported/food-beggar-chicken.jpg,/imgs/blogs/imported/food-fish-soup.jpg',
    '<p>片儿川的汤底很鲜，雪菜和笋片让面条多了一点清爽的层次。叫化鸡外层的香气很足，鸡肉软嫩，适合几个人一起分。</p><p>最后来一碗宋嫂鱼羹，酸香开胃，口感细腻。工作日晚餐不想吃得太复杂时，这一桌杭州味道很稳。</p>',
    37, 5, '2026-10-18 18:55:00', NOW()
),
(
    56, 4, 2002,
    '在茶园和水边吃饭，杭州的慢节奏有了样子',
    '/imgs/blogs/imported/restaurant-tea-garden.jpg,/imgs/blogs/imported/restaurant-canal-boat.jpg,/imgs/blogs/imported/restaurant-fried-balls.jpg',
    '<p>先绕茶园走了一圈，再回到临水的餐厅吃饭。窗外是树影和水面，室内是木质桌椅，坐下来之后节奏自然就慢了下来。</p><p>小吃拼盘适合边聊边吃，炸物外酥里嫩，不会太油。相比赶景点，更喜欢这种把散步、吃饭和看风景放在一起的安排。</p>',
    44, 4, '2026-10-18 16:25:00', NOW()
),
(
    57, 5, 2004,
    '小笼、鱼鲜和烤鸭，适合慢慢吃的一顿饭',
    '/imgs/blogs/imported/restaurant-soup-dumplings.jpg,/imgs/blogs/imported/restaurant-fish-dish.jpg,/imgs/blogs/imported/restaurant-roast-duck.jpg',
    '<p>灌汤小笼皮薄汤鲜，先咬开一个小口再喝汤，味道很舒服。鱼鲜那道菜辣度适中，肉质细嫩，汤汁也很下饭。</p><p>烤鸭切得整齐，皮脆肉香，配一点甜面酱刚好。店里上菜节奏不急，适合朋友聚餐或带长辈来吃。</p>',
    39, 6, '2026-10-18 14:10:00', NOW()
),
(
    58, 37, 2005,
    '周末面包节，把喜欢的碳水一次买齐',
    '/imgs/blogs/imported/feed-bakery-collage.jpg,/imgs/blogs/imported/feed-pastry.jpg,/imgs/blogs/imported/feed-lotus-root.jpg',
    '<p>面包节现场比想象中丰富，从可颂、贝果到中式酥点都能找到。先逛一圈再买，基本不会空手出来。</p><p>酥皮类建议当天吃，回烤之后香气更好。莲藕造型的糕点很适合拍照，甜度也比预想中低，配茶刚刚好。</p>',
    51, 9, '2026-10-18 13:30:00', NOW()
),
(
    59, 56, 2010,
    '满觉陇入秋之后，随便走走都像一幅画',
    '/imgs/blogs/imported/feed-autumn-temple.jpg',
    '<p>沿着满觉陇慢慢走，树色已经开始分层，金黄、橙红和深绿交织在一起。登高之后能看到寺院屋顶和远处的山，视野很开阔。</p><p>建议上午来，光线柔和，人也少一些。穿一双舒服的鞋，带一瓶水，不需要赶打卡点，沿途停停走走就很好。</p>',
    63, 5, '2026-10-18 11:05:00', NOW()
),
(
    60, 52, 2008,
    '下班后的力量训练，把状态重新拉回来',
    '/imgs/blogs/imported/feed-gym.jpg',
    '<p>最近把训练重新排进工作日，强度不追求一次拉满，先保证动作稳定和呼吸节奏。练完出一身汗，反而比直接回家更有精神。</p><p>场馆器械比较齐全，晚上人也不算多。固定的训练计划加上规律吃饭，比偶尔突击一次更容易坚持。</p>',
    46, 4, '2026-10-17 21:15:00', NOW()
),
(
    61, 1, 2009,
    '炸鸡和面包的快乐组合，加班后的治愈晚餐',
    '/imgs/blogs/imported/feed-fried-chicken.jpg',
    '<p>加班结束不想再纠结吃什么，点了一份炸鸡和面包。外皮酥脆，鸡肉还保留着汁水，配一杯清爽饮料刚好解腻。</p><p>面包没有抢戏，反而把辣味和油香平衡了一些。偶尔放纵一顿，第二天再认真吃饭和运动就好。</p>',
    34, 3, '2026-10-17 20:20:00', NOW()
),
(
    62, 31, 2005,
    '一张葱香饼和一碗奶香面，简单但很满足',
    '/imgs/blogs/imported/feed-pancake.jpg,/imgs/blogs/imported/feed-noodles.jpg',
    '<p>葱香饼外层煎得酥脆，里面还保留着柔软的口感，切开时能看到一层层葱香。份量不小，两个人分着吃刚好。</p><p>奶香面比想象中清爽，酱汁没有把面条完全盖住。下午路过时来一份，简单但很满足，适合当作逛街途中的补给。</p>',
    29, 2, '2026-10-17 15:45:00', NOW()
)
ON DUPLICATE KEY UPDATE
shop_id = VALUES(shop_id),
user_id = VALUES(user_id),
title = VALUES(title),
images = VALUES(images),
content = VALUES(content),
liked = VALUES(liked),
comments = VALUES(comments),
create_time = VALUES(create_time),
update_time = NOW();

COMMIT;
