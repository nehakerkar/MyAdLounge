class AdgroupsController < ApplicationController
  before_action :set_adgroup,:set_user,:set_campaign, only: [:show, :edit, :update, :destroy]

  # GET /adgroups
  # GET /adgroups.json
  def index
  	set_user
    @adgroups = get_all_adgroups
  end

  # GET /adgroups/1
  # GET /adgroups/1.json
  def show
   if(@campaign.user_id!=@user.id)
  	  flash[:danger]="You are not allowed to view this adgroup."
  	  redirect_to @user
   end
  end

  # GET /adgroups/new
  def new
  	set_user
    @adgroup = Adgroup.new
    if(Campaign.where("user_id=?",@user.id).size==0)
		flash[:danger]= 'Create a Campaign first'
		redirect_to @user
	end
  end

  # GET /adgroups/1/edit
  def edit
   if(@campaign.user_id!=@user.id)
  	  flash[:danger]="You are not allowed to edit this adgroup."
  	  redirect_to @user
   end
  end

  # POST /adgroups
  # POST /adgroups.json
  def create
  	set_user
    @adgroup = Adgroup.new(adgroup_params)
	respond_to do |format|
     begin
      if @adgroup.save
        format.html { redirect_to @adgroup, notice: 'Adgroup was successfully created.' }
        format.json { render :show, status: :created, location: @adgroup }
      else
        format.html { render :new }
        format.json { render json: @adgroup.errors, status: :unprocessable_entity }
      end
      rescue ActiveRecord::RecordNotUnique
        flash.now[:danger] = 'Adgroup name already exists in the Campaign!'
		format.html { render :new }
        format.json { render json: @adgroup.errors, status: :unprocessable_entity }      
      end
    end
  end

  # PATCH/PUT /adgroups/1
  # PATCH/PUT /adgroups/1.json
  def update
    begin
    if(@campaign.user_id==@user.id)
	    if(@adgroup.campaign_id.to_s!=adgroup_params[:campaign_id] || @adgroup.aname!=adgroup_params[:aname] || @adgroup.maxcpc.to_s!=adgroup_params[:maxcpc] || @adgroup.headline!=adgroup_params[:headline] || @adgroup.description1!=adgroup_params[:description1] || @adgroup.description2!=adgroup_params[:description2] || @adgroup.displayurl!=adgroup_params[:displayurl] ||@adgroup.finalurl!=adgroup_params[:finalurl] ||@adgroup.status!=adgroup_params[:status])
    		if(adgroup_params[:status]=="paused") #If campaign is paused all its adgroups and ads are also paused.
    			@ads = Ad.where("adgroup_id = ?", @adgroup.id)
    			@ads.each do |g|
    			 g.update_attribute("status","paused")
    			end 
    		end
    		respond_to do |format|
      		if @adgroup.update(adgroup_params)
        		format.html { redirect_to @adgroup, notice: 'Ad Group was successfully updated.' }
        		format.json { render :show, status: :ok, location: @adgroup }
      		else
        		format.html { render :edit }
        		format.json { render json: @adgroup.errors, status: :unprocessable_entity }
      		end
      		end
      	else
      		flash[:notice] = 'No edit made.'
      		redirect_to @adgroup
    	end
    else
     	flash[:danger] = 'You do not have permissions to edit this element.'
      	redirect_to @user	
    end
    rescue ActiveRecord::RecordNotUnique
     flash.now[:danger] = 'Adgroup name already exists!'
     render :edit
    end
  end

  # DELETE /adgroups/1
  # DELETE /adgroups/1.json
  def destroy
  	begin
    @adgroup.destroy
    respond_to do |format|
      format.html { redirect_to @user, notice: 'Adgroup was successfully destroyed.' }
      format.json { head :no_content }
    end
    rescue ActiveRecord::StatementInvalid
    	flash[:danger] = 'Cannot delete AdGroup. AdGroup has ads.'
        redirect_to @user
    end
  end
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_adgroup
      @adgroup = Adgroup.find(params[:id])
    end
    
    def set_user
      @user = current_user
    end

	def set_campaign
      @campaign = Campaign.where("id=?",@adgroup.campaign_id)[0]
    end
    
    def get_all_adgroups
      @adgroups = Adgroup.where("campaign_id in (?)", Campaign.where("user_id=?",@user.id).ids)
    end
    
    # Never trust parameters from the scary internet, only allow the white list through.
    def adgroup_params
      params.require(:adgroup).permit(:campaign_id, :aname, :maxcpc, :headline, :description1, :description2, :displayurl, :finalurl, :status)
    end
end
