require 'test_helper'

class PlayerTest < ActiveSupport::TestCase
  test "nick_or_name function" do
    @player = Player.new(
      :first_name => "Pepa",
      :second_name => "z Depa",
      :nick => "PepaZDepa"
    )
    assert @player.save
    
    assert_equal "PepaZDepa", @player.nick_or_name
    
    @player.nick = nil;
    assert @player.save
    assert_equal "Pepa z Depa", @player.nick_or_name
    
    @player.first_name = nil;
    assert @player.save
    assert_equal "z Depa", @player.nick_or_name
    
    @player.first_name = "Pepa";
    @player.second_name = nil;
    assert @player.save
    assert_equal "Pepa", @player.nick_or_name
    
    @player.first_name = nil;
    assert @player.save
    assert_equal nil, @player.nick_or_name
  end
end
