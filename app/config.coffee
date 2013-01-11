
express = require 'express'
app = module.exports = express();
app.use express.logger()

# Configuration

app.configure ->
	app.set "views", "#{__dirname}/views"
	app.set 'view engine', 'jade'
	app.set 'view options', { layout: false }

	app.use express.bodyParser()
	app.use express.methodOverride()
	app.use express.cookieParser("shhhh, very secret")
	app.use express.session()
	app.use app.router

	publicDir = "#{__dirname}/public"
	assetsDir = "#{__dirname}/assets"

	app.use require('connect-assets') { src: assetsDir }
	app.use express.static(publicDir)

	# Database setup
	app.dbAdapter = require('./mysql.coffee')["db"]
	app.dbAdapter.query "use mydatabase"
	app.hash = require('./pass').hash
	###
	don't forget to use dbAdapter.escape( attributes for query)
	###
	return


app.configure 'development', ->
	app.use express.errorHandler { dumpExceptions: true, showStack: true }
	return


app.configure 'production', ->
	app.use express.errorHandler()
	return

