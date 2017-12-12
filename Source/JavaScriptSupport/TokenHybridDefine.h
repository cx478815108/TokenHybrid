//
//  TokenHybridDefine.h
//  TokenHybrid
//
//  Created by 陈雄 on 2017/11/8.
//  Copyright © 2017年 com.feelings. All rights reserved.
//

#ifdef DEBUG // 调试状态, 打开LOG功能
#define HybridLog(...) NSLog(__VA_ARGS__)
#else // 发布状态, 关闭LOG功能
#define HybridLog(...)
#endif

