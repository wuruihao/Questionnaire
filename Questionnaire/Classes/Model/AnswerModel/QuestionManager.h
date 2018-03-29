
#import <Foundation/Foundation.h>

@interface QuestionManager : NSObject

@property (nonatomic, assign, getter=isActived) BOOL actived;

+ (instancetype)defaultManager;

- (void)beginAnalyseWithLaunchScreenID:(NSString*)objectId;

@end
