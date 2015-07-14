module OmniAuthHelpers
  def auth_hash
    OmniAuth::AuthHash.new({
      provider: 'github',
      uid: '123545',
      info: {
        nickname: 'nickname',
        image: 'http://example.com/'
      },
      credentials: {
        token: 'token',
      }
    })
  end
end

