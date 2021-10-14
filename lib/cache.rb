class Cache
  DEFAULT_TTL = 24*60*60

  def self.set(key, data, ttl = nil)
    $redis ||= Redis.new(url: ENV["REDIS_URL"])
    
    puts ">>> Redis.set(#{key})"
    $redis.setex(key, ttl || DEFAULT_TTL, data.to_json)
  end

  def self.get(key)
    $redis ||= Redis.new(url: ENV["REDIS_URL"])
    
    puts "<<< Redis.get(#{key})"
    data = $redis.get(key)
    data ? JSON.parse(data) : nil
  end

  def self.keys
    $redis ||= Redis.new(url: ENV["REDIS_URL"])

    $redis.keys
  end
end