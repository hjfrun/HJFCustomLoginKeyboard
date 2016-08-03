//
//  HJFPunctuationView.m
//  HJFCustomLoginKeyboardDemo
//
//  Created by hjfrun on 16/7/16.
//  Copyright © 2016年 hjfrun. All rights reserved.
//

#import "HJFPunctuationView.h"
#import "HJFPunctuationTabBar.h"
#import "Constant.h"

NSString *const PunctuationCellDidClickedNotification = @"PunctuationCellDidClickedNotification";

static NSString *const RecentPunctuationKey = @"RecentPunctuationKey";

@interface HJFPunctuationView() <UICollectionViewDataSource, UICollectionViewDelegate>


@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;

@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *collectionViewLayout;

@property (nonatomic, strong) NSMutableArray *recentPunctuations;
@property (nonatomic, strong) NSArray *chinesePunctuations;
@property (nonatomic, strong) NSArray *englishPunctuations;
@property (nonatomic, strong) NSArray *emotionPunctuations;
@property (nonatomic, strong) NSArray *cyberSpacePunctuations;
@property (nonatomic, strong) NSArray *specialPunctuations;
@property (nonatomic, strong) NSArray *mathPunctuations;
@property (nonatomic, strong) NSArray *orderPunctuations;
@property (nonatomic, strong) NSArray *greekAndRussianPunctuations;
@property (nonatomic, strong) NSArray *arrowPunctuations;
@property (nonatomic, strong) NSArray *hiraganaPunctuations;
@property (nonatomic, strong) NSArray *katakanaPunctuations;
@property (nonatomic, strong) NSArray *phoneticPunctuations;
@property (nonatomic, strong) NSArray *radicalsPunctuations;
@property (nonatomic, strong) NSArray *tabulationPunctuations;


@end

static NSString *const punctuationCellId = @"punctuationCellId";

@implementation HJFPunctuationView

- (void)awakeFromNib
{
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:punctuationCellId];
    
    
//    CGFloat width = self.collectionView.frame.size.width;
    CGFloat height = self.collectionView.frame.size.height;
    
    CGFloat itemWidth = AUTO_ADAPT_SIZE_VALUE(320.f, 375.f, 414.f) / 4.8f;
    self.collectionViewLayout.itemSize = CGSizeMake(itemWidth - 1.f, height / 4.f - 1.f);
    
    
    self.collectionViewLayout.minimumLineSpacing = 1.f;
    self.collectionViewLayout.minimumInteritemSpacing = 1.f;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(punctuationTabBarClick:) name:PunctuationTabBarDidClickedNotification object:nil];
    
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)punctuationTabBarClick:(NSNotification *)notification
{
    NSDictionary *userInfo = notification.userInfo;
    HJFPunctuationTabBarButtonType type = [userInfo[@"buttonType"] unsignedIntegerValue];
    
    switch (type) {
        case HJFPunctuationTabBarButtonTypeRecent:
            self.punctuations = self.recentPunctuations;
            break;
        case HJFPunctuationTabBarButtonTypeChinese:
            self.punctuations = self.chinesePunctuations;
            break;
        case HJFPunctuationTabBarButtonTypeEnglish:
            self.punctuations = self.englishPunctuations;
            break;
        case HJFPunctuationTabBarButtonTypeEmotion:
            self.punctuations = self.emotionPunctuations;
            break;
        case HJFPunctuationTabBarButtonTypeCyberSpace:
            self.punctuations = self.cyberSpacePunctuations;
            break;
        case HJFPunctuationTabBarButtonTypeSpecial:
            self.punctuations = self.specialPunctuations;
            break;
        case HJFPunctuationTabBarButtonTypeMath:
            self.punctuations = self.mathPunctuations;
            break;
        case HJFPunctuationTabBarButtonTypeOrder:
            self.punctuations = self.orderPunctuations;
            break;
        case HJFPunctuationTabBarButtonTypeGreekAndRussian:
            self.punctuations = self.greekAndRussianPunctuations;
            break;
        case HJFPunctuationTabBarButtonTypeArrow:
            self.punctuations = self.arrowPunctuations;
            break;
        case HJFPunctuationTabBarButtonTypeHiragana:
            self.punctuations = self.hiraganaPunctuations;
            break;
        case HJFPunctuationTabBarButtonTypeKatakana:
            self.punctuations = self.katakanaPunctuations;
            break;
        case HJFPunctuationTabBarButtonTypePhonetic:
            self.punctuations = self.phoneticPunctuations;
            break;
        case HJFPunctuationTabBarButtonTypeRadicals:
            self.punctuations = self.radicalsPunctuations;
            break;
        case HJFPunctuationTabBarButtonTypeTabulation:
            self.punctuations = self.tabulationPunctuations;
            break;
            
        default:
            break;
    }
}

- (void)setPunctuations:(NSArray<NSString *> *)punctuations
{
    _punctuations = punctuations;
    
    [self.collectionView reloadData];
}


#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.punctuations.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:punctuationCellId forIndexPath:indexPath];
    cell.backgroundColor = [UIColor colorWithRed:214 / 255.f green:216 / 255.f blue:220 / 255.f alpha:1.f];
    [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont systemFontOfSize:23];
    label.text = self.punctuations[indexPath.item];
    [label sizeToFit];
    label.center = cell.contentView.center;
    
    [cell.contentView addSubview:label];
    
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *punctuation = self.punctuations[indexPath.item];
    [self saveRecentPunctuation:punctuation];
    [[NSNotificationCenter defaultCenter] postNotificationName:PunctuationCellDidClickedNotification object:nil userInfo:@{@"punctuation" : punctuation}];
}

- (void)saveRecentPunctuation:(NSString *)punctuation
{
    if ([self.recentPunctuations containsObject:punctuation]) {
        [self.recentPunctuations removeObject:punctuation];
    }
    [self.recentPunctuations insertObject:punctuation atIndex:0];
    if (self.recentPunctuations.count > 28) {           // 常用表情不多余28个
        [self.recentPunctuations removeLastObject];
    }
    [[NSUserDefaults standardUserDefaults] setObject:self.recentPunctuations forKey:RecentPunctuationKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


- (NSMutableArray *)recentPunctuations
{
    if (_recentPunctuations == nil) {
        NSArray *recentArray = [[NSUserDefaults standardUserDefaults] objectForKey:RecentPunctuationKey];
        if (recentArray.count == 0) {
            recentArray = @[@":", @"?", @"!", @"。", @"，", @"、", @".", @"$", @"@",@"/", @"+", @"=", @"*", @"#", @"&", @"-", @"￥", @"%"];
        }
        _recentPunctuations = [NSMutableArray arrayWithArray:recentArray];
        
    }
    return _recentPunctuations;
}

- (NSArray *)englishPunctuations
{
    if (_englishPunctuations == nil) {
        _englishPunctuations = @[@".", @",", @"?", @":", @"...", @"@", @"/", @";", @"!", @"()", @"*", @"&", @"[]", @"\\", @"`", @"~", @"#", @"$", @"%", @"^", @"_", @"+", @"-", @"=", @"{}", @"|", @"<>", @"\""];
    }
    return _englishPunctuations;
}

- (NSArray *)chinesePunctuations
{
    if (_chinesePunctuations == nil) {
        _chinesePunctuations = @[@"，", @"。", @"？", @"！", @"：", @"、", @"……", @"“”", @"；", @"（）", @"《》", @"～", @"‘’", @"〈〉", @"——", @"·", @"ˉ", @"ˇ", @"¨", @"々", @"‖", @"∶", @"＂", @"＇", @"｀", @"｜", @"〃", @"〔〕", @"「」", @"『』", @"．", @"〖〗", @"【】", @"［］", @"｛｝"];
    }
    return _chinesePunctuations;
}
- (NSArray *)emotionPunctuations
{
    //    ?_?π_π－O－O_o555~e_ehaha~hehe~oh~Yeah~Q_QT_T::>_<::(-.-)≥﹏≤(>_<)~_~>o<(^-^)(^o^)(^３^)\^O^/+_+⊙_⊙⊙▽⊙⊙ω⊙$_$>_<*^÷^**^◎^*╭∩╮^_^¦¦¦^=_=^﹌○﹌~>_<~╰_╯╯﹏╰╯▂╰〒_〒~^o^~~`o`~=^_^==_=≡^ˇ^≡●﹏●(ˇˍˇ)(⊙o⊙)(≥3≤)>_<¦¦¦y^o^y(>﹏<)●︿●●▂●◑▂◐(￣.￣)(*>.<*)(╯3╰)(°ο°)(～o～)(？o？)(☆_☆)~T_T~~w_w~(ˉ(∞)ˉ)Y(^_^)Yy∩__∩y(*^@^*)(*^﹏^*)(=^.^=)(=^ω^=)*^____^*
    if (_emotionPunctuations == nil) {
        _emotionPunctuations = @[@":)", @":P", @":D", @":-C", @":(", @",-)", @":-I", @":-O", @">:-<", @"~zZ", @"@_@", @"^o^", @"^v^", @"^ω^", @"←_←", @"→_→", @"#^_^#", @"^_^", @"*^_^*", @"*^o^*", @"-_-", @"-_-#", @"-_-||", @"-_-b", @"-.-"];
    }
    return _emotionPunctuations;
}
- (NSArray *)cyberSpacePunctuations
{
    
    if (_cyberSpacePunctuations == nil) {
        _cyberSpacePunctuations = @[@".", @"/", @"@", @"www.", @"wap.", @"blog.", @"bbs.", @".com", @".cn", @".net", @".org", @"http://", @"ftp://"];
    }
    return _cyberSpacePunctuations;
}

- (NSArray *)specialPunctuations
{
    if (_specialPunctuations == nil) {
        _specialPunctuations = @[@"/", @"\\", @"╳", @"︵", @"︶", @"︹", @"︺", @"︿", @"﹀", @"︴", @"﹌", @"﹉", @"﹊", @"﹍", @"﹎", @"╭", @"╮", @"╰", @"╯", @"︽", @"︾", @"﹁", @"﹂", @"﹃", @"﹄", @"﹏", @"ˇ", @"‥", @"︷", @"︸", @"«", @"»", @"︻", @"︼", @"℡", @"™", @"Š", @"Õ", @"©", @"®", @"‡", @"†", @"♂", @"♀", @"§", @"№", @"☆", @"★", @"●", @"Θ", @"○", @"◎", @"⊙", @"◆", @"◇", @"▲", @"▼", @"△", @"▽", @"□", @"■", @"※", @"▪", @"〓", @"¤", @"°", @"Ψ", @"∮", @"⊕", @"卍", @"卐", @"囍", @"㈱", @"＿", @"￣", @"―", @"￡"];
    }
    return _specialPunctuations;
}

- (NSArray *)mathPunctuations
{
    if (_mathPunctuations == nil) {
        _mathPunctuations = @[@"＋", @"－", @"×", @"÷", @"≈", @"≡", @"≠", @"＝", @"±", @"√", @"≤", @"≥", @"＜", @"＞", @"≮", @"≯", @"∷", @"╱", @"╲", @"∫", @"∮", @"∝", @"∞", @"∧", @"∨", @"∑", @"∏", @"∪", @"∩", @"∈", @"∵", @"∴", @"⊥", @"∥", @"∠", @"⌒", @"⊙", @"≌", @"∽", @"≒", @"≦", @"≧", @"½", @"¼", @"¾", @"⅛", @"⅜", @"⅝", @"⅞", @"＄", @"％", @"Ｆ", @"′", @"″", @"º", @"℃", @"Å", @"￠", @"￡", @"￥", @"¤", @"℉", @"‰", @"ℓ", @"㏄", @"㎜", @"㎝", @"㎞", @"㎡", @"㎎", @"㎏", @"Ω"];
    }
    return _mathPunctuations;
}

- (NSArray *)orderPunctuations
{
    if (_orderPunctuations == nil) {
        _orderPunctuations = @[@"①", @"②", @"③", @"④", @"⑤", @"⑥", @"⑦", @"⑧", @"⑨", @"⑩", @"１", @"２", @"３", @"４", @"５", @"６", @"７", @"８", @"９", @"０", @"⒈", @"⒉", @"⒊", @"⒋", @"⒌", @"⒍", @"⒎", @"⒏", @"⒐", @"⒑", @"⒒", @"⒓", @"⒔", @"⒕", @"⒖", @"⒗", @"⒘", @"⒙", @"⒚", @"⒛", @"⑴", @"⑵", @"⑶", @"⑷", @"⑸", @"⑹", @"⑺", @"⑻", @"⑼", @"⑽", @"⑾", @"⑿", @"⒀", @"⒁", @"⒂", @"⒃", @"⒄", @"⒅", @"⒆", @"⒇", @"㈠", @"㈡", @"㈢", @"㈣", @"㈤", @"㈥", @"㈦", @"㈧", @"㈨", @"㈩", @"壹", @"贰", @"叁", @"肆", @"伍", @"陆", @"柒", @"捌", @"玖", @"拾", @"佰", @"仟", @"万", @"ⅰ", @"ⅱ", @"ⅳ", @"ⅴ", @"ⅵ", @"ⅶ", @"ⅷ", @"ⅸ", @"ⅹ", @"Ⅰ", @"Ⅱ", @"Ⅲ", @"Ⅳ", @"Ⅴ", @"Ⅵ", @"Ⅶ", @"Ⅷ", @"Ⅸ", @"Ⅹ", @"Ⅺ", @"Ⅻ", @"㊣"];
    }
    return _orderPunctuations;
}

- (NSArray *)greekAndRussianPunctuations
{
    if (_greekAndRussianPunctuations == nil) {
        _greekAndRussianPunctuations = @[@"α", @"β", @"γ", @"δ", @"ε", @"ζ", @"η", @"θ", @"ι", @"κ", @"λ", @"μ", @"ν", @"ξ", @"ο", @"π", @"ρ", @"σ", @"τ", @"υ", @"φ", @"χ", @"ψ", @"ω", @"Α", @"Β", @"Γ", @"Δ", @"Ε", @"Ζ", @"Η", @"Θ", @"Ι", @"Κ", @"Λ", @"Μ", @"Ν", @"Ξ", @"Ο", @"Π", @"Ρ", @"Σ", @"Τ", @"Υ", @"Φ", @"Χ", @"Ψ", @"Ω", @"а", @"б", @"в", @"г", @"д", @"е", @"ё", @"ж", @"з", @"и", @"й", @"к", @"л", @"м", @"н", @"о", @"п", @"р", @"с", @"т", @"у", @"ф", @"х", @"ц", @"ч", @"ш", @"щ", @"ъ", @"ы", @"ь", @"э", @"ю", @"я", @"А", @"Б", @"В", @"Г", @"Д", @"Е", @"Ё", @"Ж", @"З", @"И", @"Й", @"К", @"Л", @"М", @"Н", @"О", @"П", @"Р", @"С", @"Т", @"У", @"Ф", @"Х", @"Ц", @"Ч", @"Ш", @"Щ", @"Ъ", @"Ы", @"Ь", @"Э", @"Ю", @"Я"];
    }
    return _greekAndRussianPunctuations;
}

- (NSArray *)arrowPunctuations
{
    if (_arrowPunctuations == nil) {
        _arrowPunctuations = @[@"↖", @"↑", @"↗", @"←", @"↹", @"→", @"↙", @"↓", @"↘"];
    }
    return _arrowPunctuations;
}


- (NSArray *)hiraganaPunctuations
{
    if (_hiraganaPunctuations == nil) {
        _hiraganaPunctuations = @[@"あ", @"い", @"う", @"え", @"お", @"ぁ", @"ぃ", @"ぅ", @"ぇ", @"ぉ", @"か", @"き", @"く", @"け", @"こ", @"が", @"ぎ", @"ぐ", @"げ", @"ご", @"さ", @"し", @"す", @"せ", @"そ", @"ざ", @"じ", @"ず", @"ぜ", @"ぞ", @"た", @"ち", @"つ", @"て", @"と", @"だ", @"ぢ", @"づ", @"で", @"ど", @"っ", @"な", @"に", @"ぬ", @"ね", @"の", @"は", @"ひ", @"ふ", @"へ", @"ほ", @"ば", @"び", @"ぶ", @"べ", @"ぼ", @"ぱ", @"ぴ", @"ぷ", @"ぺ", @"ぽ", @"ま", @"み", @"む", @"め", @"も", @"や", @"ゆ", @"よ", @"ゃ", @"ゅ", @"ょ", @"ら", @"り", @"る", @"れ", @"ろ", @"わ", @"を", @"ん", @"ゎ"];
    }
    return _hiraganaPunctuations;
}

- (NSArray *)katakanaPunctuations
{
    if (_katakanaPunctuations == nil) {
        _katakanaPunctuations = @[@"ア", @"イ", @"ウ", @"エ", @"オ", @"ァ", @"ィ", @"ゥ", @"ェ", @"ォ", @"カ", @"キ", @"ク", @"ケ", @"コ", @"ガ", @"ギ", @"グ", @"ゲ", @"ゴ", @"サ", @"シ", @"ス", @"セ", @"ソ", @"ザ", @"ジ", @"ズ", @"ゼ", @"ゾ", @"タ", @"チ", @"ツ", @"テ", @"ト", @"ダ", @"ヂ", @"ヅ", @"デ", @"ド", @"ッ", @"ナ", @"ニ", @"ヌ", @"ネ", @"ノ", @"ハ", @"ヒ", @"フ", @"ヘ", @"ホ", @"バ", @"ビ", @"ブ", @"ベ", @"ボ", @"パ", @"ピ", @"プ", @"ペ", @"ポ", @"マ", @"ミ", @"ム", @"メ", @"モ", @"ヤ", @"ユ", @"ヨ", @"ャ", @"ュ", @"ョ", @"ラ", @"リ", @"ル", @"レ", @"ロ", @"ワ", @"ヲ", @"ン", @"ヮ"];
    }
    return _katakanaPunctuations;
}

- (NSArray *)phoneticPunctuations
{
    if (_phoneticPunctuations == nil) {
        _phoneticPunctuations = @[@"ā", @"á", @"ǎ", @"à", @"ō", @"ó", @"ǒ", @"ò", @"ê", @"ē", @"é", @"ě", @"è", @"ī", @"í", @"ǐ", @"ì", @"ū", @"ú", @"ǔ", @"ù", @"ǖ", @"ǘ", @"ǚ", @"ǜ", @"ü", @"ㄅ", @"ㄉ", @"ㄓ", @"ㄚ", @"ㄞ", @"ㄢ", @"ㄦ", @"ㄆ", @"ㄊ", @"ㄍ", @"ㄐ", @"ㄔ", @"ㄗ", @"ㄧ", @"ㄛ", @"ㄟ", @"ㄣ", @"ㄇ", @"ㄋ", @"ㄎ", @"ㄑ", @"ㄕ", @"ㄘ", @"ㄨ", @"ㄜ", @"ㄠ", @"ㄤ", @"ㄈ", @"ㄏ", @"ㄒ", @"ㄖ", @"ㄙ", @"ㄩ", @"ㄝ", @"ㄡ", @"ㄥ"];
    }
    return _phoneticPunctuations;
}

- (NSArray *)radicalsPunctuations
{
    if (_radicalsPunctuations == nil) {
        _radicalsPunctuations = @[@"丨", @"亅", @"丿", @"乛", @"一", @"乙", @"丶", @"八", @"勹", @"匕", @"冫", @"卜", @"厂", @"刀", @"刂", @"儿", @"二", @"匚", @"丷", @"几", @"卩", @"冂", @"力", @"冖", @"凵", @"人", @"亻", @"入", @"十", @"厶", @"亠", @"讠", @"廴", @"又", @"艹", @"屮", @"彳", @"巛", @"川", @"辶", @"寸", @"大", @"飞", @"阝", @"干", @"工", @"弓", @"廾", @"广", @"己", @"彐", @"巾", @"釒", @"口", @"马", @"门", @"宀", @"女", @"犭", @"山", @"彡", @"尸", @"饣", @"士", @"扌", @"氵", @"纟", @"巳", @"土", @"囗", @"兀", @"夕", @"小", @"忄", @"幺", @"弋", @"尢", @"夂", @"子", @"贝", @"比", @"灬", @"长", @"车", @"歹", @"斗", @"厄", @"方", @"风", @"父", @"戈", @"卝", @"户", @"火", @"旡", @"见", @"斤", @"耂", @"毛", @"木", @"牛", @"牜", @"爿", @"片", @"攴", @"攵", @"气", @"欠", @"犬", @"日", @"氏", @"礻", @"手", @"殳", @"水", @"瓦", @"王", @"韦", @"文", @"无", @"毋", @"心", @"穴", @"牙", @"爻", @"曰", @"月", @"爫", @"支", @"止", @"爪", @"白", @"癶", @"甘", @"瓜", @"禾", @"彑", @"钅", @"立", @"龙", @"矛", @"皿", @"母", @"目", @"疒", @"鸟", @"皮", @"生", @"石", @"矢", @"示", @"罒", @"田", @"玄", @"疋", @"业", @"衤", @"用", @"玉", @"臣", @"虫", @"而", @"耳", @"缶", @"艮", @"虍", @"臼", @"老", @"耒", @"米", @"糸", @"齐", @"肉", @"色", @"舌", @"糹", @"网", @"西", @"覀", @"行", @"血", @"羊", @"页", @"衣", @"羽", @"聿", @"至", @"舟", @"竹", @"自", @"車", @"辰", @"赤", @"辵", @"豆", @"谷", @"龟", @"角", @"里", @"卤", @"麦", @"身", @"豕", @"辛", @"言", @"邑", @"酉", @"鱼", @"豸", @"走", @"足", @"采", @"齿", @"兒", @"非", @"阜", @"金", @"隶", @"門", @"黾", @"青", @"魚", @"雨", @"隹", @"革", @"骨", @"鬼", @"韭", @"面", @"飠", @"食", @"首", @"韋", @"香", @"音", @"髟", @"鬯", @"高", @"鬲", @"裏", @"馬", @"黄", @"鹿", @"麻", @"麥", @"鳥", @"鼻", @"廠", @"齒", @"鼎", @"鼓", @"黑", @"黽", @"黍", @"鼠", @"黹", @"幹", @"龠", @"齊", @"龍"];
    }
    return _radicalsPunctuations;
}

- (NSArray *)tabulationPunctuations
{
    if (_tabulationPunctuations == nil) {
        _tabulationPunctuations = @[@"┌", @"┍", @"┎", @"┏", @"┐", @"┑", @"┒", @"┓", @"─", @"┄", @"┈", @"├", @"┝", @"┞", @"┟", @"┠", @"┡", @"┢", @"┣", @"│", @"┆", @"┊", @"┬", @"┭", @"┮", @"┯", @"┰", @"┱", @"┲", @"┳", @"┼", @"┽", @"┾", @"┿", @"╀", @"╁", @"╂", @"└", @"┕", @"┖", @"┗", @"┘", @"┙", @"┚", @"┛", @"━", @"┅", @"┉", @"┤", @"┥", @"┦", @"┧", @"┨", @"┩", @"┪", @"┫", @"┴", @"┵", @"┶", @"┷", @"┸", @"┹", @"┺", @"┻", @"╄", @"╅", @"╆", @"╇", @"╈", @"╉", @"╊", @"╋"];
    }
    return _tabulationPunctuations;
}

@end
