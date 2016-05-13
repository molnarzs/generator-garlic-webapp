express = require 'express'
router = express.Router()

router.route '/config'
  .get (req, res) -> console.log "Success"

module.exports = router