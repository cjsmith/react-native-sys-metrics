import { type TurboModule, TurboModuleRegistry } from 'react-native';
export interface Spec extends TurboModule {
  addListener: (eventType: string) => void;
}

export default TurboModuleRegistry.getEnforcing<Spec>('SysMetrics');
