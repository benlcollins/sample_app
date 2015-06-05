require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  
  def setup
  	@user = users(:ben)
  	@other_user = users(:archer)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should redirect edit when not logged in" do
  	get :edit, id: @user
  	assert_not flash.empty?
  	assert_redirected_to login_path
  end

  test "should redirect update when not logged in" do
  	patch :update, id: @user, user: { name: @user.name, email: @user.email }
  	assert_not flash.empty?
  	assert_redirected_to login_path
  end

  test "should redirect edit when logged in as different user" do
  	log_in_as(@other_user)
  	get :edit, id: @user
  	assert flash.empty?
  	assert_redirected_to root_path
  end

  test "should redirect update when logged in as different user" do
  	log_in_as(@other_user)
  	patch :update, id: @user, user: { name: @user.name, email: @user.email }
  	assert flash.empty?
  	assert_redirected_to root_path
  end

  test "should redirect users index when not logged in" do
  	get :index
  	assert_redirected_to login_path
  end

  test "should redirect destroy to login page if no user logged in" do
    assert_no_difference 'User.count' do
      delete :destroy, id: @user
    end
    assert_redirected_to login_path
  end

  test "should redirect destroy when logged in as non admin" do
    log_in_as(@other_user)
    assert_no_difference 'User.count' do
      delete :destroy, id: @user
    end
    assert_redirected_to root_path
  end
  
end
