require 'test_helper'

class FunctionalTestHelper < ActionController::TestCase
  setup do
    @article = Article.first
    login_user users(:admin)
  end

  teardown do
    logout_user
  end
end
