class ConstructionsController < ApplicationController
   before_action :authenticate_user!, except: [:index, :show]
   before_action :private_access, only: [:edit]

   def index
      @constructions = Construction.order('created_at DESC')

      if params[:name].present? 
        @constructions = @constructions.where("name ILIKE ?", "%#{params[:name].strip}%")
      end
   end

   def new
      @construction = Construction.new
   end

   def create
      @construction = Construction.new(construction_params)
      @construction.user = current_user
      if @construction.save
         flash[:success] = "Post creado exitosamente !!"
         redirect_to root_path
      else
         render :new
      end
   end

   def show
      @construction = Construction.find(params[:id])
   end

   def edit
      @construction = Construction.find(params[:id])
   end

   def update
      @construction = Construction.find(params[:id])
      if @construction.update(construction_params)
         flash[:info] = "Post editado exitosamente !!"
         redirect_to root_path
      else
         render :edit
      end
   end

   def destroy
      @construction = Construction.find(params[:id])
      @construction.destroy
      flash[:info] = "Post eliminado exitosamente !!"
      redirect_to root_path 
   end

   private
      def construction_params
         params.require(:construction).permit(:name, :image_url, :capacity, :city, :description)
      end
end