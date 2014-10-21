require 'test_helper'

class TeamTest < ActiveSupport::TestCase
  test "logo_image function" do
    # just test if it doesnt fail
    assert_equal nil, teams(:one).logo_image(nil)
    assert_equal nil, teams(:one).logo_image(:icon)
    assert_equal nil, teams(:one).logo_image(:small)
    assert_equal nil, teams(:one).logo_image(:medium)
    assert_equal nil, teams(:one).logo_image(:large)
  end
end
