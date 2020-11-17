require 'test_helper'

class UserTest < ActiveSupport::TestCase

  def setup
    @user = users(:one) 
  end

  # 正常性確認
  test "should be valid" do
    assert @user.valid?
  end

  # 認証機能はWEB側で実装するため、API側は削除予定
  # test "light token should be authenticate" do
  #  assert @user.authenticate(TODO)
  # end

  # 空文字チェック
  test "room_id should not be present" do
    @user.room_id = " " * 6
    assert_not @user.valid?
  end

  test "status should not be present" do
    @user.status = " " * 6
    assert_not @user.valid?
  end

  # nilチェック
  test "name should not be nil" do
    @user.room_id = nil
    assert_not @user.valid?
  end

  test "status should not be nil" do
    @user.status = nil
    assert_not @user.valid?
  end

  # 文字数チェック
  test "room_id should not be too long" do
    @user.room_id = 1000000000
    assert_not @user.valid?
  end

  test "room_id should have a minimum length" do
    @user.room_id =  0
    assert_not @user.valid?
  end

  test "status should not be too long" do
    @user.status = 2
    assert_not @user.valid?
  end

  test "status should have a minimum length" do
    @user.status =  -1
    assert_not @user.valid?
  end

  # 数字チェック
  test "room_id should be integer" do
    @user.room_id =  "aaa"
    assert_not @user.valid?
  end

  test "status should be integer" do
    @user.status =  "a"
    assert_not @user.valid?
  end

  # 一意性チェック
  test "room_id should be unique" do
    duplicate_user = @user.dup
    @user.save
    assert_not duplicate_user.valid?
  end

end
