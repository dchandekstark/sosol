require 'test_helper'

class CommunitiesControllerTest < ActionController::TestCase
  def setup
    @admin = FactoryGirl.create(:admin)
    @request.session[:user_id] = @admin.id
    @community = FactoryGirl.create(:community)
    @community_two = FactoryGirl.create(:community)
  end
  
  def teardown
    @request.session[:user_id] = nil
    @admin.destroy
    @community.destroy unless !Community.exists? @community.id
    @community_two.destroy unless !Community.exists? @community_two.id
  end
 
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:communities)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create community" do
    assert_difference('Community.count') do
      post :create, :community => FactoryGirl.build(:community).attributes.merge({"admins"=>[],"members"=>[]})
    end

    assert_redirected_to edit_community_path(assigns(:community))
  end

  test "should show community" do
    get :show, :id => @community.id
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @community.id
    assert_response :success
  end

  test "should update community" do
    put :update, :id => @community.id, :community => { }
    assert_redirected_to edit_community_path(assigns(:community))
  end

  test "should destroy community" do
    assert_difference('Community.count', -1) do
      delete :destroy, :id => @community.id
    end

    assert_redirected_to :controller => 'user', :action => 'admin'
  end
end
