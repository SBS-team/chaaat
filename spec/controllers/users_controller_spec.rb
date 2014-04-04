require 'spec_helper'

describe UsersController do
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:persons)
  end
end
