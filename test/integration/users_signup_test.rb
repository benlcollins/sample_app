require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
	
	test "invalid signup information" do
		get signup_path
		assert_no_difference 'User.count' do
			post users_path, user: { name: '',
									 email: 'user@invalid',
									 password: 'foo',
									 password_confirmation: 'bar' }
		end
		assert_not flash.empty?
		assert_equal flash[:danger], "Invalid signup information", "Invalid login flash message not showing"
		assert_template 'users/new'
		assert_select 'div#error_explanation'
		assert_select 'div.alert.alert-danger'
		get root_path
		assert flash.empty?
	end

	test "valid signup information" do
		get signup_path
		assert_difference 'User.count', 1 do
			post_via_redirect users_path, user: { name: 'Rails Tutorial',
									 email: 'example@railstutorial.org',
									 password: 'foobar',
									 password_confirmation: 'foobar' }
		end
		assert_template 'users/show'
		assert_not flash.empty?
		assert_equal flash[:success], "Welcome to the sample app!", "Valid signup flash message not showing correctly"
		assert is_logged_in?
		get root_path
		assert flash.empty?
	end
end
