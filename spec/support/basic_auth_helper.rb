module BasicAuthHelper
  # Basic credentials request
  def basic_credentials(user, pass)
    {
      'HTTP_AUTHORIZATION' => ActionController::HttpAuthentication::Basic.
        encode_credentials(user, pass)
    }
  end
end
