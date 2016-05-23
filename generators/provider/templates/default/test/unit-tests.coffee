describe.skip "<%= c.providerNameFQ %> unit tests", ->
  TestProvider = null

  beforeEach ->
    angular.module 'testModule', [require('..')]
    .config ['<%= c.providerNameFQ %>Provider', (Provider) ->
      TestProvider = Provider
    ]

    angular.mock.module 'testModule'
    inject ->

  it "should pass", ->
    # Usage: TestProvider.method()
    expect(true).true