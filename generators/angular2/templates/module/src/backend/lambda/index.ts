let ApiBuilder = require('claudia-api-builder'),
    api = new ApiBuilder();

// Create an authorizes by name authorizer
// api.registerAuthorizer('authorizer', {
//   lambdaName: 'authorizer',
//   lambdaVersion: true
// });

import { Handler as Route1Handler } from "./route_1"

// Add the custom authorizer if needed.
// Mind, that you have to register the endpoint in the authorizer lambda, in the lambdas repo, and deploy a new authorizer lambda version!
//
api.post('/route_1', Route1Handler)

module.exports = api
