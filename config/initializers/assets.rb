# Load sass files from node modules deps
# Rails.application.config.sass.load_paths << Rails.root.join('node_modules')
Rails.application.config.assets.paths << Rails.root.join('node_modules')
Rails.application.config.assets.precompile += %w( frontend.css frontend.js )
