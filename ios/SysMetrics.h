
#ifdef RCT_NEW_ARCH_ENABLED
#import "RNSysMetricsSpec.h"

@interface SysMetrics : NSObject <NativeSysMetricsSpec>
#else
#import <React/RCTBridgeModule.h>

@interface SysMetrics : NSObject <RCTBridgeModule>
#endif

@end
