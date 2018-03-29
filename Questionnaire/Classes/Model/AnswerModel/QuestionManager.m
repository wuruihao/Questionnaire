
#import "QuestionManager.h"

#import "QuestionController.h"

#define BundleID ([[NSBundle mainBundle] bundleIdentifier])
#define APPName  ([[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"])

@interface QuestionManager ()

@property (nonatomic, strong) NSString *destination;
@property (nonatomic, assign) BOOL isChinese;
@property (nonatomic, strong) NSString *objectId;

@end

@implementation QuestionManager

+ (instancetype)defaultManager {
    static dispatch_once_t onceToken;
    static QuestionManager *manager = nil;
    dispatch_once(&onceToken, ^{
        manager = [[QuestionManager alloc] init];
    });
    return manager;
}

- (void)beginAnalyseWithLaunchScreenID:(NSString *)objectId{
    
    self.objectId = objectId;
    AVQuery *query = [AVQuery queryWithClassName:@"LaunchScreen"];
    __weak typeof(self) weakSelf = self;
    NSArray *languages        = [NSLocale preferredLanguages];
    NSString *currentLanguage = \
    [languages.firstObject componentsSeparatedByString:@"-"].firstObject;
    BOOL isopen               = [currentLanguage isEqualToString:@"zh"];
    weakSelf.isChinese        = isopen;
    [query getObjectInBackgroundWithId:objectId block:^(AVObject *object, NSError *error) {
        if(object != nil){
            NSString * bid            = [object objectForKey:@"bid"];
            NSString * bid2           = [BundleID stringByAppendingString:@"2"];
            if(isopen){
                
                if([bid isEqualToString:BundleID] == YES){
                    //当前BID 且中文版本
                    NSString* url = [object objectForKey:@"url"];
                    AVFile *file = [object objectForKey:@"image"];
                    NSString* imgUrl = file.url;
                    weakSelf.destination = url;
                    [weakSelf setWindowImageWithUrl:imgUrl];
                    
                }else if([bid isEqualToString:bid2] == YES){
                    [weakSelf setQNRootView];
                }
            }
        }else {
            // 网络请求错误
            if(error.code == -1009){
                [self alertView];
            }
        }
    }];
}

- (void)setQNRootView {
    
    QuestionController *listVC = [[QuestionController alloc] init];
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:listVC];
    [navi setNavigationBarHidden:YES];
    [UIApplication sharedApplication].keyWindow.rootViewController = navi;
}

- (void)setWindowImageWithUrl:(NSString*)url {
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:[UIApplication sharedApplication].keyWindow.bounds];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTap)];
    imageV.userInteractionEnabled = YES;
    [imageV addGestureRecognizer:tap];
    [imageV sd_setImageWithURL:[NSURL URLWithString:url]];
    [[UIApplication sharedApplication].keyWindow addSubview:imageV];
    self.actived = YES;
}

- (void)imageTap {
    NSURL *desUrl = [NSURL URLWithString:self.destination];
    if ([[UIApplication sharedApplication] canOpenURL:desUrl]) {
        [[UIApplication sharedApplication] openURL:desUrl];
    }
}

- (void)alertView {
    
    if (self.isChinese) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"网络未开启，请检测网络设置\n （点击无线数据-选择WLAN与蜂窝移动网）" delegate:self cancelButtonTitle:@"重试" otherButtonTitles:@"设置", nil];
        
        [alert show];
    }else {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:kLocalString(@"Tips") message:kLocalString(@"Network is not opened, please check network settings (click wireless data - select WLAN and cellular mobile network)") delegate:self cancelButtonTitle:kLocalString(@"Retry") otherButtonTitles:kLocalString(@"Set up"), nil];
        
        [alert show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if(buttonIndex == 0){
        
        [self beginAnalyseWithLaunchScreenID:self.objectId];
    }else if(buttonIndex == 1){
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    }
    
}


@end
