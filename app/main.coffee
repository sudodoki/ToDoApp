routes = require './routes'
app = module.exports = require './config'

# Routes
app.get '/', routes.restrict, routes.index
app.get '/login', routes.login
app.get '/logout', (req, res) ->
  req.session.destroy () ->
    res.redirect('/')
  

app.post '/login', (req, res) ->
  error = false
  sql = "SELECT * FROM users WHERE login = " + app.dbAdapter.escape(req.body.username)
  
  app.dbAdapter.query sql, (err, results) ->
    if results.length is 0
      error = true
    req.app.hash(req.body.password, (err, salt, hash) ->
      throw err if (err)  
      if results.salt = salt and results.hash = hash
        error = false
    #read database entry
    
    if error
      data = JSON.stringify {'error' : "no such user or password doesn't match"}
      # handle error
    else
      req.session.user = true
      data = JSON.stringify {'success' : 'logged in successfully'}
    res.writeHead(200, {'Content-Type': 'text/html'})
    res.end data      
    )

app.post '/register', (req, res) ->
  req.app.hash(req.body.password, (err, salt, hash) ->
    throw err if (err)  
    login = req.body.username
    sql = "SELECT * FROM users WHERE login = " + app.dbAdapter.escape(login)
    app.dbAdapter.query sql, (err, results) ->
      if results?.length is 0
        app.dbAdapter.query "INSERT INTO users SET ?", {login: login, hash: hash, salt: salt}, (err, result) ->
          throw err if (err)
          console.log result.insertId
          req.session.user = true
          data = JSON.stringify {'success' : 'successfully created new user'}
          res.writeHead(200, {'Content-Type': 'text/html'})
          res.end data 
      else
        if err 
         data = JSON.stringify {'error' : err}
        else
          data = JSON.stringify {'error' : 'login is already taken, sorry'}
        res.writeHead(200, {'Content-Type': 'text/html'})
        res.end data      

  )