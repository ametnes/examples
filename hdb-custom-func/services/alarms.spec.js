const alarms = require('./alarms');
const assert = require('assert');

describe("Alarm Service", () => {
    it ('can be added', () => {
        const config = {
          alarms: {
            schema: 'app',
            table: 'alarms'
          }
        }

        const items = [
          {
            'id': 1234,
            'severity': 'minor',
            'source': 'generator',
            'name': 'low fuel'
          }
        ]

        const request = {
          body: {
            count: items.length,
            items: items
          }
        }
        const body = alarms.create(request, config)

        assert.deepEqual(body, {
            "operation": "upsert",
            "schema": 'app',
            "table": 'alarms',
            "records": items
        });
    });
});
