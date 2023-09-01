
#ifdef RCT_NEW_ARCH_ENABLED
#import "RNSysMetricsSpec.h"

@interface SysMetrics : NSObject <NativeSysMetricsSpec>
#else
#import <React/RCTBridgeModule.h>
#import <React/RCTEventEmitter.h>


@interface SysMetrics : RCTEventEmitter <RCTBridgeModule>
#endif

@end
