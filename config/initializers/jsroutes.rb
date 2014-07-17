JsRoutes.setup do |config|
  if Rails.env.development?
    config.prefix = 'ceps'
  end
end