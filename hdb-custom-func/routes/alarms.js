
const config = require('../config');
const service = require('../services/alarms');

const alarms = async (server, { hdbCore, logger }) => {
	server.route({
		url: '/alarms',
		method: 'POST',
		// preValidation: (request, replay, done) => customValidation(request, done, { hdbCore, logger }),
		handler: (request) => {
			const body = service.create(request, config);

			/**
			 * requestWithoutAuthentication bypasses the standard HarperDB authentication.
			 * YOU MUST ADD YOUR OWN preValidation method above, or this method will be available to anyone.
			 */
			return hdbCore.requestWithoutAuthentication({ body });
		},
	});
};

module.exports.default = alarms;
