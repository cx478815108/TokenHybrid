//
//  TokenHybridOrganizer.m
//  TokenHybrid
//
//  Created by 陈雄 on 2017/11/8.
//  Copyright © 2017年 com.feelings. All rights reserved.
//

#import "TokenHybridOrganizer.h"
#import "TokenNodeComponentRegister.h"

@interface TokenHybridOrganizer()
@property(nonatomic ,strong) NSUserDefaults *pageManagerDefaults;
@end

@implementation TokenHybridOrganizer

+(TokenHybridOrganizer *)sharedOrganizer{
    static TokenHybridOrganizer *obj;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        obj = [[TokenHybridOrganizer alloc] init];
    });
    return obj;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.nodeComponentRegister = [[TokenNodeComponentRegister alloc] init];
        [self.nodeComponentRegister registDefault];
    }
    return self;
}

-(void)addPageDefaultWithSuiteName:(NSString *)name{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        if (name == nil || name.length == 0) {
            return;
        }
        NSData *registedDefaultSetData = [[NSUserDefaults standardUserDefaults] objectForKey:@"TokenHybridRegistedDefaults"];
        NSSet *oldSet                  = registedDefaultSetData?[NSKeyedUnarchiver unarchiveObjectWithData:registedDefaultSetData]:nil;
        NSMutableSet *set              = oldSet?[NSMutableSet setWithSet:oldSet]:[NSMutableSet set];
        [set addObject:name];
        NSData *setData                = [NSKeyedArchiver archivedDataWithRootObject:set];
        [[NSUserDefaults standardUserDefaults] setObject:setData forKey:@"TokenHybridRegistedDefaults"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    });
}

-(void)clearAllPageDefaultsData{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSData *registedDefaultSetData = [[NSUserDefaults standardUserDefaults] objectForKey:@"TokenHybridRegistedDefaults"];
        NSSet *oldSet = registedDefaultSetData?[NSKeyedUnarchiver unarchiveObjectWithData:registedDefaultSetData]:nil;
        [oldSet enumerateObjectsUsingBlock:^(NSString  *_Nonnull obj, BOOL * _Nonnull stop) {
            [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:obj];
        }];
        [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:@"com.token.globleDefaultes"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    });
}
@end
