###
GET home page.
###

exports.restrict = (req, res, next) ->
  if req.session.user
    next()
  else
    res.render 'login', {title: 'Please log in', flash: 'You need to log in'}

exports.index = (req, res) ->
  res.render 'index', { title: 'ToDo App'}

###
GET login page.
###

exports.login = (req, res) ->
  res.render 'login', { title: 'Please log in', flash: ''} 

