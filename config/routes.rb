Rails.application.routes.draw do
  # 食品検索
  get  "foods/search", to: "foods#search"
  post "foods/add_to_plan", to: "foods#add_to_plan"

  # 料理
  resources :dishes, only: [:index]

  # 献立内の食品明細（分量インライン編集）
  resources :menu_items, only: [:update]

  # 献立
  resources :meal_plans, only: [:index, :new, :create, :show, :edit, :update] do
    member do
      delete "items/:item_id", to: "meal_plans#destroy_item", as: :destroy_item
      get    :download_md
      get    :print_hancho
    end
  end

  # トップページ
  root "meal_plans#new"
end
