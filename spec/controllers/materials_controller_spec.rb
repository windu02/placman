require 'spec_helper'

describe MaterialsController do
  include Devise::TestHelpers
  
  # describe "GET #index" do
    # context "with not logged user" do
      # it "does not render the :index view" do
        # get :index
        # response.should_not be_success
        # response.should_not render_template :index
        # response.should redirect_to(new_user_session_path)
      # end
    # end
#     
    # context "with logged user" do
      # login_user
#       
      # it "renders the :index view" do
        # get :index
        # response.should render_template :index
      # end
      # it "populates an array of materials" do
        # material = FactoryGirl.create(:material)
        # get :index
        # assigns(:materials).should eq([material])
      # end
    # end
  # end
  
  describe "GET #show" do
    before :each do
        @materialCat = FactoryGirl.create(:material_category)
        @material = FactoryGirl.create(:material)
        @materialCat.materials.push(@material)
        @materialCat.save
    end
    context "with not logged user" do
      it "doesn't render the :show template" do
        get :show, material_category_id: @materialCat, id: @material.id
        response.should_not be_success
        response.should_not render_template :show
        response.should redirect_to(new_user_session_path)
      end
    end
    
    context "with logged user" do
      login_user
      
      it "assigns the requested material to @material" do
        get :show, material_category_id: @materialCat, id: @material.id
        assigns(:material).should eq(@material)
      end
      it "renders the :show template" do
        get :show, material_category_id: @materialCat, id: @material.id
        response.should render_template :show
      end
    end
  end
  
  describe "GET #new" do
    before :each do
        @materialCat = FactoryGirl.create(:material_category)
        @material = FactoryGirl.create(:material)
        @materialCat.materials.push(@material)
        @materialCat.save
    end
    
    context "with not logged user" do
      it "doesn't render the :new template" do
        get :new, material_category_id: @materialCat
        response.should_not be_success
        response.should_not render_template :new
        response.should redirect_to(new_user_session_path)
      end
    end
    
    context "with logged user" do
      login_user
      
      it "assigns a new Material to @material" do
        get :new, material_category_id: @materialCat
        assigns(:material).should_not be_nil
        assigns(:material).should_not be_valid
      end
      it "renders the :new template" do
        get :new, material_category_id: @materialCat
        response.should render_template :new
      end
    end
  end

  describe "POST #create" do
    before :each do
        @materialCat = FactoryGirl.create(:material_category)
        @material = FactoryGirl.create(:material)
        @materialCat.materials.push(@material)
        @materialCat.save
    end
    
    context "with not logged user" do
      it "doesn't render the :new template" do
        post :create, material_category_id: @materialCat, material: FactoryGirl.attributes_for(:material)
        response.should_not be_success
        response.should_not render_template :create
        response.should redirect_to(new_user_session_path)
      end
    end
    
    context "with logged user" do
      login_user
    
      context "with valid attributes" do         
        it "creates a new material" do
          expect{
            post :create, material_category_id: @materialCat, material: FactoryGirl.attributes_for(:material)
          }.to change(Material,:count).by(1)
        end
        
        it "creates a new material with a correct parent category" do
          post :create, material_category_id: @materialCat, material: FactoryGirl.attributes_for(:material)
          Material.last.material_category.id.should eq(@materialCat.id)
        end
        
        it "redirects to the new material's parent category" do
          post :create, material_category_id: @materialCat, material: FactoryGirl.attributes_for(:material)
          response.should redirect_to(material_category_path(@materialCat))
        end
      end
      
      context "with invalid attributes" do
        it "does not save the new material" do
          expect{
            post :create, material_category_id: @materialCat, material: FactoryGirl.attributes_for(:invalid_material)
          }.to_not change(Material,:count)
        end
        
        it "re-renders the new method" do
          post :create, material_category_id: @materialCat, material: FactoryGirl.attributes_for(:invalid_material)
          response.should render_template :new
        end
      end
    end
  end
  
  describe "GET #edit" do
    before :each do
        @materialCat = FactoryGirl.create(:material_category)
        @material = FactoryGirl.create(:material)
        @materialCat.materials.push(@material)
        @materialCat.save
    end
    
    context "with not logged user" do
      it "doesn't render the :edit template" do
        get :edit, material_category_id: @materialCat, id: @material
        response.should_not be_success
        response.should_not render_template :edit
        response.should redirect_to(new_user_session_path)
      end
    end
    
    context "with logged user" do
      login_user
      
      it "assigns the Material to @material" do
        get :edit, material_category_id: @materialCat, id: @material
        assigns(:material).should eq(@material)
      end
      
      it "renders the :edit template" do
        get :edit, material_category_id: @materialCat, id: @material
        response.should render_template :edit
      end
    end
  end
  
  describe 'PUT update' do
    before :each do
        @materialCat = FactoryGirl.create(:material_category)
        @material = FactoryGirl.create(:material, denomination: "Plaque de placo", unit: "Unit")
        @materialCat.materials.push(@material)
        @materialCat.save
    end
      
    context "with not logged user" do
      it "doesn't render the :update template" do
        put :update, material_category_id: @materialCat, id: @material, material: FactoryGirl.attributes_for(:material)
        response.should_not be_success
        response.should_not render_template :update
        response.should redirect_to(new_user_session_path)
      end
    end
    
    context "with logged user" do
      login_user
      
      context "valid attributes" do
        it "located the requested @material" do
          put :update, material_category_id: @materialCat, id: @material, material: FactoryGirl.attributes_for(:material)
          assigns(:material).should eq(@material)
        end
        
        it "changes @material's attributes" do
          put :update, material_category_id: @materialCat, id: @material, material: FactoryGirl.attributes_for(:material, denomination: "Plaque", unit: "m&sup2;")
          @material.reload
          @material.denomination.should eq("Plaque")
          @material.unit.should eq("m&sup2;")
        end
        
        it "redirects to the updated material" do
          put :update, material_category_id: @materialCat, id: @material, material: FactoryGirl.attributes_for(:material)
          response.should redirect_to(material_category_path(@materialCat))
        end
      end
      
      context "invalid attributes" do
        it "locates the requested @material" do
          put :update, material_category_id: @materialCat, id: @material, material: FactoryGirl.attributes_for(:invalid_material)
          assigns(:material).should eq(@material)
        end
        
        it "does not change @material's attributes" do
          put :update, material_category_id: @materialCat, id: @material, material: FactoryGirl.attributes_for(:material, denomination: "Plaque", unit: "pouet")
          @material.reload
          @material.denomination.should_not eq("Plaque")
          @material.unit.should_not eq("pouet")
        end
        
        it "re-renders the edit method" do
          put :update, material_category_id: @materialCat, id: @material, material: FactoryGirl.attributes_for(:invalid_material)
          response.should render_template :edit
        end
      end
    end
  end
  
  # describe "GET #delete" do
    # before :each do
      # @material = FactoryGirl.create(:material)
    # end
#     
    # context "with not logged user" do
      # it "doesn't render the :delete template" do
        # get :delete, id: @material
        # response.should_not be_success
        # response.should_not render_template :delete
        # response.should redirect_to(new_user_session_path)
      # end
    # end
#     
    # context "with logged user" do
      # login_user
#       
      # it "assigns the Material to @material" do
        # get :delete, id: @material
        # assigns(:material).should be eq(@material)
      # end
#       
      # it "renders the :delete template" do
        # get :delete, id: @material
        # response.should render_template :delete
      # end
    # end
  # end
  
  describe 'DELETE destroy' do
    before :each do
        @materialCat = FactoryGirl.create(:material_category)
        @material = FactoryGirl.create(:material)
        @materialCat.materials.push(@material)
        @materialCat.save
    end
    
    context "with not logged user" do
      it "doesn't render the :destroy template" do
        put :destroy, material_category_id: @materialCat, id: @material
        response.should_not be_success
        response.should_not render_template :destroy
        response.should redirect_to(new_user_session_path)
      end
    end
    
    context "with logged user" do
      login_user
    
      it "deletes the material" do
        expect{
          delete :destroy, material_category_id: @materialCat, id: @material
        }.to change(Material,:count).by(-1)
      end 
      it "redirects to materials#index" do
        delete :destroy, material_category_id: @materialCat, id: @material
        response.should redirect_to(material_category_path(@materialCat))
      end
    end
  end
end
