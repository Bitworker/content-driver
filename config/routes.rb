Crawler::Application.routes.draw do
  root 'search#search', as: :root
  
  get 'search'         => 'search#search',         as: :search
  get 'result'         => 'search#result',         as: :result
  get 'update_results' => 'search#update_results', as: :update_results
end
