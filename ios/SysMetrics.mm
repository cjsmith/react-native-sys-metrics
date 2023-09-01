#import "SysMetrics.h"
#import <MetricKit/MetricKit.h>
#import <Foundation/Foundation.h>

@interface SysMetrics() <MXMetricManagerSubscriber>

@property (nonatomic, strong) MXMetricManager *metricManager;
@property (nonatomic, strong) NSMutableArray<MXCPUMetric *> *cpuMetrics;
@property (nonatomic, strong) NSMutableArray<MXAppExitMetric *> *applicationExitMetrics;
@property (nonatomic, strong) NSMutableArray<MXAppRunTimeMetric *> *applicationTimeMetrics;
@property (nonatomic, strong) NSMutableArray<MXMemoryMetric *> *memoryMetrics;
@end


@interface NSArray (Map)

- (NSArray *)mapObjectsUsingBlock:(id (^)(id obj, NSUInteger idx))block;

@end

@implementation NSArray (Map)

- (NSArray *)mapObjectsUsingBlock:(id (^)(id obj, NSUInteger idx))block {
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:[self count]];
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [result addObject:block(obj, idx)];
    }];
    return result;
}

@end

@implementation SysMetrics
{
  bool hasListeners;
}

RCT_EXPORT_MODULE();

- (void)subscribeToMetrics {
    self->_metricManager = [MXMetricManager sharedManager];
    [self->_metricManager addSubscriber:self];
    [self didReceiveMetricPayloads:[self->_metricManager pastPayloads]];
}

- (void)unsubscribeFromMetrics {
    [self->_metricManager removeSubscriber:self];
}

// Will be called when this module's first listener is added.
-(void)startObserving {
    hasListeners = YES;
    self->_cpuMetrics = [[NSMutableArray alloc] init];
    self->_applicationExitMetrics = [[NSMutableArray alloc] init];
    self->_applicationTimeMetrics = [[NSMutableArray alloc] init];
    self->_memoryMetrics = [[NSMutableArray alloc] init];
    [self subscribeToMetrics];
    // Set up any upstream listeners or background tasks as necessary
}

// Will be called when this module's last listener is removed, or on dealloc.
-(void)stopObserving {
    hasListeners = NO;
    [self unsubscribeFromMetrics];
    // Remove upstream listeners, stop unnecessary background tasks
}

- (NSArray<NSString *> *)supportedEvents
{
  return @[ @"SysMetrics" ];
}

- (void)didReceiveMetricPayloads:(NSArray<MXMetricPayload *> *)payloads {
    [self->_cpuMetrics removeAllObjects];
    [self->_applicationExitMetrics removeAllObjects];
    [self->_applicationTimeMetrics removeAllObjects];
    [self->_memoryMetrics removeAllObjects];

    for (MXMetricPayload *payload in payloads) {
        MXCPUMetric *cpuMetric = payload.cpuMetrics;
        if (cpuMetric) {
            [self->_cpuMetrics addObject:cpuMetric];
        }
        MXAppExitMetric *applicationExitMetrics = payload.applicationExitMetrics;
        if (applicationExitMetrics) {
            [self->_applicationExitMetrics addObject:applicationExitMetrics];
        }
        MXAppRunTimeMetric *applicationTimeMetrics = payload.applicationTimeMetrics;
        if (applicationTimeMetrics) {
            [self->_applicationTimeMetrics addObject:applicationTimeMetrics];
        }
        MXMemoryMetric *memoryMetrics = payload.memoryMetrics;
        if (memoryMetrics) {
            [self->_memoryMetrics addObject:memoryMetrics];
        }
    }
    

    if (hasListeners) { 
        NSMutableDictionary *metrics = [NSMutableDictionary dictionary];
        metrics[@"cpuMetrics"] = [self->_cpuMetrics mapObjectsUsingBlock:^(id obj, NSUInteger idx) {
            return ((MXMetric *)obj).dictionaryRepresentation;
        }];
        metrics[@"applicationExitMetrics"] = [self->_applicationExitMetrics mapObjectsUsingBlock:^(id obj, NSUInteger idx) {
            return ((MXMetric *)obj).dictionaryRepresentation;
        }];
        metrics[@"applicationTimeMetrics"] = [self->_applicationTimeMetrics mapObjectsUsingBlock:^(id obj, NSUInteger idx) {
            return ((MXMetric *)obj).dictionaryRepresentation;
        }];
        metrics[@"memoryMetrics"] = [self->_memoryMetrics mapObjectsUsingBlock:^(id obj, NSUInteger idx) {
            return ((MXMetric *)obj).dictionaryRepresentation;
        }];
        [self sendEventWithName:@"SysMetrics" body:metrics];
    }
    
}

// Don't compile this code when we build for the old architecture.
#ifdef RCT_NEW_ARCH_ENABLED
- (std::shared_ptr<facebook::react::TurboModule>)getTurboModule:
    (const facebook::react::ObjCTurboModule::InitParams &)params
{
    return std::make_shared<facebook::react::NativeSysMetricsSpecJSI>(params);
}
#endif

@end
