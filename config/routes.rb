Crawler::Application.routes.draw do
  root 'search#index', as: :root
  
  get 'search'         => 'search#index',          as: :search
  get 'result'         => 'search#result',         as: :result
  get 'update_results' => 'search#update_results', as: :update_results
end
