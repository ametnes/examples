const alarms = require('./alarms');
const assert = require('assert');
const sinon = require('sinon');

describe("Alarms", () => {
    it ('can be added', () => {
        // const requests = new Request();
        // const put = api.put(requests, config.profile.DEV);
        const request = {
          headers: {
            authorization: 'Usdz3323233eeewe'
          },
          body: {
              version: 'v1',
              database_rating: '1',
              desired_databases: 'Etcd',
              applications_built: ''
          }
        };

        const responseStab = sinon.stub();
        const statusStab = sinon.stub().returns({send: responseStab});
        const response = {
            status: statusStab
        };

        alarms(request, response);
        sinon.assert.calledWith(statusStab, 200);
        sinon.assert.called(responseStab);
        const args = responseStab.getCall(0).args[0];
        sinon.assert.match(args, request.body);
        sinon.assert.match(`${config.profile.DEV.SERVICE_ENDPOINT}/alarms`, requests.url);
        // sinon.assert.match('POST', requests.method);
        // sinon.assert.match(request.headers.authorization, requests.headers['Authorization']);

    });
});
