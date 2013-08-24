class MaterialCategoriesController < ApplicationController
  before_filter :authenticate_user!
  skip_before_action :authenticate_user!, only: [:setMenu]
  
  def index
    @material_categories = Array.new
    MaterialCategory.all.each do |mc|
      if mc.rootCategory?
        @material_categories.push(mc)
      end
    end
  end
  
  def show
    @material_category = MaterialCategory.find(params[:id])
  end
  
  def new
    @material_category = MaterialCategory.new
    if !params[:parentCatId].nil?
      @parentCat = MaterialCategory.find(params[:parentCatId])
    end
  end
  
  def create
    if !params[:parentCatId].nil?
      @parentCat = MaterialCategory.find(params[:parentCatId])
    end
    
    @material_category = MaterialCategory.new(material_category_params)

    if ! @material_category.save
      flash.now[:error] = t('save_failed')
          
      render :template => "material_categories/new"  
    else

      if !@parentCat.nil? && !@parentCat.addCategory!(@material_category)
        flash.now[:error] = t('save_failed')
            
        render :template => "material_categories/new"
      else
        flash[:notice] = t('save_success')
        
        redirect_to @material_category
      end

    end
  end
  
  def edit
    @material_category = MaterialCategory.find(params[:id])
  end
  
  def update
    @material_category = MaterialCategory.find(params[:id])

    if ! @material_category.update(material_category_params)
      flash.now[:error] = t('save_failed')
          
      render :template => "material_categories/edit"  
    else
      flash[:notice] = t('edit_success')
      
      redirect_to @material_category
    end
  end
  
  def destroy
    @material_category = MaterialCategory.find(params[:id])
    @material_category.destroy
    
    # Détruire en cascade
    
    flash[:notice] = t('destroy_success')
    
    redirect_to material_categories_path
  end
  
  private
  
  def setMenu
    @material_categoriesMenu = true
  end
  
  def material_category_params
    params.require(:material_category).permit(:name, :parentCatId)
  end
end
