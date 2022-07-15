module RequestSpecHelper
  def json_body
    JSON.parse(response.body)
  end

  def login_with_api(user)
    post login_url, params: {
      user: {
        email: user.email,
        password: user.password
      }
    }
  end

  # Storing it in a method so it is easing to change
  def login_url
    '/api/v1/sign_in'
  end
end
