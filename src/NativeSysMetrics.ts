import type { TurboModule } from 'react-native';
import { TurboModuleRegistry } from 'react-native';
import type { SysMetrics } from 'react-native-sys-metrics';

export interface Spec extends TurboModule {
  reportCPUMetrics(callback: (metrics: SysMetrics) => void): void;
}

export default TurboModuleRegistry.getEnforcing<Spec>('SysMetrics');
