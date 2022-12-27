import 'package:pip_services3_components/pip_services3_components.dart';
import 'package:pip_services3_commons/pip_services3_commons.dart';

/// Helper class that converts performance counter values into
/// a response from Prometheus metrics service.

class PrometheusCounterConverter {
  /// Converts the given counters to a string that is returned by Prometheus metrics service.
  ///
  /// - [counters]  a list of counters to convert.
  /// - [source]    a source (context) name.
  /// - [instance]  a unique instance name (usually a host name).
  static String toString2(
      List<Counter>? counters, String? source, String? instance) {
    if (counters == null || counters.isEmpty) return '';

    var builder = '';

    for (var counter in counters) {
      var counterName = _parseCounterName(counter);
      var labels = _generateCounterLabel(counter, source, instance);

      switch (counter.type) {
        case CounterType.Increment:
          builder += '# TYPE ' + counterName + ' gauge\n';
          builder += counterName +
              labels +
              ' ' +
              StringConverter.toString2(counter.count) +
              '\n';
          break;
        case CounterType.Interval:
          builder += '# TYPE ' + counterName + '_max gauge\n';
          builder += counterName +
              '_max' +
              labels +
              ' ' +
              StringConverter.toString2(counter.max) +
              '\n';
          builder += '# TYPE ' + counterName + '_min gauge\n';
          builder += counterName +
              '_min' +
              labels +
              ' ' +
              StringConverter.toString2(counter.min) +
              '\n';
          builder += '# TYPE ' + counterName + '_average gauge\n';
          builder += counterName +
              '_average' +
              labels +
              ' ' +
              StringConverter.toString2(counter.average) +
              '\n';
          builder += '# TYPE ' + counterName + '_count gauge\n';
          builder += counterName +
              '_count' +
              labels +
              ' ' +
              StringConverter.toString2(counter.count) +
              '\n';
          break;
        case CounterType.LastValue:
          builder += '# TYPE ' + counterName + ' gauge\n';
          builder += counterName +
              labels +
              ' ' +
              StringConverter.toString2(counter.last) +
              '\n';
          break;
        case CounterType.Statistics:
          builder += '# TYPE ' + counterName + '_max gauge\n';
          builder += counterName +
              '_max' +
              labels +
              ' ' +
              StringConverter.toString2(counter.max) +
              '\n';
          builder += '# TYPE ' + counterName + '_min gauge\n';
          builder += counterName +
              '_min' +
              labels +
              ' ' +
              StringConverter.toString2(counter.min) +
              '\n';
          builder += '# TYPE ' + counterName + '_average gauge\n';
          builder += counterName +
              '_average' +
              labels +
              ' ' +
              StringConverter.toString2(counter.average) +
              '\n';
          builder += '# TYPE ' + counterName + '_count gauge\n';
          builder += counterName +
              '_count' +
              labels +
              ' ' +
              StringConverter.toString2(counter.count) +
              '\n';
          break;
        case CounterType
            .Timestamp: // Prometheus doesn't support non-numeric metrics
          builder += '# TYPE ' + counterName + ' gauge\n'; //' untyped\n';
          builder += counterName +
              labels +
              ' ' +
              StringConverter.toString2(counter.time?.millisecondsSinceEpoch) +
              '\n';
          break;
      }
    }

    return builder;
  }

  static String _generateCounterLabel(
      Counter counter, String? source, String? instance) {
    var labels = <String, dynamic>{};

    if (source != null && source != '') labels['source'] = source;
    if (instance != null && instance != '') labels['instance'] = instance;

    var nameParts = counter.name.split('.');

    // If there are other predictable names from which we can parse labels, we can add them below
    if ((nameParts.length >= 3 && nameParts[2] == 'exec_count') ||
        (nameParts.length >= 3 && nameParts[2] == 'exec_time') ||
        (nameParts.length >= 3 && nameParts[2] == 'exec_errors')) {
      labels['service'] = nameParts[0];
      labels['command'] = nameParts[1];
    }

    if ((nameParts.length >= 4 && nameParts[3] == 'call_count') ||
        (nameParts.length >= 4 && nameParts[3] == 'call_time') ||
        (nameParts.length >= 4 && nameParts[3] == 'call_errors')) {
      labels['service'] = nameParts[1];
      labels['command'] = nameParts[2];
      labels['target'] = nameParts[0];
    }

    if ((nameParts.length >= 3 && nameParts[2] == 'sent_messages') ||
        (nameParts.length >= 3 && nameParts[2] == 'received_messages') ||
        (nameParts.length >= 3 && nameParts[2] == 'dead_messages')) {
      labels['queue'] = nameParts[1];
    }

    if (labels.isEmpty) return '';

    var builder = '{';
    for (var key in labels.keys) {
      if (builder.length > 1) builder += ',';
      builder += key + '="' + labels[key] + '"';
    }
    builder += '}';

    return builder;
  }

  static String _parseCounterName(Counter? counter) {
    if (counter?.name == null && counter?.name == '' && counter == null) {
      return '';
    }

    var nameParts = counter!.name.split('.');

    // If there are other predictable names from which we can parse labels, we can add them below
    // Rest Service Labels
    if (nameParts.length >= 3 && nameParts[2] == 'exec_count') {
      return nameParts[2];
    }
    if (nameParts.length >= 3 && nameParts[2] == 'exec_time') {
      return nameParts[2];
    }
    if (nameParts.length >= 3 && nameParts[2] == 'exec_errors') {
      return nameParts[2];
    }

    // Rest & Direct Client Labels
    if (nameParts.length >= 4 && nameParts[3] == 'call_count') {
      return nameParts[3];
    }
    if (nameParts.length >= 4 && nameParts[3] == 'call_time') {
      return nameParts[3];
    }
    if (nameParts.length >= 4 && nameParts[3] == 'call_errors') {
      return nameParts[3];
    }

    // Queue Labels
    if ((nameParts.length >= 3 && nameParts[2] == 'sent_messages') ||
        (nameParts.length >= 3 && nameParts[2] == 'received_messages') ||
        (nameParts.length >= 3 && nameParts[2] == 'dead_messages')) {
      var name = '${nameParts[0]}.${nameParts[2]}';
      return name.toLowerCase().replaceAll('.', '_').replaceAll('/', '_');
    }

    // TODO: are there other assumptions we can make?
    // Or just return as a single, valid name
    return counter.name.toLowerCase().replaceAll('.', '_').replaceAll('/', '_');
  }

  static Map<String, dynamic> _parseCounterLabels(
      Counter counter, String? source, String? instance) {
    var labels = <String, dynamic>{};

    if (source != null && source != '') labels['source'] = source;
    if (instance != null && instance != '') labels['instance'] = instance;

    var nameParts = counter.name.split('.');

    // If there are other predictable names from which we can parse labels, we can add them below
    if (nameParts.length >= 3 && nameParts[2] == 'exec_time') {
      labels['service'] = nameParts[0];
      labels['command'] = nameParts[1];
    }

    return labels;
  }
}
