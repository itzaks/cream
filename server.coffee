Swedbank   = require './swedbank-scraper'
DotEnv     = require 'dotenv-node'
express    = require 'express'
compress   = require 'compression'
bodyParser = require 'body-parser'
logger     = require 'morgan'
path       = require 'path'
coffee     = require 'coffee-script'

new DotEnv()

class Server
  constructor: (@port = process.env.PORT or 3333)->
    @start()
    @swedbank = new Swedbank
      number: process.env.SWEDBANK_USER
      pass: process.env.SWEDBANK_PASS

  routes: ->
    @app.get '/', (req, res) =>
      res.render 'index.static.jade'

    @app.get '/transactions', (req, res) =>
      #sends cached transactions for lazyness
      res.send require './cached-transactions'

      #@swedbank.get_transactions (transactions) ->
      #  res.send transactions

  start: ->
    @app = express()
    @routes()

    @app.use compress()
    @app.use bodyParser()
    @app.use express.static (path.resolve "public")
    @app.use logger 'dev'

    @app.set 'views', __dirname + '/app'
    @app.set 'view engine', 'jade'

    @app.listen @port
    console.info "server up on #{ @port }"

#start from brunch
exports.startServer = (port, path, callback) -> 
  new Server(port)
#start directly if not run from brunch
new Server() unless module.parent

