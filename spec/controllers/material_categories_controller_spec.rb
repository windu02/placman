require 'spec_helper'

describe MaterialCategoriesController do
  include Devise::TestHelpers
  
  describe "GET #index" do
    context "with not logged user" do
      it "does not render the :index view" do
        get :index
        response.should_not be_success
        response.should_not render_template :index
        response.should redirect_to(new_user_session_path)
      end
    end
    
    context "with logged user" do
      login_user
      
      it "renders the :index view" do
        get :index
        response.should render_template :index
      end
      
      it "populates an array of material categories" do
        material_category = FactoryGirl.create(:material_category)
        get :index
        assigns(:material_categories).should eq([material_category])
      end
    end
  end
  
  describe "GET #show" do
    context "with not logged user" do
      it "doesn't render the :show template" do
        get :show, id: FactoryGirl.create(:material_category)
        response.should_not be_success
        response.should_not render_template :show
        response.should redirect_to(new_user_session_path)
      end
    end
    
    context "with logged user" do
      login_user
      
      it "assigns the requested material to @material_category" do
        material_category = FactoryGirl.create(:material_category)
        get :show, id: material_category
        assigns(:material_category).should eq(material_category)
      end
      
      it "renders the :show template" do
        get :show, id: FactoryGirl.create(:material_category)
        response.should render_template :show
      end
    end
  end
  
  describe "GET #new" do
    context "with not logged user" do
      it "doesn't render the :new template" do
        get :new, id: FactoryGirl.create(:material_category)
        response.should_not be_success
        response.should_not render_template :new
        response.should redirect_to(new_user_session_path)
      end
    end
    
    context "with logged user" do
      login_user
      
      it "assigns a parent Material Category to @parentCat if exist" do
        parentCat = FactoryGirl.create(:material_category)
        get :new, parentCatId: parentCat.id
        assigns(:parentCat).should_not be_nil
        assigns(:parentCat).should eq(parentCat)
      end
      
      it "does not assign a parent Material Category to @parentCat if not exist" do
        get :new
        assigns(:parentCat).should be_nil
      end
      
      it "assigns a new Material Category to @material_category" do
        get :new
        assigns(:material_category).should_not be_nil
        assigns(:material_category).should_not be_valid
      end
      
      it "renders the :new template" do
        get :new
        response.should render_template :new
      end
    end
  end

  describe "POST #create" do
    context "with not logged user" do
      it "doesn't render the :new template" do
        post :create, material_category: FactoryGirl.attributes_for(:material_category)
        response.should_not be_success
        response.should_not render_template :create
        response.should redirect_to(new_user_session_path)
      end
    end
    
    context "with logged user" do
      login_user
    
      context "with valid attributes" do         
        it "creates a new material category" do
          expect{
            post :create, material_category: FactoryGirl.attributes_for(:material_category)
          }.to change(MaterialCategory,:count).by(1)
        end
        
        it "creates a new material category with parent category" do
          parentCat = FactoryGirl.create(:material_category)
          expect{
            post :create, material_category: FactoryGirl.attributes_for(:material_category), parentCatId: parentCat.id
          }.to change(MaterialCategory,:count).by(1)
          MaterialCategory.last.material_category.should be_valid
        end
        
        it "redirects to the new material category" do
          post :create, material_category: FactoryGirl.attributes_for(:material_category)
          response.should redirect_to MaterialCategory.last
        end
      end
      
      context "with invalid attributes" do
        it "does not save the new material category" do
          expect{
            post :create, material_category: FactoryGirl.attributes_for(:invalid_material_category)
          }.to_not change(MaterialCategory,:count)
        end
        
        it "re-renders the new method" do
          post :create, material_category: FactoryGirl.attributes_for(:invalid_material_category)
          response.should render_template :new
        end
      end
    end
  end
  
  describe "GET #edit" do
    before :each do
      @material_category = FactoryGirl.create(:material_category)
    end
    
    context "with not logged user" do
      it "doesn't render the :edit template" do
        get :edit, id: @material_category
        response.should_not be_success
        response.should_not render_template :edit
        response.should redirect_to(new_user_session_path)
      end
    end
    
    context "with logged user" do
      login_user
      
      it "assigns the Material Category to @material_category" do
        get :edit, id: @material_category
        assigns(:material_category).should eq(@material_category)
      end
      
      it "renders the :edit template" do
        get :edit, id: @material_category
        response.should render_template :edit
      end
    end
  end
  
  describe 'PUT update' do
    before :each do
      @material_category = FactoryGirl.create(:material_category, name: "Placo")
    end
      
    context "with not logged user" do
      it "doesn't render the :update template" do
        put :update, id: @material_category, material_category: FactoryGirl.attributes_for(:material_category)
        response.should_not be_success
        response.should_not render_template :update
        response.should redirect_to(new_user_session_path)
      end
    end
    
    context "with logged user" do
      login_user
      
      context "valid attributes" do
        it "located the requested @material_category" do
          put :update, id: @material_category, material_category: FactoryGirl.attributes_for(:material_category)
          assigns(:material_category).should eq(@material_category)
        end
        
        it "changes @material_category's attributes" do
          put :update, id: @material_category, material_category: FactoryGirl.attributes_for(:material_category, name: "Placo")
          @material_category.reload
          @material_category.name.should eq("Placo")
        end
        
        it "redirects to the updated material category" do
          put :update, id: @material_category, material_category: FactoryGirl.attributes_for(:material_category)
          response.should redirect_to @material_category
        end
      end
      
      context "invalid attributes" do
        it "locates the requested @material_category" do
          put :update, id: @material_category, material_category: FactoryGirl.attributes_for(:invalid_material_category)
          assigns(:material_category).should eq(@material_category)
        end
        
        it "does not change @material_category's attributes" do
          put :update, id: @material_category, material_category: FactoryGirl.attributes_for(:material_category, name: nil)
          @material_category.reload
          @material_category.name.should_not eq(nil)
        end
        
        it "re-renders the edit method" do
          put :update, id: @material_category, material_category: FactoryGirl.attributes_for(:invalid_material_category)
          response.should render_template :edit
        end
      end
    end
  end
  
  # describe "GET #delete" do
    # before :each do
      # @material_category = FactoryGirl.create(:material_category)
    # end
#     
    # context "with not logged user" do
      # it "doesn't render the :delete template" do
        # get :delete, id: @material_category
        # response.should_not be_success
        # response.should_not render_template :delete
        # response.should redirect_to(new_user_session_path)
      # end
    # end
#     
    # context "with logged user" do
      # login_user
#       
      # it "assigns the Material Category to @material_category" do
        # get :delete, id: @material_category
        # assigns(:material_category).should be eq(@material_category)
      # end
#       
      # it "renders the :delete template" do
        # get :delete, id: @material_category
        # response.should render_template :delete
      # end
    # end
  # end
  
  describe 'DELETE destroy' do
    before :each do
      @material_category = FactoryGirl.create(:material_category)
    end
    
    context "with not logged user" do
      it "doesn't render the :destroy template" do
        put :destroy, id: @material_category
        response.should_not be_success
        response.should_not render_template :destroy
        response.should redirect_to(new_user_session_path)
      end
    end
    
    context "with logged user" do
      login_user
    
      it "deletes the material category" do
        expect{
          delete :destroy, id: @material_category
        }.to change(MaterialCategory,:count).by(-1)
      end
      
      it "redirects to material_categories#index" do
        delete :destroy, id: @material_category
        response.should redirect_to material_categories_url
      end
    end
  end
end
