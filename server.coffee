express = require 'express'
sha1 = require 'sha1'
config = require './config'

app = module.exports = express()
app.enable 'trust proxy'
app.use express.bodyParser()
app.use app.router

pick_random = (array) ->
  array[Math.floor(Math.random() * array.length)]

noop = (message) ->
  action: 'NOOP'
  message:
    secret: sha1(config.secret)

move_random = (message) ->
  action: 'MOVE'
  message:
    secret: sha1(config.secret)
    target: pick_random(message.location.exits).id

app.post '/', (req, res, next) ->
  switch req.body.request
    when 'VERIFY'
      res.json
        action: 'VERIFY'
        message:
          secret: sha1(config.secret)
    when 'TICK'
      res.json move_random(req.body.message)
    else
      next('UNKNOWN_MESSAGE_TYPE')

app.listen config.port, ->
  console.log "Consumer listening on port #{config.port}."
