# react-native-sys-metrics

Exposes system metrics from iOS (MetrciKit) and soon Android to React Native applications. 



## Installation

```sh
npm install react-native-sys-metrics
```

## Usage

```js
import { reportCPUMetrics, SysMetrics } from 'react-native-sys-metrics';

// ...
reportCPUMetrics((metrics: SysMetrics) => {
  console.log(`got metrics: ${JSON.stringify(metrics)}`);
});
// ...
```

## Contributing

See the [contributing guide](CONTRIBUTING.md) to learn how to contribute to the repository and the development workflow.

## License

MIT

---

Made with [create-react-native-library](https://github.com/callstack/react-native-builder-bob)
