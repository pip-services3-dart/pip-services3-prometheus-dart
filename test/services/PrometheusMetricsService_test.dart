import 'package:test/test.dart';
import 'package:http/http.dart' as http;
import 'package:pip_services3_commons/pip_services3_commons.dart';
import 'package:pip_services3_components/pip_services3_components.dart';

import 'package:pip_services3_prometheus/pip_services3_prometheus.dart';

void main() {
  var restConfig = ConfigParams.fromTuples([
    'connection.protocol',
    'http',
    'connection.host',
    'localhost',
    'connection.port',
    3000
  ]);

  group('PrometheusMetricsService', () {
    late PrometheusMetricsService service;
    late PrometheusCounters counters;
    late http.Client rest;
    var url;

    setUpAll(() async {
      service = PrometheusMetricsService();
      counters = PrometheusCounters();

      service.configure(restConfig);
      //counters.configure(restConfig);

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

      url = 'http://localhost:3000';
      rest = http.Client();

      await counters.open(null);
      await service.open(null);
    });

    tearDownAll(() async {
      await service.close(null);
      await counters.close(null);
    });

    test('Metrics', () async {
      counters.incrementOne('test.counter1');
      counters.stats('test.counter2', 2);
      counters.last('test.counter3', 3);
      counters.timestampNow('test.counter4');

      var result = await rest.get(Uri.parse(url + '/metrics'));

      expect(result, isNotNull);
      expect(result.statusCode < 400, isTrue);
      expect(result.body.isNotEmpty, isTrue);
    });

    test('MetricsAndReset', () async {
      counters.incrementOne('test.counter1');
      counters.stats('test.counter2', 2);
      counters.last('test.counter3', 3);
      counters.timestampNow('test.counter4');

      var result = await rest.get(Uri.parse(url + '/metricsandreset'));

      expect(result, isNotNull);
      expect(result.statusCode < 400, isTrue);
      expect(result.body.isNotEmpty, isTrue);

      var counter1 = counters.get('test.counter1', CounterType.Increment);
      var counter2 = counters.get('test.counter2', CounterType.Statistics);
      var counter3 = counters.get('test.counter3', CounterType.LastValue);
      var counter4 = counters.get('test.counter4', CounterType.Timestamp);

      expect(counter1.count, isNull);
      expect(counter2.count, isNull);
      expect(counter3.last, isNull);
      expect(counter4.time, isNull);
    });
  });
}
