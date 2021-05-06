require "test_helper"

class CompanyImagesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @company_image = company_images(:one)
  end

  test "should get index" do
    get company_images_url
    assert_response :success
  end

  test "should get new" do
    get new_company_image_url
    assert_response :success
  end

  test "should create company_image" do
    assert_difference('CompanyImage.count') do
      post company_images_url, params: { company_image: { company_id: @company_image.company_id, image: @company_image.image } }
    end

    assert_redirected_to company_image_url(CompanyImage.last)
  end

  test "should show company_image" do
    get company_image_url(@company_image)
    assert_response :success
  end

  test "should get edit" do
    get edit_company_image_url(@company_image)
    assert_response :success
  end

  test "should update company_image" do
    patch company_image_url(@company_image), params: { company_image: { company_id: @company_image.company_id, image: @company_image.image } }
    assert_redirected_to company_image_url(@company_image)
  end

  test "should destroy company_image" do
    assert_difference('CompanyImage.count', -1) do
      delete company_image_url(@company_image)
    end

    assert_redirected_to company_images_url
  end
end
