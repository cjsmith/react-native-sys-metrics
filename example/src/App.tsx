import * as React from 'react';

import { StyleSheet, View, Text } from 'react-native';
import { reportCPUMetrics, SysMetrics } from 'react-native-sys-metrics';

export default function App() {
  const [result, setResult] = React.useState<SysMetrics | undefined>();

  React.useEffect(() => {
    reportCPUMetrics(setResult);
  }, []);

  return (
    <View style={styles.container}>
      <Text>Result: {JSON.stringify(result)}</Text>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
  },
  box: {
    width: 60,
    height: 60,
    marginVertical: 20,
  },
});
