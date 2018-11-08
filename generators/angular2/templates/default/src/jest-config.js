let globalConf = require('../jest-config')

globalConf.coverageThreshold = {
    "global": {
        "statements": 20,
        "branches": 20,
        "functions": 20,
        "lines": 20
    }
}

Object.assign(globalConf.moduleNameMapper, {
    "@common.features/(.*)": "<rootDir>/src/subrepos/gtrack-common-ngx/app/features/$1",
    "@web.features/(.*)": "<rootDir>/src/subrepos/gtrack-common-web/features/$1"
})

module.exports = globalConf