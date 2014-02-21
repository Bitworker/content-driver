Crawler::Application.routes.draw do
  root 'search#index', as: :root
  
  get 'search' => 'search#index',  as: :search
  get 'result' => 'search#result', as: :result
end
