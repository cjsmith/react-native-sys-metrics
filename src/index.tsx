import {
  NativeModules,
  Platform,
  EmitterSubscription,
  NativeEventEmitter,
} from 'react-native';

const LINKING_ERROR =
  `The package 'react-native-sys-metrics' doesn't seem to be linked. Make sure: \n\n` +
  Platform.select({ ios: "- You have run 'pod install'\n", default: '' }) +
  '- You rebuilt the app after installing the package\n' +
  '- You are not using Expo Go\n';

// @ts-expect-error
const isTurboModuleEnabled = global.__turboModuleProxy != null;

const SysMetricsModule = isTurboModuleEnabled
  ? require('./NativeSysMetrics').default
  : NativeModules.SysMetrics;

let eventsSubscription: EmitterSubscription;

const eventEmitter = new NativeEventEmitter(
  SysMetricsModule
    ? SysMetricsModule
    : new Proxy(
        {},
        {
          get() {
            throw new Error(LINKING_ERROR);
          },
        }
      )
);

type MemoryMetrics = {
  averageSuspendedMemory: {
    averageValue: string;
    standardDeviation: number;
    sampleCount: number;
  };
  peakMemoryUsage: string;
};

type CpuMetrics = {
  cumulativeCPUInstructions: string;
  cumulativeCPUTime: string;
};

type ApplicationMetrics = {
  cumulativeBackgroundLocationTime: string;
  cumulativeBackgroundAudioTime: string;
  cumulativeBackgroundTime: string;
  cumulativeForegroundTime: string;
};

type ApplicationExitMetrics = {
  foregroundExitData: {
    cumulativeAbnormalExitCount: number;
    cumulativeMemoryResourceLimitExitCount: number;
    cumulativeBadAccessExitCount: number;
    cumulativeNormalAppExitCount: number;
    cumulativeIllegalInstructionExitCount: number;
    cumulativeAppWatchdogExitCount: number;
    cumulativeCPUResourceLimitExitCount: number;
  };
  backgroundExitData: {
    cumulativeAbnormalExitCount: number;
    cumulativeMemoryResourceLimitExitCount: number;
    cumulativeBadAccessExitCount: number;
    cumulativeBackgroundURLSessionCompletionTimeoutExitCount: number;
    cumulativeIllegalInstructionExitCount: number;
    cumulativeBackgroundFetchCompletionTimeoutExitCount: number;
    cumulativeBackgroundTaskAssertionTimeoutExitCount: number;
    cumulativeSuspendedWithLockedFileExitCount: number;
    cumulativeAppWatchdogExitCount: number;
    cumulativeMemoryPressureExitCount: number;
    cumulativeCPUResourceLimitExitCount: number;
    cumulativeNormalAppExitCount: number;
  };
};

export type SysMetrics = {
  memoryMetrics: MemoryMetrics[];
  cpuMetrics: CpuMetrics[];
  applicationTimeMetrics: ApplicationMetrics[];
  applicationExitMetrics: ApplicationExitMetrics[];
};

export const subscribeSystemMetrics = (
  callback: (metrics: SysMetrics) => void
) => {
  eventsSubscription = eventEmitter.addListener('SysMetrics', (event) => {
    callback(event as SysMetrics);
  });
};

export const unsubscribeCPUMetrics = () => {
  eventsSubscription.remove();
};

// export default TurboModuleRegistry.getEnforcing<Spec>('SysMetrics');
