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

#ifndef dispatch_queue_async_safe
#define dispatch_queue_async_safe(queue, block)\
if (strcmp(dispatch_queue_get_label(DISPATCH_CURRENT_QUEUE_LABEL), dispatch_queue_get_label(queue)) == 0) {\
    block();\
} else {\
    dispatch_async(queue, block);\
}
#endif

#ifndef dispatch_main_async_safe
#define dispatch_main_async_safe(block) dispatch_queue_async_safe(dispatch_get_main_queue(), block)
#endif

