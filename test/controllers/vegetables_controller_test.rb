# frozen_string_literal: true

require 'test_helper'

class VegetablesControllerTest < ActionDispatch::IntegrationTest
  test 'should get index' do
    get vegetables_index_url
    assert_response :success
  end
end
