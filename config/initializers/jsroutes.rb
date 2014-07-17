JsRoutes.setup do |config|
  if Rails.env.development?
    config.option.prefix = 'ceps'
  end
end