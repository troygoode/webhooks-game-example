express = require 'express'
sha1 = require 'sha1'
config = require './config'

app = module.exports = express()
app.enable 'trust proxy'
app.use express.bodyParser()
app.use app.router

app.post '/', (req, res, next) ->
  switch req.body.messageType
    when 'VERIFY'
      res.json
        secret: sha1(config.secret)
    else
      next('UNKNOWN_MESSAGE_TYPE')

app.listen config.port, ->
  console.log "Consumer listening on port #{config.port}."
