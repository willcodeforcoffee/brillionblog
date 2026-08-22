require "test_helper"

class SettingTest < ActiveSupport::TestCase
  test "instance returns the single settings row" do
    assert_equal settings(:default), Setting.instance
  end

  test "instance creates a row if none exists" do
    Setting.delete_all
    assert_difference -> { Setting.count }, 1 do
      Setting.instance
    end
  end
end
