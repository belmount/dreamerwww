# encoding: UTF-8

Estatee::Application.routes.draw do

  devise_for :users 

  resources :laws

  root :to=>'home#index'
  match 'home/search', :controller => 'agency', :action=>'search'
  match 'home/downloads', :controller=>'home', :action=>'downloads'
  match 'news',  :controller=>'laws', :action=>'index'
  match 'agency/list/name/:name', :controller => 'agency', :action=>'show_by_name'
  match 'agency/show_joins/:id', :controller=>'agency', :action=>'show_joins'

  resources :agency do 
    collection do 
      get 'show_by_name'
      get 'by_area'
    end
  end

  resources :complains do
    collection do
      post 'verify'
      post 'get_items'
    end
  end

	resources :estate do 
    collection do 
      get 'index'
      get 'show'
      get 'search'
    end
  end

end
