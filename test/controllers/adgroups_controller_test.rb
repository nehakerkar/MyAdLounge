require 'test_helper'

class AdgroupsControllerTest < ActionController::TestCase
  setup do
    @adgroup = adgroups(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:adgroups)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create adgroup" do
    assert_difference('Adgroup.count') do
      post :create, adgroup: { aname: @adgroup.aname, campaign_id: @adgroup.campaign_id, description1: @adgroup.description1, description2: @adgroup.description2, displayurl: @adgroup.displayurl, finalurl: @adgroup.finalurl, headline: @adgroup.headline, maxcpc: @adgroup.maxcpc, status: @adgroup.status }
    end

    assert_redirected_to adgroup_path(assigns(:adgroup))
  end

  test "should show adgroup" do
    get :show, id: @adgroup
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @adgroup
    assert_response :success
  end

  test "should update adgroup" do
    patch :update, id: @adgroup, adgroup: { aname: @adgroup.aname, campaign_id: @adgroup.campaign_id, description1: @adgroup.description1, description2: @adgroup.description2, displayurl: @adgroup.displayurl, finalurl: @adgroup.finalurl, headline: @adgroup.headline, maxcpc: @adgroup.maxcpc, status: @adgroup.status }
    assert_redirected_to adgroup_path(assigns(:adgroup))
  end

  test "should destroy adgroup" do
    assert_difference('Adgroup.count', -1) do
      delete :destroy, id: @adgroup
    end

    assert_redirected_to adgroups_path
  end
end
