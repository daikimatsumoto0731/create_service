require "test_helper"

class UserSessionsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get user_sessions_index_url
    assert_response :success
  end
end
