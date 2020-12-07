import 'package:pip_services3_components/pip_services3_components.dart';
import 'package:pip_services3_commons/pip_services3_commons.dart';

import '../count/PrometheusCounters.dart';
import '../services/PrometheusMetricsService.dart';

/// Creates Prometheus components by their descriptors.
///
/// See [Factory](https://pub.dev/documentation/pip_services3_components/latest/pip_services3_components/Factory-class.html)
/// See [PrometheusCounters]
/// See [PrometheusMetricsService]
class DefaultPrometheusFactory extends Factory {
  static final descriptor =
      Descriptor('pip-services', 'factory', 'prometheus', 'default', '1.0');
  static final PrometheusCountersDescriptor =
      Descriptor('pip-services', 'counters', 'prometheus', '*', '1.0');
  static final PrometheusMetricsServiceDescriptor =
      Descriptor('pip-services', 'metrics-service', 'prometheus', '*', '1.0');

  /// Create a new instance of the factory.
  DefaultPrometheusFactory() : super() {
    registerAsType(DefaultPrometheusFactory.PrometheusCountersDescriptor,
        PrometheusCounters);
    registerAsType(DefaultPrometheusFactory.PrometheusMetricsServiceDescriptor,
        PrometheusMetricsService);
  }
}
