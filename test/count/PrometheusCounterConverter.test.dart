// import { Counter } from 'pip-services3-components-node';
// import { CounterType } from 'pip-services3-components-node';
// import { RandomDateTime } from 'pip-services3-commons-node';

// import { PrometheusCounterConverter } from '../../src/count/PrometheusCounterConverter';

// let assert = require('chai').assert;
// let async = require('async');

// suite('PrometheusCounterConverter', ()=> {

//     setup((done) => {
//         done();
//     });

//     teardown((done) => {
//         done();
//     });

//     test('KnownCounter_Exec_ServiceMetrics_Good', (done) => {

//         const knownCounterExecServiceMetricsGoodTestCases = [
//             { counterName: "MyService1.MyCommand1.exec_count", expectedName: "exec_count" },
//             { counterName: "MyService1.MyCommand1.exec_time", expectedName: "exec_time" },
//             { counterName: "MyService1.MyCommand1.exec_errors", expectedName: "exec_errors" }
//         ];

//         async.series(
//             async.each(knownCounterExecServiceMetricsGoodTestCases, function (testData, cb) {
//                 const counterName = testData.counterName;
//                 const expectedName = testData.expectedName;

//                 let counters = new Array<Counter>();

//                 let counter1 = new Counter(counterName , CounterType.Increment);
//                 counter1.count = 1;
//                 counter1.time = RandomDateTime.nextDateTime(new Date());
//                 counters.push(counter1);

//                 let counter2 = new Counter(counterName , CounterType.Interval);
//                 counter2.count = 11;
//                 counter2.max = 13;
//                 counter2.min = 3;
//                 counter2.average = 3.5;
//                 counter2.time = RandomDateTime.nextDateTime(new Date());
//                 counters.push(counter2);

//                 let counter3 = new Counter(counterName , CounterType.LastValue);
//                 counter3.last = 2;
//                 counter3.time = RandomDateTime.nextDateTime(new Date());
//                 counters.push(counter3);

//                 let counter4 = new Counter(counterName , CounterType.Statistics);
//                 counter4.count = 111;
//                 counter4.max = 113;
//                 counter4.min = 13;
//                 counter4.average = 13.5;
//                 counter4.time = RandomDateTime.nextDateTime(new Date());
//                 counters.push(counter4);

//                 let body = PrometheusCounterConverter.toString(counters, "MyApp", "MyInstance");

//                 let expected = `# TYPE ${expectedName} gauge\n${expectedName}{source=\"MyApp\",instance=\"MyInstance\",service=\"MyService1\",command=\"MyCommand1\"} 1\n`
//                     + `# TYPE ${expectedName}_max gauge\n${expectedName}_max{source=\"MyApp\",instance=\"MyInstance\",service=\"MyService1\",command=\"MyCommand1\"} 13\n`
//                     + `# TYPE ${expectedName}_min gauge\n${expectedName}_min{source=\"MyApp\",instance=\"MyInstance\",service=\"MyService1\",command=\"MyCommand1\"} 3\n`
//                     + `# TYPE ${expectedName}_average gauge\n${expectedName}_average{source=\"MyApp\",instance=\"MyInstance\",service=\"MyService1\",command=\"MyCommand1\"} 3.5\n`
//                     + `# TYPE ${expectedName}_count gauge\n${expectedName}_count{source=\"MyApp\",instance=\"MyInstance\",service=\"MyService1\",command=\"MyCommand1\"} 11\n`
//                     + `# TYPE ${expectedName} gauge\n${expectedName}{source=\"MyApp\",instance=\"MyInstance\",service=\"MyService1\",command=\"MyCommand1\"} 2\n`
//                     + `# TYPE ${expectedName}_max gauge\n${expectedName}_max{source=\"MyApp\",instance=\"MyInstance\",service=\"MyService1\",command=\"MyCommand1\"} 113\n`
//                     + `# TYPE ${expectedName}_min gauge\n${expectedName}_min{source=\"MyApp\",instance=\"MyInstance\",service=\"MyService1\",command=\"MyCommand1\"} 13\n`
//                     + `# TYPE ${expectedName}_average gauge\n${expectedName}_average{source=\"MyApp\",instance=\"MyInstance\",service=\"MyService1\",command=\"MyCommand1\"} 13.5\n`
//                     + `# TYPE ${expectedName}_count gauge\n${expectedName}_count{source=\"MyApp\",instance=\"MyInstance\",service=\"MyService1\",command=\"MyCommand1\"} 111\n`;

//                 assert.equal(expected, body);

//                 cb();
//             }),
//         done);
//     });

//     test('KnownCounter_Exec_ClientMetrics_Good', (done) => {
//         const knownCounterExecClientMetricsGoodTestCases = [
//             { counterName: "MyTarget1.MyService1.MyCommand1.call_count", expectedName: "call_count" },
//             { counterName: "MyTarget1.MyService1.MyCommand1.call_time", expectedName: "call_time" },
//             { counterName: "MyTarget1.MyService1.MyCommand1.call_errors", expectedName: "call_errors" }
//         ];

//         async.series(
//             async.each(knownCounterExecClientMetricsGoodTestCases, function (testData, cb) {
//                 const counterName = testData.counterName;
//                 const expectedName = testData.expectedName;

//                 let counters = new Array<Counter>();

//                 let counter1 = new Counter(counterName , CounterType.Increment);
//                 counter1.count = 1;
//                 counter1.time = RandomDateTime.nextDateTime(new Date());
//                 counters.push(counter1);

//                 let counter2 = new Counter(counterName , CounterType.Interval);
//                 counter2.count = 11;
//                 counter2.max = 13;
//                 counter2.min = 3;
//                 counter2.average = 3.5;
//                 counter2.time = RandomDateTime.nextDateTime(new Date());
//                 counters.push(counter2);

//                 let counter3 = new Counter(counterName , CounterType.LastValue);
//                 counter3.last = 2;
//                 counter3.time = RandomDateTime.nextDateTime(new Date());
//                 counters.push(counter3);

//                 let counter4 = new Counter(counterName , CounterType.Statistics);
//                 counter4.count = 111;
//                 counter4.max = 113;
//                 counter4.min = 13;
//                 counter4.average = 13.5;
//                 counter4.time = RandomDateTime.nextDateTime(new Date());
//                 counters.push(counter4);

//                 let body = PrometheusCounterConverter.toString(counters, "MyApp", "MyInstance");

//                 let expected = `# TYPE ${expectedName} gauge\n${expectedName}{source=\"MyApp\",instance=\"MyInstance\",service=\"MyService1\",command=\"MyCommand1\",target=\"MyTarget1\"} 1\n`
//                     + `# TYPE ${expectedName}_max gauge\n${expectedName}_max{source=\"MyApp\",instance=\"MyInstance\",service=\"MyService1\",command=\"MyCommand1\",target=\"MyTarget1\"} 13\n`
//                     + `# TYPE ${expectedName}_min gauge\n${expectedName}_min{source=\"MyApp\",instance=\"MyInstance\",service=\"MyService1\",command=\"MyCommand1\",target=\"MyTarget1\"} 3\n`
//                     + `# TYPE ${expectedName}_average gauge\n${expectedName}_average{source=\"MyApp\",instance=\"MyInstance\",service=\"MyService1\",command=\"MyCommand1\",target=\"MyTarget1\"} 3.5\n`
//                     + `# TYPE ${expectedName}_count gauge\n${expectedName}_count{source=\"MyApp\",instance=\"MyInstance\",service=\"MyService1\",command=\"MyCommand1\",target=\"MyTarget1\"} 11\n`
//                     + `# TYPE ${expectedName} gauge\n${expectedName}{source=\"MyApp\",instance=\"MyInstance\",service=\"MyService1\",command=\"MyCommand1\",target=\"MyTarget1\"} 2\n`
//                     + `# TYPE ${expectedName}_max gauge\n${expectedName}_max{source=\"MyApp\",instance=\"MyInstance\",service=\"MyService1\",command=\"MyCommand1\",target=\"MyTarget1\"} 113\n`
//                     + `# TYPE ${expectedName}_min gauge\n${expectedName}_min{source=\"MyApp\",instance=\"MyInstance\",service=\"MyService1\",command=\"MyCommand1\",target=\"MyTarget1\"} 13\n`
//                     + `# TYPE ${expectedName}_average gauge\n${expectedName}_average{source=\"MyApp\",instance=\"MyInstance\",service=\"MyService1\",command=\"MyCommand1\",target=\"MyTarget1\"} 13.5\n`
//                     + `# TYPE ${expectedName}_count gauge\n${expectedName}_count{source=\"MyApp\",instance=\"MyInstance\",service=\"MyService1\",command=\"MyCommand1\",target=\"MyTarget1\"} 111\n`;

//                 assert.equal(expected, body);

//                 cb();
//             }),
//         done);
//     });

//     test('KnownCounter_Exec_QueueMetrics_Good', (done) => {
//         const knownCounterExecQueueMetricsGoodTestCases = [
//             { counterName: "queue.default.sent_messages", expectedName: "queue_sent_messages" },
//             { counterName: "queue.default.received_messages", expectedName: "queue_received_messages" },
//             { counterName: "queue.default.dead_messages", expectedName: "queue_dead_messages" }
//         ];

//         async.series(
//             async.each(knownCounterExecQueueMetricsGoodTestCases, function (testData, cb) {
//                 const counterName = testData.counterName;
//                 const expectedName = testData.expectedName;

//                 let counters = new Array<Counter>();

//                 let counter1 = new Counter(counterName , CounterType.Increment);
//                 counter1.count = 1;
//                 counter1.time = RandomDateTime.nextDateTime(new Date());
//                 counters.push(counter1);

//                 let counter2 = new Counter(counterName , CounterType.Interval);
//                 counter2.count = 11;
//                 counter2.max = 13;
//                 counter2.min = 3;
//                 counter2.average = 3.5;
//                 counter2.time = RandomDateTime.nextDateTime(new Date());
//                 counters.push(counter2);

//                 let counter3 = new Counter(counterName , CounterType.LastValue);
//                 counter3.last = 2;
//                 counter3.time = RandomDateTime.nextDateTime(new Date());
//                 counters.push(counter3);

//                 let counter4 = new Counter(counterName , CounterType.Statistics);
//                 counter4.count = 111;
//                 counter4.max = 113;
//                 counter4.min = 13;
//                 counter4.average = 13.5;
//                 counter4.time = RandomDateTime.nextDateTime(new Date());
//                 counters.push(counter4);

//                 let body = PrometheusCounterConverter.toString(counters, "MyApp", "MyInstance");

//                 let expected = `# TYPE ${expectedName} gauge\n${expectedName}{source=\"MyApp\",instance=\"MyInstance\",queue=\"default\"} 1\n`
//                     + `# TYPE ${expectedName}_max gauge\n${expectedName}_max{source=\"MyApp\",instance=\"MyInstance\",queue=\"default\"} 13\n`
//                     + `# TYPE ${expectedName}_min gauge\n${expectedName}_min{source=\"MyApp\",instance=\"MyInstance\",queue=\"default\"} 3\n`
//                     + `# TYPE ${expectedName}_average gauge\n${expectedName}_average{source=\"MyApp\",instance=\"MyInstance\",queue=\"default\"} 3.5\n`
//                     + `# TYPE ${expectedName}_count gauge\n${expectedName}_count{source=\"MyApp\",instance=\"MyInstance\",queue=\"default\"} 11\n`
//                     + `# TYPE ${expectedName} gauge\n${expectedName}{source=\"MyApp\",instance=\"MyInstance\",queue=\"default\"} 2\n`
//                     + `# TYPE ${expectedName}_max gauge\n${expectedName}_max{source=\"MyApp\",instance=\"MyInstance\",queue=\"default\"} 113\n`
//                     + `# TYPE ${expectedName}_min gauge\n${expectedName}_min{source=\"MyApp\",instance=\"MyInstance\",queue=\"default\"} 13\n`
//                     + `# TYPE ${expectedName}_average gauge\n${expectedName}_average{source=\"MyApp\",instance=\"MyInstance\",queue=\"default\"} 13.5\n`
//                     + `# TYPE ${expectedName}_count gauge\n${expectedName}_count{source=\"MyApp\",instance=\"MyInstance\",queue=\"default\"} 111\n`;

//                 assert.equal(expected, body);

//                 cb();
//             }),
//         done);
//     });

//     test('EmptyCounters', (done) => {
//         let counters = new Array<Counter>();
//         let body = PrometheusCounterConverter.toString(counters, "", "");
//         assert.equal("", body);
//         done();
//     });

//     test('NullValues', (done) => {
//         let body = PrometheusCounterConverter.toString(null, "", "");
//         assert.equal("", body);
//         done();
//     });

//     test('SingleIncrement_NoLabels', (done) => {
//         let counters = new Array<Counter>();

//         let counter = new Counter("MyCounter", CounterType.Increment);
//         counter.average = 2,
//         counter.min = 1,
//         counter.max = 3,
//         counter.count = 2,
//         counter.last = 3,
//         counter.time = RandomDateTime.nextDateTime(new Date());
//         counters.push(counter);

//         let body = PrometheusCounterConverter.toString(counters, null, null);
//         const expected: string = "# TYPE mycounter gauge\nmycounter 2\n";
//         assert.equal(expected, body);

//         done();
//     });

//     test('SingleIncrement_SourceInstance', (done) => {
//         let counters = new Array<Counter>();

//         let counter = new Counter("MyCounter", CounterType.Increment);
//         counter.average = 2,
//         counter.min = 1,
//         counter.max = 3,
//         counter.count = 2,
//         counter.last = 3,
//         counter.time = RandomDateTime.nextDateTime(new Date());
//         counters.push(counter);

//         let body = PrometheusCounterConverter.toString(counters, "MyApp", "MyInstance");
//         const expected: string = "# TYPE mycounter gauge\nmycounter{source=\"MyApp\",instance=\"MyInstance\"} 2\n";
//         assert.equal(expected, body);

//         done();
//     });

//     test('MultiIncrement_SourceInstance', (done) => {
//         let counters = new Array<Counter>();

//         let counter1 = new Counter("MyCounter1", CounterType.Increment);
//         counter1.count = 2,
//         counter1.last = 3,
//         counter1.time = RandomDateTime.nextDateTime(new Date());
//         counters.push(counter1);

//         let counter2 = new Counter("MyCounter2", CounterType.Increment);
//         counter2.count = 5,
//         counter2.last = 10,
//         counter2.time = RandomDateTime.nextDateTime(new Date());
//         counters.push(counter2);

//         let body = PrometheusCounterConverter.toString(counters, "MyApp", "MyInstance");
//         const expected: string = "# TYPE mycounter1 gauge\nmycounter1{source=\"MyApp\",instance=\"MyInstance\"} 2\n"
//                                 + "# TYPE mycounter2 gauge\nmycounter2{source=\"MyApp\",instance=\"MyInstance\"} 5\n";
//         assert.equal(expected, body);

//         done();
//     });

//     test('MultiIncrement_ExecWithOnlyTwo_SourceInstance', (done) => {
//         let counters = new Array<Counter>();

//         let counter1 = new Counter("MyCounter1.exec_time", CounterType.Increment);
//         counter1.count = 2,
//         counter1.last = 3,
//         counter1.time = RandomDateTime.nextDateTime(new Date());
//         counters.push(counter1);

//         let counter2 = new Counter("MyCounter2.exec_time", CounterType.Increment);
//         counter2.count = 5,
//         counter2.last = 10,
//         counter2.time = RandomDateTime.nextDateTime(new Date());
//         counters.push(counter2);

//         let body = PrometheusCounterConverter.toString(counters, "MyApp", "MyInstance");
//         const expected: string = "# TYPE mycounter1_exec_time gauge\nmycounter1_exec_time{source=\"MyApp\",instance=\"MyInstance\"} 2\n"
//                                 + "# TYPE mycounter2_exec_time gauge\nmycounter2_exec_time{source=\"MyApp\",instance=\"MyInstance\"} 5\n";
//         assert.equal(expected, body);

//         done();
//     });

//     test('MultiIncrement_Exec_SourceInstance', (done) => {
//         let counters = new Array<Counter>();

//         let counter1 = new Counter("MyService1.MyCommand1.exec_time", CounterType.Increment);
//         counter1.count = 2,
//         counter1.last = 3,
//         counter1.time = RandomDateTime.nextDateTime(new Date());
//         counters.push(counter1);

//         let counter2 = new Counter("MyService2.MyCommand2.exec_time", CounterType.Increment);
//         counter2.count = 5,
//         counter2.last = 10,
//         counter2.time = RandomDateTime.nextDateTime(new Date());
//         counters.push(counter2);

//         let body = PrometheusCounterConverter.toString(counters, "MyApp", "MyInstance");
//         const expected: string = "# TYPE exec_time gauge\nexec_time{source=\"MyApp\",instance=\"MyInstance\",service=\"MyService1\",command=\"MyCommand1\"} 2\n"
//                                 + "# TYPE exec_time gauge\nexec_time{source=\"MyApp\",instance=\"MyInstance\",service=\"MyService2\",command=\"MyCommand2\"} 5\n";
//         assert.equal(expected, body);

//         done();
//     });

//     test('MultiInterval_Exec_SourceInstance', (done) => {
//         let counters = new Array<Counter>();

//         let counter1 = new Counter("MyService1.MyCommand1.exec_time", CounterType.Interval);
//         counter1.min = 1,
//         counter1.max = 3,
//         counter1.average = 2,
//         counter1.count = 2,
//         counter1.last = 3,
//         counter1.time = RandomDateTime.nextDateTime(new Date());
//         counters.push(counter1);

//         let counter2 = new Counter("MyService2.MyCommand2.exec_time", CounterType.Interval);
//         counter2.min = 2,
//         counter2.max = 4,
//         counter2.average = 3,
//         counter2.count = 5,
//         counter2.last = 10,
//         counter2.time = RandomDateTime.nextDateTime(new Date());
//         counters.push(counter2);

//         let body = PrometheusCounterConverter.toString(counters, "MyApp", "MyInstance");
//         const expected: string =
//                 "# TYPE exec_time_max gauge\nexec_time_max{source=\"MyApp\",instance=\"MyInstance\",service=\"MyService1\",command=\"MyCommand1\"} 3\n"
//                 + "# TYPE exec_time_min gauge\nexec_time_min{source=\"MyApp\",instance=\"MyInstance\",service=\"MyService1\",command=\"MyCommand1\"} 1\n"
//                 + "# TYPE exec_time_average gauge\nexec_time_average{source=\"MyApp\",instance=\"MyInstance\",service=\"MyService1\",command=\"MyCommand1\"} 2\n"
//                 + "# TYPE exec_time_count gauge\nexec_time_count{source=\"MyApp\",instance=\"MyInstance\",service=\"MyService1\",command=\"MyCommand1\"} 2\n"
//                 + "# TYPE exec_time_max gauge\nexec_time_max{source=\"MyApp\",instance=\"MyInstance\",service=\"MyService2\",command=\"MyCommand2\"} 4\n"
//                 + "# TYPE exec_time_min gauge\nexec_time_min{source=\"MyApp\",instance=\"MyInstance\",service=\"MyService2\",command=\"MyCommand2\"} 2\n"
//                 + "# TYPE exec_time_average gauge\nexec_time_average{source=\"MyApp\",instance=\"MyInstance\",service=\"MyService2\",command=\"MyCommand2\"} 3\n"
//                 + "# TYPE exec_time_count gauge\nexec_time_count{source=\"MyApp\",instance=\"MyInstance\",service=\"MyService2\",command=\"MyCommand2\"} 5\n";
//         assert.equal(expected, body);

//         done();
//     });

//     test('MultiStatistics_Exec_SourceInstance', (done) => {
//         let counters = new Array<Counter>();

//         let counter1 = new Counter("MyService1.MyCommand1.exec_time", CounterType.Statistics);
//         counter1.min = 1,
//         counter1.max = 3,
//         counter1.average = 2,
//         counter1.count = 2,
//         counter1.last = 3,
//         counter1.time = RandomDateTime.nextDateTime(new Date());
//         counters.push(counter1);

//         let counter2 = new Counter("MyService2.MyCommand2.exec_time", CounterType.Statistics);
//         counter2.min = 2,
//         counter2.max = 4,
//         counter2.average = 3,
//         counter2.count = 5,
//         counter2.last = 10,
//         counter2.time = RandomDateTime.nextDateTime(new Date());
//         counters.push(counter2);

//         let body = PrometheusCounterConverter.toString(counters, "MyApp", "MyInstance");
//         const expected: string =
//             "# TYPE exec_time_max gauge\nexec_time_max{source=\"MyApp\",instance=\"MyInstance\",service=\"MyService1\",command=\"MyCommand1\"} 3\n"
//             + "# TYPE exec_time_min gauge\nexec_time_min{source=\"MyApp\",instance=\"MyInstance\",service=\"MyService1\",command=\"MyCommand1\"} 1\n"
//             + "# TYPE exec_time_average gauge\nexec_time_average{source=\"MyApp\",instance=\"MyInstance\",service=\"MyService1\",command=\"MyCommand1\"} 2\n"
//             + "# TYPE exec_time_count gauge\nexec_time_count{source=\"MyApp\",instance=\"MyInstance\",service=\"MyService1\",command=\"MyCommand1\"} 2\n"
//             + "# TYPE exec_time_max gauge\nexec_time_max{source=\"MyApp\",instance=\"MyInstance\",service=\"MyService2\",command=\"MyCommand2\"} 4\n"
//             + "# TYPE exec_time_min gauge\nexec_time_min{source=\"MyApp\",instance=\"MyInstance\",service=\"MyService2\",command=\"MyCommand2\"} 2\n"
//             + "# TYPE exec_time_average gauge\nexec_time_average{source=\"MyApp\",instance=\"MyInstance\",service=\"MyService2\",command=\"MyCommand2\"} 3\n"
//             + "# TYPE exec_time_count gauge\nexec_time_count{source=\"MyApp\",instance=\"MyInstance\",service=\"MyService2\",command=\"MyCommand2\"} 5\n";
//         assert.equal(expected, body);

//         done();
//     });

//     test('MultiLastValue_Exec_SourceInstance', (done) => {
//         let counters = new Array<Counter>();

//         let counter1 = new Counter("MyService1.MyCommand1.exec_time", CounterType.LastValue);
//         counter1.count = 2,
//         counter1.last = 3,
//         counter1.time = RandomDateTime.nextDateTime(new Date());
//         counters.push(counter1);

//         let counter2 = new Counter("MyService2.MyCommand2.exec_time", CounterType.LastValue);
//         counter2.count = 5,
//         counter2.last = 10,
//         counter2.time = RandomDateTime.nextDateTime(new Date());
//         counters.push(counter2);

//         let body = PrometheusCounterConverter.toString(counters, "MyApp", "MyInstance");
//         const expected: string = "# TYPE exec_time gauge\nexec_time{source=\"MyApp\",instance=\"MyInstance\",service=\"MyService1\",command=\"MyCommand1\"} 3\n"
//                                 + "# TYPE exec_time gauge\nexec_time{source=\"MyApp\",instance=\"MyInstance\",service=\"MyService2\",command=\"MyCommand2\"} 10\n";

//         assert.equal(expected, body);

//         done();
//     });
// });