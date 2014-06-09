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

    #sends cached transactions for lazyness
    @app.get '/transactions', (req, res) =>
      res.send require './cached-transactions'
      #@swedbank.get_transactions (data) -> res.send data

  allowCrossDomain: (req, res, next) ->
    res.header('Access-Control-Allow-Origin', "*")
    res.header('Access-Control-Allow-Methods', 'GET,PUT,POST,DELETE')
    res.header('Access-Control-Allow-Headers', 'X-Requested-With')
    next()

  start: ->
    @app = express()
    @routes()

    @app.use compress()
    @app.use bodyParser()
    @app.use @allowCrossDomain
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
