class MaterialsController < ApplicationController
  before_filter :authenticate_user!
  skip_before_action :authenticate_user!, only: [:setMenu]
  
  def show
    @material = Material.find(params[:id])
  end
  
  def new
    @material = Material.new
    @parentCat = MaterialCategory.find(params[:material_category_id])
  end
  
  def create
    @parentCat = MaterialCategory.find(params[:material_category_id])
    
    @material = Material.new(material_params)

    if ! @material.save
      flash.now[:error] = t('save_failed')
          
      render :template => "materials/new"  
    else

      if !@parentCat.nil? && !@parentCat.addMaterial!(@material)
        flash.now[:error] = t('save_failed')
            
        render :template => "materials/new"
      else
        flash[:notice] = t('save_success')
        
        redirect_to material_category_path(@parentCat)
      end

    end
  end
  
  def edit
    @material = Material.find(params[:id])
  end
  
  def update
    @material = Material.find(params[:id])

    if ! @material.update(material_params)
      flash.now[:error] = t('save_failed')
          
      render :template => "materials/edit"  
    else
      flash[:notice] = t('edit_success')
      
      redirect_to material_category_path(@material.material_category)
    end
  end
  
  def destroy
    @material = Material.find(params[:id])
    parentCat = @material.material_category
    @material.destroy
    
    flash[:notice] = t('destroy_success')
    
    redirect_to material_category_path(parentCat)
  end
  
  private
  
  def setMenu
    @material_categoriesMenu = true
  end
  
  def material_params
    params.require(:material).permit(:denomination, :unit, :material_category_id)
  end
end
