import 'dart:async';

import 'package:pip_services3_commons/pip_services3_commons.dart';
import 'package:pip_services3_rpc/pip_services3_rpc.dart';
import 'package:pip_services3_components/pip_services3_components.dart';
import 'package:shelf/shelf.dart';

import '../count/PrometheusCounters.dart';
import '../count/PrometheusCounterConverter.dart';

/// Service that exposes the '/metrics' and '/metricsandreset' routes for Prometheus to scap performance metrics.
///
/// ### Configuration parameters ###
///
/// - [dependencies]:
///   - [endpoint]:              override for HTTP Endpoint dependency
///   - [prometheus-counters]:   override for PrometheusCounters dependency
/// - [connection(s)]:
///   - [discovery_key]:         (optional) a key to retrieve the connection from IDiscovery
///   - [protocol]:              connection protocol: http or https
///   - [host]:                  host name or IP address
///   - [port]:                  port number
///   - [uri]:                   resource URI or connection string with all parameters in it
///
/// ### References ###
///
/// - *:logger:*:*:1.0         (optional) [ILogger](https://pub.dev/documentation/pip_services3_components/latest/pip_services3_components/ILogger-class.html) components to pass log messages
/// - *:counters:*:*:1.0         (optional) [ICounters](https://pub.dev/documentation/pip_services3_components/latest/pip_services3_components/ICounters-class.html) components to pass collected measurements
/// - *:discovery:*:*:1.0        (optional) [IDiscovery](https://pub.dev/documentation/pip_services3_components/latest/pip_services3_components/IDiscovery-class.html) services to resolve connection
/// - *:endpoint:http:*:1.0          (optional) [HttpEndpoint](https://pub.dev/documentation/pip_services3_rpc/latest/pip_services3_rpc/HttpEndpoint-class.html) reference to expose REST operation
/// - *:counters:prometheus:*:1.0    [PrometheusCounters] reference to retrieve collected metrics
///
/// See [RestService](https://pub.dev/documentation/pip_services3_rpc/latest/pip_services3_rpc/RestService-class.html)
/// See [RestClient](https://pub.dev/documentation/pip_services3_rpc/latest/pip_services3_rpc/RestClient-class.html)
///
/// ### Example ###
///
///     var service = PrometheusMetricsService();
///     service.configure(ConfigParams.fromTuples([
///         'connection.protocol', 'http',
///         'connection.host', 'localhost',
///         'connection.port', 8080
///     ]));
///
///     await service.open('123')
///     print('The Prometheus metrics service is accessible at http://+:8080/metrics');

class PrometheusMetricsService extends RestService {
  CachedCounters? _cachedCounters;
  String? _source;
  String? _instance;

  /// Creates a new instance of this service.
  PrometheusMetricsService() : super() {
    dependencyResolver.put('cached-counters',
        Descriptor('pip-services', 'counters', 'cached', '*', '1.0'));
    dependencyResolver.put('prometheus-counters',
        Descriptor('pip-services', 'counters', 'prometheus', '*', '1.0'));
  }

  /// Sets references to dependent components.
  ///
  /// - [references] 	references to locate the component dependencies.
  @override
  void setReferences(IReferences references) {
    super.setReferences(references);

    _cachedCounters = dependencyResolver
        .getOneOptional<PrometheusCounters>('prometheus-counters');
    _cachedCounters ??=
        dependencyResolver.getOneOptional<CachedCounters>('cached-counters');

    var contextInfo = references.getOneOptional<ContextInfo>(
        Descriptor('pip-services', 'context-info', 'default', '*', '1.0'));

    if (contextInfo != null && (_source == '' || _source == null)) {
      _source = contextInfo.name;
    }
    if (contextInfo != null && (_instance == '' || _instance == null)) {
      _instance = contextInfo.contextId;
    }
  }

  /// Registers all service routes in HTTP endpoint.
  @override
  void register() {
    registerRoute('get', 'metrics', null, (Request req) async {
      return await _metrics(req);
    });
    registerRoute('get', 'metricsandreset', null, (Request req) async {
      return await _metricsAndReset(req);
    });
  }

  /// Handles metrics requests
  ///
  /// - [req]   an HTTP request
  /// - [res]   an HTTP response
  FutureOr<Response> _metrics(Request req) {
    var counters = _cachedCounters != null ? _cachedCounters!.getAll() : null;
    var body =
        PrometheusCounterConverter.toString2(counters, _source, _instance);

    return Response(200, headers: {'content-type': 'text/plain'}, body: body);
  }

  /// Handles metricsandreset requests.
  /// The counters will be returned and then zeroed out.
  /// - [req]   an HTTP request
  /// - [res]   an HTTP response
  FutureOr<Response> _metricsAndReset(Request req) {
    var counters = _cachedCounters != null ? _cachedCounters!.getAll() : null;
    var body =
        PrometheusCounterConverter.toString2(counters, _source, _instance);

    if (_cachedCounters != null) {
      _cachedCounters!.clearAll();
    }

    return Response(200, headers: {'content-type': 'text/plain'}, body: body);
  }
}
