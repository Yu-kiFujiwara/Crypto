require 'test_helper'

class HomesControllerTest < ActionDispatch::IntegrationTest
  test 'should get index' do
    get home_index_url
    assert_response :success
  end
end
