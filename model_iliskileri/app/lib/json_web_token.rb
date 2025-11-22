class JsonWebToken
  SECRET_KEY = Rails.application.secret_key_base || ENV['SECRET_KEY_BASE']
  ALGORITHM = 'HS256'

  def self.encode(payload = {}, exp: 24.hours.from_now, **claims)
    data = payload.deep_dup
    data.merge!(claims)
    data[:exp] = exp.to_i
    JWT.encode(data, SECRET_KEY, ALGORITHM)
  end

  def self.decode(token)
    decoded = JWT.decode(token, SECRET_KEY, true, { algorithm: ALGORITHM })[0]
    HashWithIndifferentAccess.new(decoded)
  end
end
