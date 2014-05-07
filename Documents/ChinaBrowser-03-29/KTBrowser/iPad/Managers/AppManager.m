//
//  AppManager.m
//

#import "AppManager.h"

#define kSearchTypeNameDefault  @"网页"

#define kSkinCurrentKey @"kSkinCurrentKey"
#define kScreenLocked @"kScreenLocked"
#define kStealthMode  @"kStealthMode"
#define kNoImgMode    @"kNoImgMode"
#define kBrightness   @"kBrightness"
#define kFontAdjust   @"kFontAdjust"

@interface AppManager ()

// 隐身模式
@property (nonatomic, assign) BOOL stealthMode;
// 屏幕锁定
@property (nonatomic, assign) BOOL screenLocked;
// 无图模式
@property (nonatomic, assign) BOOL noImgMode;
// 屏幕亮度
@property (nonatomic, assign) CGFloat brightness;
// 网页字体大小
@property (nonatomic, assign) CGFloat fontAdjust;

@end

@implementation AppManager

UIImage * getFolderImageWithName(NSString *imgName, NSString *folder) {
    NSString *bundlePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:folder];
    NSString *imgPath = [bundlePath stringByAppendingPathComponent:[imgName stringByAppendingString:@".png"]];
    
    return [UIImage imageWithContentsOfFile:imgPath];
}

+ (ControllerRoot_ipad *)vcRoot {
    static ControllerRoot_ipad *vcRoot = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        vcRoot = [[ControllerRoot_ipad alloc] init];
    });
    
    return vcRoot;
}

// topbar folder file
UIImage * getTopBarImageWithName(NSString *imgName) {
    return getFolderImageWithName(imgName, @"UrlBar");
}

// menu folder file
UIImage * getMenuImageWithName(NSString *imgName) {
    return getFolderImageWithName(imgName, @"Menu");
}

- (id)init {
    if (self = [super init]) {
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        if(![ud objectForKey:kScreenLocked]) {
            [ud setObject:[NSNumber numberWithBool:NO] forKey:kScreenLocked];
            [ud setObject:[NSNumber numberWithBool:NO] forKey:kStealthMode];
            [ud setObject:[NSNumber numberWithBool:NO] forKey:kNoImgMode];
            [ud setObject:[NSNumber numberWithFloat:1.0] forKey:kBrightness];
            [ud setObject:[NSNumber numberWithFloat:1.0] forKey:kFontAdjust];
            [ud synchronize];
        }
        
        _stealthMode = [[ud objectForKey:kStealthMode] boolValue];
        _screenLocked = [[ud objectForKey:kScreenLocked] boolValue];
        _noImgMode = [[ud objectForKey:kNoImgMode] boolValue];
        _brightness = [[ud objectForKey:kBrightness] floatValue];
        _fontAdjust = [[ud objectForKey:kFontAdjust] floatValue];
    }
    
    return self;
}

+ (AppManager *)instance {
    static AppManager *instance;
    if (!instance) {
        instance = [[AppManager alloc] init];
    }

    return instance;
}

// 隐身模式
+ (BOOL)stealthMode {
    return [self instance].stealthMode;
}

- (void)toggleStealthMode {
    _stealthMode = !_stealthMode;
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:[NSNumber numberWithBool:_stealthMode] forKey:kStealthMode];
    [ud synchronize];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotifStealthModeChanged object:[NSNumber numberWithBool:_stealthMode]];
}

+ (void)changeStealthMode {
    return [[self instance] toggleStealthMode];
}

// 屏幕锁定
+ (BOOL)screenLocked {
    return [self instance].screenLocked;
}

- (void)toggleScreenLocked {
    _screenLocked = !_screenLocked;
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:[NSNumber numberWithBool:_screenLocked] forKey:kScreenLocked];
    [ud synchronize];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotifScreenLockChanged object:[NSNumber numberWithBool:_screenLocked]];
}

+ (void)changeScreenLocked {
    return [[self instance] toggleScreenLocked];
}

// 无图模式
+ (BOOL)noImgMode {
    return [self instance].noImgMode;
}

- (void)toggleNoImgMode {
    _noImgMode = !_noImgMode;
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:[NSNumber numberWithBool:_noImgMode] forKey:kNoImgMode];
    [ud synchronize];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotifScreenLockChanged object:[NSNumber numberWithBool:_noImgMode]];
}

+ (void)changeNoImgMode {
    return [[self instance] toggleNoImgMode];
}

// 屏幕亮度
+ (CGFloat)brightness {
    return [self instance].brightness;
}

- (void)setBrightness:(CGFloat)brightness {
    _brightness = brightness;
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:[NSNumber numberWithFloat:_brightness] forKey:kBrightness];
    [ud synchronize];

    [[NSNotificationCenter defaultCenter] postNotificationName:kNotifBrightnessChanged object:[NSNumber numberWithFloat:_brightness]];
}

+ (void)changeBrightness:(CGFloat)brightness {
    [[self instance] setBrightness:brightness];
}

// 字体大小
+ (CGFloat)fontAdjust {
    return [self instance].fontAdjust;
}

- (void)setFontAdjust:(CGFloat)fontAdjust {
    _fontAdjust = fontAdjust;
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:[NSNumber numberWithFloat:_fontAdjust] forKey:kFontAdjust];
    [ud synchronize];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotifFontSizeChanged object:[NSNumber numberWithFloat:_fontAdjust]];
}

+ (void)changeFontAdjust:(CGFloat)fontAdjust {
    [[self instance] setFontAdjust:fontAdjust];
}

// 主页快捷链接项
+ (NSArray *)homeSites {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSArray *arrHomeItems = [ud objectForKey:kHomeSites];
    if (!arrHomeItems) {
        arrHomeItems = [NSArray arrayWithContentsOfFile:[[NSBundle bundleWithPath:kBundlePathWithName(@"home_ipad")] pathForResource:@"home_default" ofType:@"plist"]];
        
        [self setHomeSitesWithArray:arrHomeItems];
    }
    
    return arrHomeItems;
}

+ (void)setHomeSitesWithArray:(NSArray *)array {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:array forKey:kHomeSites];
    [ud synchronize];
}

// 顶端搜索选项
+ (NSArray *)topSearchItems {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSArray *arrSearchItems = [ud objectForKey:kTopSearchItems];
    if (!arrSearchItems) {
        NSArray *arrData = [self homeSearchItems];
        if (![arrData isKindOfClass:[NSArray class]]) {
            return nil;
        }
        
        for (NSDictionary *dic in arrData) {
            if (![dic isKindOfClass:[NSDictionary class]]) {
                continue;
            }
            
            NSString *typeName = [dic objectForKey:@"name"];
            if ([kSearchTypeNameDefault compare:typeName]==NSOrderedSame) {
                NSArray *arrItems = [dic objectForKey:@"item"];
                if (![arrItems isKindOfClass:[NSArray class]]) {
                    break;
                }
                
                arrSearchItems = arrItems;
                [ud setObject:arrSearchItems forKey:kTopSearchItems];
                [ud synchronize];
                
                break;
            }
        }
    }
    
    return arrSearchItems;
}

// 主页搜索选项
+ (NSArray *)homeSearchItems {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSArray *arrSearchItems = [ud objectForKey:kHomeSearchItems];
    if (!arrSearchItems) {
        arrSearchItems = [NSArray arrayWithContentsOfFile:[[NSBundle bundleWithPath:kBundlePathWithName(@"search_ipad")] pathForResource:@"search_option" ofType:@"plist"]];
        
        [ud setObject:arrSearchItems forKey:kHomeSearchItems];
        [ud synchronize];
    }
    
    return arrSearchItems;
}

// 皮肤
+ (void)setSkinImages:(NSDictionary *)dicSkin {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:dicSkin forKey:kSkinItems];
    [ud synchronize];
}

+ (NSDictionary *)getSkinImages:(BOOL)toImage {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSDictionary *dicSkinImages = [ud objectForKey:kSkinItems];
    
    if (!dicSkinImages) {
        UIImage *img0 = BundleImageForHome(@"bg-0-bai", @"jpg");
        UIImage *img1 = BundleImageForHome(@"bg-0-ye", @"jpg");
        
        dicSkinImages = @{@"1":UIImageJPEGRepresentation(img1, 1.0),
                                  @"0":UIImageJPEGRepresentation(img0, 1.0)};
        [self setSkinImages:dicSkinImages];
    }
    
    if (toImage) {
        NSMutableDictionary *dicTmp = [NSMutableDictionary dictionaryWithDictionary:dicSkinImages];
        for (NSString *key in dicSkinImages.allKeys) {
            UIImage *img = [UIImage imageWithData:dicSkinImages[key]];
            [dicTmp setValue:img forKey:key];
        }
        
        return dicTmp;
    }
    
    return dicSkinImages;
}

+ (NSDictionary *)skinImages {
    return [self getSkinImages:YES];
}

+ (NSString *)currentSkinKey {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *skinKey = [ud objectForKey:kSkinCurrentKey];
    if (!skinKey) {
        skinKey = @"0";
        [self setCurrentSkinKey:skinKey];
    }
    
    return skinKey;
}

+ (void)setCurrentSkinKey:(NSString *)key {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:key forKey:kSkinCurrentKey];
    [ud synchronize];
}

+ (UIImage *)currentSkin {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    UIImage *skin = [ud objectForKey:kSkinCurrent];
    if (!skin) {
        skin = BundleImageForHome(@"bg-0-bai", @"jpg");
        NSData *imgData = UIImageJPEGRepresentation(skin, 1.0);
        
        [ud setObject:imgData forKey:kSkinCurrent];
        [ud synchronize];
    }
    
    if ([skin isKindOfClass:[NSData class]]) {
        skin = [UIImage imageWithData:(NSData *)skin];
    }
    
    return skin;
}

+ (void)setCurrentSkin:(UIImage *)skin {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSData *imgData = UIImageJPEGRepresentation(skin, 1.0);
    [ud setObject:imgData forKey:kSkinCurrent];
    [ud synchronize];
}

/**
 * return skin key;
 */
+ (NSString *)addSkin:(UIImage *)skin {
    NSMutableDictionary *dicSkin = [[NSMutableDictionary alloc] initWithDictionary:[self getSkinImages:NO]];
    NSData *imgData = UIImageJPEGRepresentation(skin, 1.0);
    
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    fmt.dateFormat = @"yyyyMMddHHmmss";
    NSString *key = [fmt stringFromDate:[NSDate date]];
    
    [dicSkin setObject:imgData forKey:key];

    [self setSkinImages:dicSkin];
    
    return key;
}

+ (void)removeSkinForKey:(NSString *)key {
    NSMutableDictionary *dicSkin = [[NSMutableDictionary alloc] initWithDictionary:[self getSkinImages:NO]];
    [dicSkin removeObjectForKey:key];
    
    [self setSkinImages:dicSkin];
}

@end