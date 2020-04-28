import 'package:pip_services3_commons/pip_services3_commons.dart';
import 'package:pip_services3_components/pip_services3_components.dart';

import 'package:pip_services3_prometheus/pip_services3_prometheus.dart';

void main() async {
  var restConfig = ConfigParams.fromTuples([
    'connection.protocol',
    'http',
    'connection.host',
    'localhost',
    'connection.port',
    3000
  ]);

  PrometheusMetricsService service;
  PrometheusCounters counters;
 
  service = PrometheusMetricsService();
  counters = PrometheusCounters();

  service.configure(restConfig);

  var contextInfo = ContextInfo();
  contextInfo.name = 'Test';
  contextInfo.description = 'This is a test container';

  var references = References.fromTuples([
    Descriptor('pip-services', 'context-info', 'default', 'default', '1.0'),
    contextInfo,
    Descriptor('pip-services', 'counters', 'prometheus', 'default', '1.0'),
    counters,
    Descriptor(
        'pip-services', 'metrics-service', 'prometheus', 'default', '1.0'),
    service
  ]);
  counters.setReferences(references);
  service.setReferences(references);

  await counters.open(null);
  await service.open(null);

  counters.incrementOne('test.counter1');
  counters.stats('test.counter2', 2);
  counters.last('test.counter3', 3);
  counters.timestampNow('test.counter4');

  // all metrics accessable on http://localhost:3000/metrics
  // configure the Prometheus service to poll this host
  // ...

  await service.close(null);
  await counters.close(null);
}
