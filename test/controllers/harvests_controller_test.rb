# frozen_string_literal: true

require 'test_helper'

class HarvestsControllerTest < ActionDispatch::IntegrationTest
  test 'should get new' do
    get harvests_new_url
    assert_response :success
  end

  test 'should get create' do
    get harvests_create_url
    assert_response :success
  end
end
