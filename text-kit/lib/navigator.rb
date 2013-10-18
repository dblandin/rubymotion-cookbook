class Navigator
  attr_reader :router

  class << self
    def shared
      @instance ||= Navigator.new
    end

    def config(&block)
      block.call(shared)
    end
  end

  def initialize(options = {})
    Log.info 'Navigator initializing'

    @router = options[:router] || Routable::Router.router
  end

  def map(&block)
    block.call(router)
  end

  def clear_cache
    router.shared_vc_cache.clear
  end

  def navigation_controller
    router.navigation_controller
  end

  def start!
    LocalRoutes.new(router).map_urls
  end

  def register_nav_controller(nav_controller)
    router.navigation_controller = nav_controller
  end

  def open(route, animated = true, &block)
    unless route == history.last
      history << route

      router.open(route, animated, &block)
    end
  end

  def history
    @history ||= []
  end

  def push(controller)
    navigation_controller.pushViewController(controller, animated: true)
  end

  def pop
    history.pop

    router.pop
  end

  def current_route
    history.last
  end
end

