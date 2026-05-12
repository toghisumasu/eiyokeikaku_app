require "test_helper"

class FoodsControllerTest < ActionDispatch::IntegrationTest
  test "should get search" do
    get foods_search_url
    assert_response :success
  end
end
