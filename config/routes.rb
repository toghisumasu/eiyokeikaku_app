Rails.application.routes.draw do
  # 食品検索
  get  "foods/search", to: "foods#search"
  post "foods/add_to_plan", to: "foods#add_to_plan"

  # 献立
  resources :meal_plans, only: [:new, :create, :show] do
    member do
      delete "items/:item_id", to: "meal_plans#destroy_item", as: :destroy_item
    end
  end

  # トップページ
  root "meal_plans#new"
end
