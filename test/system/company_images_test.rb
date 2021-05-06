require "application_system_test_case"

class CompanyImagesTest < ApplicationSystemTestCase
  setup do
    @company_image = company_images(:one)
  end

  test "visiting the index" do
    visit company_images_url
    assert_selector "h1", text: "Company Images"
  end

  test "creating a Company image" do
    visit company_images_url
    click_on "New Company Image"

    fill_in "Company", with: @company_image.company_id
    fill_in "Image", with: @company_image.image
    click_on "Create Company image"

    assert_text "Company image was successfully created"
    click_on "Back"
  end

  test "updating a Company image" do
    visit company_images_url
    click_on "Edit", match: :first

    fill_in "Company", with: @company_image.company_id
    fill_in "Image", with: @company_image.image
    click_on "Update Company image"

    assert_text "Company image was successfully updated"
    click_on "Back"
  end

  test "destroying a Company image" do
    visit company_images_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Company image was successfully destroyed"
  end
end
