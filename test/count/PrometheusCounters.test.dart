// import { ConfigParams } from 'pip-services3-commons-node';
// import { References } from 'pip-services3-commons-node';

// import { PrometheusCounters } from '../../src/count/PrometheusCounters';
// import { CountersFixture } from '../fixtures/CountersFixture';

// suite('PrometheusCounters', ()=> {
//     let _counters: PrometheusCounters;
//     let _fixture: CountersFixture;

//     setup((done) => {
//         let host = process.env['PUSHGATEWAY_SERVICE_HOST'] || 'localhost';
//         let port = process.env['PUSHGATEWAY_SERVICE_PORT'] || 9091;

//         _counters = new PrometheusCounters();
//         _fixture = new CountersFixture(_counters);

//         let config = ConfigParams.fromTuples(
//             'source', 'test',
//             'connection.host', host,
//             'connection.port', port
//         );
//         _counters.configure(config);

//         _counters.open(null, (err) => {
//              done(err);
//         });
//     });

//     teardown((done) => {
//         _counters.close(null, done);
//     });

//     test('Simple Counters', (done) => {
//         _fixture.testSimpleCounters(done);
//     });

//     test('Measure Elapsed Time', (done) => {
//         _fixture.testMeasureElapsedTime(done);
//     });

// });