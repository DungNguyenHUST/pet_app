require "application_system_test_case"

class UserNotificationsTest < ApplicationSystemTestCase
  setup do
    @user_notification = user_notifications(:one)
  end

  test "visiting the index" do
    visit user_notifications_url
    assert_selector "h1", text: "User Notifications"
  end

  test "creating a User notification" do
    visit user_notifications_url
    click_on "New User Notification"

    fill_in "User", with: @user_notification.user_id
    click_on "Create User notification"

    assert_text "User notification was successfully created"
    click_on "Back"
  end

  test "updating a User notification" do
    visit user_notifications_url
    click_on "Edit", match: :first

    fill_in "User", with: @user_notification.user_id
    click_on "Update User notification"

    assert_text "User notification was successfully updated"
    click_on "Back"
  end

  test "destroying a User notification" do
    visit user_notifications_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "User notification was successfully destroyed"
  end
end
