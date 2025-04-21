Rails.application.routes.draw do
  root to: 'news#index'
  post 'news/scrape', to: 'news#scrape'
end
