#mockを使ってテストするための設定

module OmniauthMock
OmniAuth.config.test_mode=true

  def self.google_mock
    OmniAuth.config.mock_auth[:google_oauth2]=OmniAuth::AuthHash.new({
      "provider"=>"google_oauth2",
      "uid"=>"111111111",
      "info"=>{
        "name"=>"Example User",
        "email"=>"test1@example.com",
      }
    })
  end

  def self.line_mock
    OmniAuth.config.mock_auth[:line]=OmniAuth::AuthHash.new({
      "provider"=>"line",
      "uid"=>"22222222",
      "info"=>{
        "name"=>"Example User",
        "email"=>"test1@example.com",
      }
    })
  end

end
