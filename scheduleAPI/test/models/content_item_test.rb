require 'test_helper'

class ContentItemTest < ActiveSupport::TestCase
  def setup
    @content_item = content_items(:one)
  end

  # 正常系テスト
  test "should be valid" do
    assert @content_item.valid?
  end

  # 空文字チェック
  test "content should not be present" do
    @content_item.content = " " * 6
    assert_not @content_item.valid?
  end

  # nilチェック
  test "content should not be nil" do
    @content_item.content = nil
    assert_not @content_item.valid?
  end

  # 文字数チェック
  test "content should not be too long" do
    @content_item.content = "a" * 201
    assert_not @content_item.valid?
  end

  test "content should have a minimum length" do
    @content_item.content = ""
    assert_not @content_item.valid?
  end
end
