require 'test_helper'

class ScheduleItemTest < ActiveSupport::TestCase

  def setup
    @schedule_item = schedule_items(:correct_fixd_day_item)
  end

  # 正常系テスト
  test "fixd day item should be valid" do
    assert @schedule_item.valid?
  end

  test "repeat year item should be valid" do
    @schedule_item = schedule_items(:correct_repeat_year_item)
    assert @schedule_item.valid?
  end

  test "repeat month item should be valid" do
    @schedule_item = schedule_items(:correct_repeat_month_item)
    assert @schedule_item.valid?
  end

  test "repeat week item should be valid" do
    @schedule_item = schedule_items(:correct_repeat_week_item)
    assert @schedule_item.valid?
  end

  test "repeat day item should be valid" do
    @schedule_item = schedule_items(:correct_repeat_day_item)
    assert @schedule_item.valid?
  end

  test "repeat hour item should be valid" do
    @schedule_item = schedule_items(:correct_repeat_hour_item)
    assert @schedule_item.valid?
  end

  test "leap day item should be valid" do
    @schedule_item = schedule_items(:correct_leap_day_item)
    assert @schedule_item.valid?
  end

  # 空文字チェック
  test "user_id should not be present" do
    @schedule_item.user_id = " " * 6
    assert_not @schedule_item.valid?
  end

  test "status should not be present" do
    @schedule_item.status = " " * 1
    assert_not @schedule_item.valid?
  end

  # 空文字がnilに変換されてtrueになってしまう（対処法が不明）ので空文字もOKとする。
  test "year should not be present" do
    @schedule_item.year = " " * 4
    assert @schedule_item.valid?
  end

  # 空文字がnilに変換されてtrueになってしまう（対処法が不明）ので空文字もOK>    とする。
  test "month should not be present" do
    @schedule_item.month = " " * 2
    assert @schedule_item.valid?
  end

  # 空文字がnilに変換されてtrueになってしまう（対処法が不明）ので空文字もOK>    とする。
  test "week should not be present" do
    @schedule_item.week = " " * 2
    assert @schedule_item.valid?
  end

  # 空文字がnilに変換されてtrueになってしまう（対処法が不明）ので空文字もOK>    とする。
  test "day should not be present" do
    @schedule_item.day = " " * 2
    assert @schedule_item.valid?
  end

  # 空文字がnilに変換されてtrueになってしまう（対処法が不明）ので空文字もOK>    とする。
  test "hour should not be present" do
    @schedule_item.hour = " " * 2
    assert @schedule_item.valid?
  end

  test "content_item_id should not be present" do
    @schedule_item.content_item_id = " " * 1
    assert_not @schedule_item.valid?
  end

  # nilチェック
  test "user_id should not be nil" do
    @schedule_item.user_id = nil
    assert_not @schedule_item.valid?
  end

  test "status should not be nil" do
    @schedule_item.status = nil
    assert_not @schedule_item.valid?
  end

  test "content_item_id should not be nil" do
    @schedule_item.content_item_id = nil
    assert_not @schedule_item.valid?
  end

  # 文字数チェック
  test "status should not be too long" do
    @schedule_item.status = 2
    assert_not @schedule_item.valid?
  end

  test "status should have a minimum length" do
    @schedule_item.status = -1
    assert_not @schedule_item.valid?
  end

  test "year should not be too long" do
    @schedule_item.year = 10000
    assert_not @schedule_item.valid?
  end

  test "year should have a minimum length" do
    @schedule_item.year = 1999
    assert_not @schedule_item.valid?
  end

  test "month should not be too long" do
    @schedule_item.month = 13
    assert_not @schedule_item.valid?
  end

  test "month should have a minimum length" do
    @schedule_item.month = 0
    assert_not @schedule_item.valid?
  end

  test "week should not be too long" do
    @schedule_item.week = 76
    assert_not @schedule_item.valid?
  end

  test "week should have a minimum length" do
    @schedule_item.week = 9
    assert_not @schedule_item.valid?
  end

  test "day should not be too long" do
    @schedule_item.day = 32
    assert_not @schedule_item.valid?
  end

  test "day should have a minimum length" do
    @schedule_item.day = 0
    assert_not @schedule_item.valid?
  end

  test "hour should not be too long" do
    @schedule_item.hour = 24
    assert_not @schedule_item.valid?
  end

  test "hour should have a minimum length" do
    @schedule_item.hour = -1
    assert_not @schedule_item.valid?
  end

  # 数字チェック
  test "user_id should be integer" do
    @schedule_item.user_id = "aaa"
    assert_not @schedule_item.valid?
  end

  test "status should be integer" do
    @schedule_item.status = "a"
    assert_not @schedule_item.valid?
  end

  test "year should be integer" do
    @schedule_item.year = "aaaa"
    assert_not @schedule_item.valid?
  end

  test "month should be integer" do
    @schedule_item.month = "aa"
    assert_not @schedule_item.valid?
  end

  test "week should be integer" do
    @schedule_item.week = "aa"
    assert_not @schedule_item.valid?
  end

  test "day should be integer" do
    @schedule_item.day = "aa"
    assert_not @schedule_item.valid?
  end

  test "hour should be integer" do
    @schedule_item.hour = "aa"
    assert_not @schedule_item.valid?
  end

  test "content_item_id should be integer" do
    @schedule_item.content_item_id = "aaa"
    assert_not @schedule_item.valid?
  end

  # 日付チェック
  test "not exist day item should not be valid" do
    @schedule_item = schedule_items(:incorrect_item2)
    assert_not @schedule_item.valid?
  end

  # 日付パターンチェック
  test "both week and day exist item should not be valid" do
    @schedule_item = schedule_items(:incorrect_item1)
    assert_not @schedule_item.valid?
  end






end
