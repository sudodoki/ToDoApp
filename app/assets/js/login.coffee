is_valid = (type = 'not empty', value = '') ->
  length = value.length
  return false if length is 0
  value.match(/\w+/)[0].length is length 



displayInvalid = (id) ->
  $("#{id} input").map (el) ->    
    unless is_valid($(this).attr('id'), $(this).val())
      console.log "#{$(this).attr('id')} isn't valid"

listenForm = (id, url) ->
  $(id).on "submit", (e) ->
    result = undefined
    e.preventDefault()
    result = {}
    $("" + id + " input").map (index, el) ->
      if is_valid($(this).attr("id"), $(this).val()) and (result?)
        result["#{$(this).attr('id')}"] = $(this).val()
      else
        result = undefined
    if result
      dataToSend = JSON.stringify result
      console.log dataToSend 
      $.ajax(
        type: 'POST'
        url: url
        data: dataToSend
        success: (res) -> 
          if res.success? 
            console.log 'Success', res.success
            window.location.href = '/'
          else
            console.log 'Error', res.error
        error: (xhr, ajaxOptions, thrownError) -> 
          console.log 'Error', xhr.status, thrownError
        contentType: "application/json"
        dataType: "json"
      )
    else
      displayInvalid(id)

listenRegister = () ->
  id = '#register'
  url = '/register'
  listenForm(id, url) 

  # $()

listenLogin = () ->
  id = "#login"
  url = "/login"
  listenForm(id, url)
  

  $('.register').on 'click', (e) ->
    $(e.target).off 'click'
    console.log $(e.target).parent().remove()
    $('#login').find('legend').html('Sign up with your account')
    $('#login').off 'submit'
    $('#login').attr('id', 'register')
    
    extraInput = """
      <div class="control-group">
        <label for="inputPasswordConfirmation" class="control-label">Confirm password</label>
        <div class="controls">
          <input id="passwordConfirm" type="password" placeholder="Retype password here">
          </div>
        </div>
    """
    $(extraInput).insertAfter('#register .control-group:last')
    listenRegister()
  
$ ->
  listenLogin()