# == Route Map
#
#      Prefix Verb  URI Pattern                 Controller#Action
#        root GET   /                           options#new
#     options GET   /options(.:format)          options#index
#             POST  /options(.:format)          options#create
# edit_option GET   /options/:id/edit(.:format) options#edit
#      option GET   /options/:id(.:format)      options#show
#             PATCH /options/:id(.:format)      options#update
#             PUT   /options/:id(.:format)      options#update
#

Rails.application.routes.draw do
  
  root 'options#new'
  resources :options, except: [ :destroy, :new, :show ]

end
