mysql = require('mysql')

# TODO SET UP READING FROM FILE FOR USER AND PASSWORD
user = 'root'
password = ''
database = 'mydatabase'
db = mysql.createConnection
 user: user  
 password: password
 database: database

db.handleDisconnect = () ->
	db.on "error", (err) ->
    return  unless err.fatal
    throw err  if err.code isnt "PROTOCOL_CONNECTION_LOST"
    console.log "Re-connecting lost connection: " + err.stack
    connection = mysql.createConnection(connection.config)
    handleDisconnect connection
    exports.db = connection.connect()
exports.db = db

  


