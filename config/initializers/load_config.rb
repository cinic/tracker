APP_CONFIG = YAML.load(
  File.read(Rails.root.join('config', 'secrets.yml'))
)[Rails.env]
