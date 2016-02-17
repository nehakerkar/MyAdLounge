require 'test_helper'

class AdsControllerTest < ActionController::TestCase
  setup do
    @ad = ads(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:ads)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create ad" do
    assert_difference('Ad.count') do
      post :create, ad: { adgroup_id: @ad.adgroup_id, criteriontype: @ad.criteriontype, firstpagebid: @ad.firstpagebid, keyword: @ad.keyword, status: @ad.status, topofpagebid: @ad.topofpagebid }
    end

    assert_redirected_to ad_path(assigns(:ad))
  end

  test "should show ad" do
    get :show, id: @ad
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @ad
    assert_response :success
  end

  test "should update ad" do
    patch :update, id: @ad, ad: { adgroup_id: @ad.adgroup_id, criteriontype: @ad.criteriontype, firstpagebid: @ad.firstpagebid, keyword: @ad.keyword, status: @ad.status, topofpagebid: @ad.topofpagebid }
    assert_redirected_to ad_path(assigns(:ad))
  end

  test "should destroy ad" do
    assert_difference('Ad.count', -1) do
      delete :destroy, id: @ad
    end

    assert_redirected_to ads_path
  end
end
