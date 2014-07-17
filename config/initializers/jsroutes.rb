JsRoutes.setup do |config|
  if Rails.env.production?
    config.option.prefix = 'ceps'
  end
end