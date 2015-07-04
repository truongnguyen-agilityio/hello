require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  test "Invalid signup information" do
  	get signup_path
  	assert_no_difference 'User.count' do
  		post users_path, user: {name: '', email: 'truong@gmail', password: 'abc', password_confirmation: '123'}
  	end
  	assert_template 'users/new'
  end

  test "Valid signup information" do
  	get signup_path
  	assert_difference 'User.count', 1 do
  		post_via_redirect users_path, user: {name: 'truong', email: 'truong@gmail.com', password: 'password', password_confirmation: 'password'}
  	end
  	assert_template 'users/show'
  end
end
