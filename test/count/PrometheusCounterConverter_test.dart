import 'package:test/test.dart';
import 'package:pip_services3_components/pip_services3_components.dart';
import 'package:pip_services3_commons/pip_services3_commons.dart';

import 'package:pip_services3_prometheus/pip_services3_prometheus.dart';

void main() {
  group('PrometheusCounterConverter', () {
    test('KnownCounter_Exec_ServiceMetrics_Good', () {
      const knownCounterExecServiceMetricsGoodTestCases = [
        {
          'counterName': 'MyService1.MyCommand1.exec_count',
          'expectedName': 'exec_count'
        },
        {
          'counterName': 'MyService1.MyCommand1.exec_time',
          'expectedName': 'exec_time'
        },
        {
          'counterName': 'MyService1.MyCommand1.exec_errors',
          'expectedName': 'exec_errors'
        }
      ];

      for (var i = 0;
          i < knownCounterExecServiceMetricsGoodTestCases.length;
          i++) {
        var testData = knownCounterExecServiceMetricsGoodTestCases[i];
        final counterName = testData['counterName']!;
        final expectedName = testData['expectedName'];

        var counters = <Counter>[];

        var counter1 = Counter(counterName, CounterType.Increment);
        counter1.count = 1;
        counter1.time = RandomDateTime.nextDateTime(DateTime.now().toUtc());
        counters.add(counter1);

        var counter2 = Counter(counterName, CounterType.Interval);
        counter2.count = 11;
        counter2.max = 13;
        counter2.min = 3;
        counter2.average = 3.5;
        counter2.time = RandomDateTime.nextDateTime(DateTime.now().toUtc());
        counters.add(counter2);

        var counter3 = Counter(counterName, CounterType.LastValue);
        counter3.last = 2;
        counter3.time = RandomDateTime.nextDateTime(DateTime.now().toUtc());
        counters.add(counter3);

        var counter4 = Counter(counterName, CounterType.Statistics);
        counter4.count = 111;
        counter4.max = 113;
        counter4.min = 13;
        counter4.average = 13.5;
        counter4.time = RandomDateTime.nextDateTime(DateTime.now().toUtc());
        counters.add(counter4);

        var body = PrometheusCounterConverter.toString2(
            counters, 'MyApp', 'MyInstance');

        var expected = '# TYPE $expectedName gauge\n$expectedName{source=\"MyApp\",instance=\"MyInstance\",service=\"MyService1\",command=\"MyCommand1\"} 1\n' +
            ('# TYPE ${expectedName}_max gauge\n${expectedName}_max{source=\"MyApp\",instance=\"MyInstance\",service=\"MyService1\",command=\"MyCommand1\"} 13\n') +
            '# TYPE ${expectedName}_min gauge\n${expectedName}_min{source=\"MyApp\",instance=\"MyInstance\",service=\"MyService1\",command=\"MyCommand1\"} 3\n' +
            '# TYPE ${expectedName}_average gauge\n${expectedName}_average{source=\"MyApp\",instance=\"MyInstance\",service=\"MyService1\",command=\"MyCommand1\"} 3.5\n' +
            '# TYPE ${expectedName}_count gauge\n${expectedName}_count{source=\"MyApp\",instance=\"MyInstance\",service=\"MyService1\",command=\"MyCommand1\"} 11\n' +
            '# TYPE $expectedName gauge\n$expectedName{source=\"MyApp\",instance=\"MyInstance\",service=\"MyService1\",command=\"MyCommand1\"} 2\n' +
            '# TYPE ${expectedName}_max gauge\n${expectedName}_max{source=\"MyApp\",instance=\"MyInstance\",service=\"MyService1\",command=\"MyCommand1\"} 113\n' +
            '# TYPE ${expectedName}_min gauge\n${expectedName}_min{source=\"MyApp\",instance=\"MyInstance\",service=\"MyService1\",command=\"MyCommand1\"} 13\n' +
            '# TYPE ${expectedName}_average gauge\n${expectedName}_average{source=\"MyApp\",instance=\"MyInstance\",service=\"MyService1\",command=\"MyCommand1\"} 13.5\n' +
            '# TYPE ${expectedName}_count gauge\n${expectedName}_count{source=\"MyApp\",instance=\"MyInstance\",service=\"MyService1\",command=\"MyCommand1\"} 111\n';

        expect(expected, body);
      }
    });

    test('KnownCounter_Exec_ClientMetrics_Good', () {
      const knownCounterExecClientMetricsGoodTestCases = [
        {
          'counterName': 'MyTarget1.MyService1.MyCommand1.call_count',
          'expectedName': 'call_count'
        },
        {
          'counterName': 'MyTarget1.MyService1.MyCommand1.call_time',
          'expectedName': 'call_time'
        },
        {
          'counterName': 'MyTarget1.MyService1.MyCommand1.call_errors',
          'expectedName': 'call_errors'
        }
      ];

      for (var i = 0;
          i < knownCounterExecClientMetricsGoodTestCases.length;
          i++) {
        var testData = knownCounterExecClientMetricsGoodTestCases[i];
        final counterName = testData['counterName']!;
        final expectedName = testData['expectedName'];

        var counters = <Counter>[];

        var counter1 = Counter(counterName, CounterType.Increment);
        counter1.count = 1;
        counter1.time = RandomDateTime.nextDateTime(DateTime.now().toUtc());
        counters.add(counter1);

        var counter2 = Counter(counterName, CounterType.Interval);
        counter2.count = 11;
        counter2.max = 13;
        counter2.min = 3;
        counter2.average = 3.5;
        counter2.time = RandomDateTime.nextDateTime(DateTime.now().toUtc());
        counters.add(counter2);

        var counter3 = Counter(counterName, CounterType.LastValue);
        counter3.last = 2;
        counter3.time = RandomDateTime.nextDateTime(DateTime.now().toUtc());
        counters.add(counter3);

        var counter4 = Counter(counterName, CounterType.Statistics);
        counter4.count = 111;
        counter4.max = 113;
        counter4.min = 13;
        counter4.average = 13.5;
        counter4.time = RandomDateTime.nextDateTime(DateTime.now().toUtc());
        counters.add(counter4);

        var body = PrometheusCounterConverter.toString2(
            counters, 'MyApp', 'MyInstance');

        var expected = '# TYPE $expectedName gauge\n$expectedName{source=\"MyApp\",instance=\"MyInstance\",service=\"MyService1\",command=\"MyCommand1\",target=\"MyTarget1\"} 1\n' +
            ('# TYPE ${expectedName}_max gauge\n${expectedName}_max{source=\"MyApp\",instance=\"MyInstance\",service=\"MyService1\",command=\"MyCommand1\",target=\"MyTarget1\"} 13\n') +
            '# TYPE ${expectedName}_min gauge\n${expectedName}_min{source=\"MyApp\",instance=\"MyInstance\",service=\"MyService1\",command=\"MyCommand1\",target=\"MyTarget1\"} 3\n' +
            '# TYPE ${expectedName}_average gauge\n${expectedName}_average{source=\"MyApp\",instance=\"MyInstance\",service=\"MyService1\",command=\"MyCommand1\",target=\"MyTarget1\"} 3.5\n' +
            '# TYPE ${expectedName}_count gauge\n${expectedName}_count{source=\"MyApp\",instance=\"MyInstance\",service=\"MyService1\",command=\"MyCommand1\",target=\"MyTarget1\"} 11\n' +
            '# TYPE $expectedName gauge\n$expectedName{source=\"MyApp\",instance=\"MyInstance\",service=\"MyService1\",command=\"MyCommand1\",target=\"MyTarget1\"} 2\n' +
            '# TYPE ${expectedName}_max gauge\n${expectedName}_max{source=\"MyApp\",instance=\"MyInstance\",service=\"MyService1\",command=\"MyCommand1\",target=\"MyTarget1\"} 113\n' +
            '# TYPE ${expectedName}_min gauge\n${expectedName}_min{source=\"MyApp\",instance=\"MyInstance\",service=\"MyService1\",command=\"MyCommand1\",target=\"MyTarget1\"} 13\n' +
            '# TYPE ${expectedName}_average gauge\n${expectedName}_average{source=\"MyApp\",instance=\"MyInstance\",service=\"MyService1\",command=\"MyCommand1\",target=\"MyTarget1\"} 13.5\n' +
            '# TYPE ${expectedName}_count gauge\n${expectedName}_count{source=\"MyApp\",instance=\"MyInstance\",service=\"MyService1\",command=\"MyCommand1\",target=\"MyTarget1\"} 111\n';

        expect(expected, body);
      }
    });

    test('KnownCounter_Exec_QueueMetrics_Good', () {
      const knownCounterExecQueueMetricsGoodTestCases = [
        {
          'counterName': 'queue.default.sent_messages',
          'expectedName': 'queue_sent_messages'
        },
        {
          'counterName': 'queue.default.received_messages',
          'expectedName': 'queue_received_messages'
        },
        {
          'counterName': 'queue.default.dead_messages',
          'expectedName': 'queue_dead_messages'
        }
      ];

      for (var i = 0;
          i < knownCounterExecQueueMetricsGoodTestCases.length;
          i++) {
        var testData = knownCounterExecQueueMetricsGoodTestCases[i];
        final counterName = testData['counterName']!;
        final expectedName = testData['expectedName'];

        var counters = <Counter>[];

        var counter1 = Counter(counterName, CounterType.Increment);
        counter1.count = 1;
        counter1.time = RandomDateTime.nextDateTime(DateTime.now().toUtc());
        counters.add(counter1);

        var counter2 = Counter(counterName, CounterType.Interval);
        counter2.count = 11;
        counter2.max = 13;
        counter2.min = 3;
        counter2.average = 3.5;
        counter2.time = RandomDateTime.nextDateTime(DateTime.now().toUtc());
        counters.add(counter2);

        var counter3 = Counter(counterName, CounterType.LastValue);
        counter3.last = 2;
        counter3.time = RandomDateTime.nextDateTime(DateTime.now().toUtc());
        counters.add(counter3);

        var counter4 = Counter(counterName, CounterType.Statistics);
        counter4.count = 111;
        counter4.max = 113;
        counter4.min = 13;
        counter4.average = 13.5;
        counter4.time = RandomDateTime.nextDateTime(DateTime.now().toUtc());
        counters.add(counter4);

        var body = PrometheusCounterConverter.toString2(
            counters, 'MyApp', 'MyInstance');

        var expected = '# TYPE $expectedName gauge\n$expectedName{source=\"MyApp\",instance=\"MyInstance\",queue=\"default\"} 1\n' +
            ('# TYPE ${expectedName}_max gauge\n${expectedName}_max{source=\"MyApp\",instance=\"MyInstance\",queue=\"default\"} 13\n') +
            '# TYPE ${expectedName}_min gauge\n${expectedName}_min{source=\"MyApp\",instance=\"MyInstance\",queue=\"default\"} 3\n' +
            '# TYPE ${expectedName}_average gauge\n${expectedName}_average{source=\"MyApp\",instance=\"MyInstance\",queue=\"default\"} 3.5\n' +
            '# TYPE ${expectedName}_count gauge\n${expectedName}_count{source=\"MyApp\",instance=\"MyInstance\",queue=\"default\"} 11\n' +
            '# TYPE $expectedName gauge\n$expectedName{source=\"MyApp\",instance=\"MyInstance\",queue=\"default\"} 2\n' +
            '# TYPE ${expectedName}_max gauge\n${expectedName}_max{source=\"MyApp\",instance=\"MyInstance\",queue=\"default\"} 113\n' +
            '# TYPE ${expectedName}_min gauge\n${expectedName}_min{source=\"MyApp\",instance=\"MyInstance\",queue=\"default\"} 13\n' +
            '# TYPE ${expectedName}_average gauge\n${expectedName}_average{source=\"MyApp\",instance=\"MyInstance\",queue=\"default\"} 13.5\n' +
            '# TYPE ${expectedName}_count gauge\n${expectedName}_count{source=\"MyApp\",instance=\"MyInstance\",queue=\"default\"} 111\n';

        expect(expected, body);
      }
    });

    test('EmptyCounters', () {
      var counters = <Counter>[];
      var body = PrometheusCounterConverter.toString2(counters, '', '');
      expect('', body);
    });

    test('NullValues', () {
      var body = PrometheusCounterConverter.toString2(null, '', '');
      expect('', body);
    });

    test('SingleIncrement_NoLabels', () {
      var counters = <Counter>[];

      var counter = Counter('MyCounter', CounterType.Increment);
      counter.average = 2;
      counter.min = 1;
      counter.max = 3;
      counter.count = 2;
      counter.last = 3;
      counter.time = RandomDateTime.nextDateTime(DateTime.now().toUtc());
      counters.add(counter);

      var body = PrometheusCounterConverter.toString2(counters, null, null);
      const expected = '# TYPE mycounter gauge\nmycounter 2\n';
      expect(expected, body);
    });

    test('SingleIncrement_SourceInstance', () {
      var counters = <Counter>[];

      var counter = Counter('MyCounter', CounterType.Increment);
      counter.average = 2;
      counter.min = 1;
      counter.max = 3;
      counter.count = 2;
      counter.last = 3;
      counter.time = RandomDateTime.nextDateTime(DateTime.now().toUtc());
      counters.add(counter);

      var body =
          PrometheusCounterConverter.toString2(counters, 'MyApp', 'MyInstance');
      const expected =
          '# TYPE mycounter gauge\nmycounter{source=\"MyApp\",instance=\"MyInstance\"} 2\n';
      expect(expected, body);
    });

    test('MultiIncrement_SourceInstance', () {
      var counters = <Counter>[];

      var counter1 = Counter('MyCounter1', CounterType.Increment);
      counter1.count = 2;
      counter1.last = 3;
      counter1.time = RandomDateTime.nextDateTime(DateTime.now().toUtc());
      counters.add(counter1);

      var counter2 = Counter('MyCounter2', CounterType.Increment);
      counter2.count = 5;
      counter2.last = 10;
      counter2.time = RandomDateTime.nextDateTime(DateTime.now().toUtc());
      counters.add(counter2);

      var body =
          PrometheusCounterConverter.toString2(counters, 'MyApp', 'MyInstance');
      const expected =
          '# TYPE mycounter1 gauge\nmycounter1{source=\"MyApp\",instance=\"MyInstance\"} 2\n' +
              ('# TYPE mycounter2 gauge\nmycounter2{source=\"MyApp\",instance=\"MyInstance\"} 5\n');
      expect(expected, body);
    });

    test('MultiIncrement_ExecWithOnlyTwo_SourceInstance', () {
      var counters = <Counter>[];

      var counter1 = Counter('MyCounter1.exec_time', CounterType.Increment);
      counter1.count = 2;
      counter1.last = 3;
      counter1.time = RandomDateTime.nextDateTime(DateTime.now().toUtc());
      counters.add(counter1);

      var counter2 = Counter('MyCounter2.exec_time', CounterType.Increment);
      counter2.count = 5;
      counter2.last = 10;
      counter2.time = RandomDateTime.nextDateTime(DateTime.now().toUtc());
      counters.add(counter2);

      var body =
          PrometheusCounterConverter.toString2(counters, 'MyApp', 'MyInstance');
      const expected =
          '# TYPE mycounter1_exec_time gauge\nmycounter1_exec_time{source=\"MyApp\",instance=\"MyInstance\"} 2\n' +
              ('# TYPE mycounter2_exec_time gauge\nmycounter2_exec_time{source=\"MyApp\",instance=\"MyInstance\"} 5\n');
      expect(expected, body);
    });

    test('MultiIncrement_Exec_SourceInstance', () {
      var counters = <Counter>[];

      var counter1 =
          Counter('MyService1.MyCommand1.exec_time', CounterType.Increment);
      counter1.count = 2;
      counter1.last = 3;
      counter1.time = RandomDateTime.nextDateTime(DateTime.now().toUtc());
      counters.add(counter1);

      var counter2 =
          Counter('MyService2.MyCommand2.exec_time', CounterType.Increment);
      counter2.count = 5;
      counter2.last = 10;
      counter2.time = RandomDateTime.nextDateTime(DateTime.now().toUtc());
      counters.add(counter2);

      var body =
          PrometheusCounterConverter.toString2(counters, 'MyApp', 'MyInstance');
      const expected =
          '# TYPE exec_time gauge\nexec_time{source=\"MyApp\",instance=\"MyInstance\",service=\"MyService1\",command=\"MyCommand1\"} 2\n' +
              ('# TYPE exec_time gauge\nexec_time{source=\"MyApp\",instance=\"MyInstance\",service=\"MyService2\",command=\"MyCommand2\"} 5\n');
      expect(expected, body);
    });

    test('MultiInterval_Exec_SourceInstance', () {
      var counters = <Counter>[];

      var counter1 =
          Counter('MyService1.MyCommand1.exec_time', CounterType.Interval);
      counter1.min = 1;
      counter1.max = 3;
      counter1.average = 2;
      counter1.count = 2;
      counter1.last = 3;
      counter1.time = RandomDateTime.nextDateTime(DateTime.now().toUtc());
      counters.add(counter1);

      var counter2 =
          Counter('MyService2.MyCommand2.exec_time', CounterType.Interval);
      counter2.min = 2;
      counter2.max = 4;
      counter2.average = 3;
      counter2.count = 5;
      counter2.last = 10;
      counter2.time = RandomDateTime.nextDateTime(DateTime.now().toUtc());
      counters.add(counter2);

      var body =
          PrometheusCounterConverter.toString2(counters, 'MyApp', 'MyInstance');
      const expected = '# TYPE exec_time_max gauge\nexec_time_max{source=\"MyApp\",instance=\"MyInstance\",service=\"MyService1\",command=\"MyCommand1\"} 3\n' +
          ('# TYPE exec_time_min gauge\nexec_time_min{source=\"MyApp\",instance=\"MyInstance\",service=\"MyService1\",command=\"MyCommand1\"} 1\n') +
          '# TYPE exec_time_average gauge\nexec_time_average{source=\"MyApp\",instance=\"MyInstance\",service=\"MyService1\",command=\"MyCommand1\"} 2.0\n' +
          '# TYPE exec_time_count gauge\nexec_time_count{source=\"MyApp\",instance=\"MyInstance\",service=\"MyService1\",command=\"MyCommand1\"} 2\n' +
          '# TYPE exec_time_max gauge\nexec_time_max{source=\"MyApp\",instance=\"MyInstance\",service=\"MyService2\",command=\"MyCommand2\"} 4\n' +
          '# TYPE exec_time_min gauge\nexec_time_min{source=\"MyApp\",instance=\"MyInstance\",service=\"MyService2\",command=\"MyCommand2\"} 2\n' +
          '# TYPE exec_time_average gauge\nexec_time_average{source=\"MyApp\",instance=\"MyInstance\",service=\"MyService2\",command=\"MyCommand2\"} 3.0\n' +
          '# TYPE exec_time_count gauge\nexec_time_count{source=\"MyApp\",instance=\"MyInstance\",service=\"MyService2\",command=\"MyCommand2\"} 5\n';
      expect(expected, body);
    });

    test('MultiStatistics_Exec_SourceInstance', () {
      var counters = <Counter>[];

      var counter1 =
          Counter('MyService1.MyCommand1.exec_time', CounterType.Statistics);
      counter1.min = 1;
      counter1.max = 3;
      counter1.average = 2.0;
      counter1.count = 2;
      counter1.last = 3;
      counter1.time = RandomDateTime.nextDateTime(DateTime.now().toUtc());
      counters.add(counter1);

      var counter2 =
          Counter('MyService2.MyCommand2.exec_time', CounterType.Statistics);
      counter2.min = 2;
      counter2.max = 4;
      counter2.average = 3.0;
      counter2.count = 5;
      counter2.last = 10;
      counter2.time = RandomDateTime.nextDateTime(DateTime.now().toUtc());
      counters.add(counter2);

      var body =
          PrometheusCounterConverter.toString2(counters, 'MyApp', 'MyInstance');
      const expected = '# TYPE exec_time_max gauge\nexec_time_max{source=\"MyApp\",instance=\"MyInstance\",service=\"MyService1\",command=\"MyCommand1\"} 3\n' +
          ('# TYPE exec_time_min gauge\nexec_time_min{source=\"MyApp\",instance=\"MyInstance\",service=\"MyService1\",command=\"MyCommand1\"} 1\n') +
          '# TYPE exec_time_average gauge\nexec_time_average{source=\"MyApp\",instance=\"MyInstance\",service=\"MyService1\",command=\"MyCommand1\"} 2.0\n' +
          '# TYPE exec_time_count gauge\nexec_time_count{source=\"MyApp\",instance=\"MyInstance\",service=\"MyService1\",command=\"MyCommand1\"} 2\n' +
          '# TYPE exec_time_max gauge\nexec_time_max{source=\"MyApp\",instance=\"MyInstance\",service=\"MyService2\",command=\"MyCommand2\"} 4\n' +
          '# TYPE exec_time_min gauge\nexec_time_min{source=\"MyApp\",instance=\"MyInstance\",service=\"MyService2\",command=\"MyCommand2\"} 2\n' +
          '# TYPE exec_time_average gauge\nexec_time_average{source=\"MyApp\",instance=\"MyInstance\",service=\"MyService2\",command=\"MyCommand2\"} 3.0\n' +
          '# TYPE exec_time_count gauge\nexec_time_count{source=\"MyApp\",instance=\"MyInstance\",service=\"MyService2\",command=\"MyCommand2\"} 5\n';
      expect(expected, body);
    });

    test('MultiLastValue_Exec_SourceInstance', () {
      var counters = <Counter>[];

      var counter1 =
          Counter('MyService1.MyCommand1.exec_time', CounterType.LastValue);
      counter1.count = 2;
      counter1.last = 3;
      counter1.time = RandomDateTime.nextDateTime(DateTime.now().toUtc());
      counters.add(counter1);

      var counter2 =
          Counter('MyService2.MyCommand2.exec_time', CounterType.LastValue);
      counter2.count = 5;
      counter2.last = 10;
      counter2.time = RandomDateTime.nextDateTime(DateTime.now().toUtc());
      counters.add(counter2);

      var body =
          PrometheusCounterConverter.toString2(counters, 'MyApp', 'MyInstance');
      const expected =
          '# TYPE exec_time gauge\nexec_time{source=\"MyApp\",instance=\"MyInstance\",service=\"MyService1\",command=\"MyCommand1\"} 3\n' +
              ('# TYPE exec_time gauge\nexec_time{source=\"MyApp\",instance=\"MyInstance\",service=\"MyService2\",command=\"MyCommand2\"} 10\n');

      expect(expected, body);
    });
  });
}
