require 'test_helper'

class AdminUserTest < ActiveSupport::TestCase
  def setup
    @admin_user = AdminUser.new(name: "Example User",
                                password: "password",
                                password_confirmation: "password")
  end

  # 正常性確認
  test "should be valid" do
    assert @admin_user.valid?
  end

  test "light password should be authenticate" do
    assert @admin_user.authenticate("password")
  end

  # 空文字チェック
  test "name should be present" do
    @admin_user.name = " " * 6
    assert_not @admin_user.valid?
  end

  test "password should be present" do
    @admin_user.password = @admin_user.password_confirmation = " " * 6
    assert_not @admin_user.valid?
  end

  # nilチェック
  test "name should not be nil" do
    @admin_user.name = nil
    assert_not @admin_user.valid?
  end

  test "password_digest should not be nil" do
    @admin_user.password_digest = nil
    assert_not @admin_user.valid?
  end

  test "password should not be nil" do
    @admin_user.password = @admin_user.password_confirmation = nil
    assert_not @admin_user.valid?
  end

  # 文字数チェック
  test "name should not be too long" do
    @admin_user.name = "a" * 21
    assert_not @admin_user.valid?
  end
  
  test "password should not be too long" do
    @admin_user.password = @admin_user.password_confirmation = "a" * 21
    assert_not @admin_user.valid?
  end

  test "name should have a minimum length" do
    @admin_user.name = "a" * 5
    assert_not @admin_user.valid?
  end
  
  test "password should have a minimum length" do
    @admin_user.password = @admin_user.password_confirmation = "a" * 5
    assert_not @admin_user.valid?
  end

  # 一意性チェック
  test "name should be unique" do
    duplicate_admin_user = @admin_user.dup
    @admin_user.save
    assert_not duplicate_admin_user.valid?
  end

  test "wrong password should not be authenticate" do
    assert_not @admin_user.authenticate("password2")
  end

end
