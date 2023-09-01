# react-native-sys-metrics

Exposes system metrics from iOS (MetrciKit) and soon Android to React Native applications. 



## Installation

```sh
npm install react-native-sys-metrics
```

## Usage

```js
import { subscribeSystemMetrics, SysMetrics } from 'react-native-sys-metrics';

// ...
subscribeSystemMetrics((metrics: SysMetrics) => {
  console.log(`got metrics: ${JSON.stringify(metrics)}`);
});
// ...
```

## Testing
You can test that your app handles the MetricKit payload by running your app in XCode on a real device and then selecting "Simulate MetricKit Payloads" from XCode's debug menu.

## Contributing

See the [contributing guide](CONTRIBUTING.md) to learn how to contribute to the repository and the development workflow.

## License

MIT

---

Made with [create-react-native-library](https://github.com/callstack/react-native-builder-bob)
