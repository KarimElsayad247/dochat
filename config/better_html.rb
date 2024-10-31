if Rails.env.development?
  BetterHtml.config = BetterHtml::Config.new(
    YAML.load_file(Rails.root.join(".better_html.yml"), permitted_classes: [ Regexp ])
  )
end
