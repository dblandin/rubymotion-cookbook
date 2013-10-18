class Dispatcher
  def self.shared
    @instance ||= Dispatcher.new
  end

  def post(notification, object: object, info: info)
    NSNotificationCenter.defaultCenter.postNotificationName(notification, object: object, userInfo: info)
  end

  def post(notification)
    post(notification, object: nil, info: nil)
  end

  def post(notification, info: info)
    post(notification, object: nil, info: info)
  end

  def post(notification, object: object)
    post(notification, object: object, info: nil)
  end

  def observe(name, withBlock: block)
    NSNotificationCenter.defaultCenter.addObserverForName(name, object: nil, queue: nil, usingBlock: block)
  end

  def observe(name, selector, observer)
    NSNotificationCenter.defaultCenter.addObserver(observer, selector: selector, name: name, object: nil)
  end

  def unobserve(observer)
    NSNotificationCenter.defaultCenter.removeObserver(observer, name: nil, object: nil)
  end
end
