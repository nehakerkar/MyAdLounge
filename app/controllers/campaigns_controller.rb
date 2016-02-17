class CampaignsController < ApplicationController
  before_action :set_campaign, :set_user,  only: [:show, :edit, :update, :destroy]

  # GET /campaigns
  # GET /campaigns.json
  def index
    set_user
    @campaigns = Campaign.where("user_id=?",@user.id)
  end

  # GET /campaigns/1
  # GET /campaigns/1.json
  def show
  	if(@campaign.user_id!=@user.id)
  	  flash[:danger]="You are not allowed to view this campaign."
  	  redirect_to @user
  	end
  end

  # GET /campaigns/new
  def new
    set_user
    @campaign = Campaign.new
  end

  # GET /campaigns/1/edit
  def edit
   if(@campaign.user_id!=@user.id)
  	  flash[:danger]="You are not allowed to edit this campaign."
  	  redirect_to @user
  	end
  end

  # POST /campaigns
  # POST /campaigns.json
  def create
  	set_user
  	@campaign = Campaign.new(campaign_params)
	@campaign.user_id = @user.id
    respond_to do |format|
    begin
      if @campaign.save
        format.html { redirect_to @campaign, notice: 'Campaign was successfully created.' }
        format.json { render :show, status: :created, location: @campaign }
      else
        format.html { render :new }
        format.json { render json: @campaign.errors, status: :unprocessable_entity }
      end
      rescue ActiveRecord::RecordNotUnique
      	flash.now[:danger] = 'Campaign name already exists!'
        format.html { render :new }
        format.json { render json: @campaign.errors, status: :unprocessable_entity }
      end 
    end
  end
  
  

  # PATCH/PUT /campaigns/1
  # PATCH/PUT /campaigns/1.json
  def update
    begin
    if(@campaign.user_id==@user.id)
	    if(@campaign.cname!=campaign_params[:cname] || @campaign.campaigndailybudget.to_s!=campaign_params[:campaigndailybudget] || @campaign.status!=campaign_params[:status])
    		if(campaign_params[:status]=="paused") #If campaign is paused all its adgroups and ads are also paused.
    			@adgroups = Adgroup.where("campaign_id = ?", @campaign.id)
    			@adgroups.each do |g|
    			 g.update_attribute("status","paused")
    			end
    			@ads = Ad.where("adgroup_id in (?)", @adgroups.ids)
    			@ads.each do |g|
    			 g.update_attribute("status","paused")
    			end 
    		end
    		respond_to do |format|
      		if @campaign.update(campaign_params)
        		format.html { redirect_to @campaign, notice: 'Campaign was successfully updated.' }
        		format.json { render :show, status: :ok, location: @campaign }
      		else
        		format.html { render :edit }
        		format.json { render json: @campaign.errors, status: :unprocessable_entity }
      		end
      		end
      	else
      		flash[:notice] = 'No edit made.'
      		redirect_to @campaign
    	end
    else
    	flash[:danger] = 'You do not have permissions to edit this element.'
      	redirect_to @user
    end
    rescue ActiveRecord::RecordNotUnique
     flash.now[:danger] = 'Campaign name already exists!'
     render :edit
    end
  end

  # DELETE /campaigns/1
  # DELETE /campaigns/1.json
  def destroy
    begin
    @campaign.destroy
    respond_to do |format|
      format.html { redirect_to @user, notice: 'Campaign was successfully destroyed.' }
      format.json { head :no_content }
    end
    rescue ActiveRecord::StatementInvalid
    	flash[:danger] = 'Cannot delete Campaign. Campaign has adgroups.'
        redirect_to @user
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_campaign
      @campaign = Campaign.find(params[:id])
    end
    
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = current_user
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def campaign_params
      params.require(:campaign).permit(:user_id, :cname, :campaigndailybudget, :status)
    end
end
