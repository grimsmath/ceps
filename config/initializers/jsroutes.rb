JsRoutes.setup do |config|
  if Rails.env.production?
    config.prefix = '/ceps'
  end
end