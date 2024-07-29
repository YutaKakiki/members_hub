#mockを使ってテストするための設定

module OmniauthMock
OmniAuth.config.test_mode=true

  def self.google_mock
    OmniAuth.config.mock_auth[:google_oauth2]=OmniAuth::AuthHash.new({
      "provider"=>"google_oauth2",
      "uid"=>"10000000000",
      "info"=>{
        "name"=>"Example User",
        "email"=>"test1@example.com",
      }
    })
  end

  def line_mock
  end

end
