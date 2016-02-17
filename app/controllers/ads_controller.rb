class AdsController < ApplicationController
  before_action :set_ad, :set_user, :set_campaign, only: [:show, :edit, :update, :destroy]

  # GET /ads
  # GET /ads.json
  def index
  	set_user
    @ads = get_all_ads
  end

  # GET /ads/1
  # GET /ads/1.json
  def show
   if(@campaign.user_id!=@user.id)
  	  flash[:danger]="You are not allowed to view this ad."
  	  redirect_to @user
   end
  end

  # GET /ads/new
  def new
    set_user
    @ad = Ad.new
    if(get_all_adgroups.size==0)
		flash[:danger]= 'Create an Adgroup first'
		redirect_to @user
	end
  end

  # GET /ads/1/edit
  def edit
   if(@campaign.user_id!=@user.id)
  	  flash[:danger]="You are not allowed to edit this ad."
  	  redirect_to @user
   end
  end

  # POST /ads
  # POST /ads.json
  def create
  	set_user
    @ad = Ad.new(ad_params)
    
    @adgroup = Adgroup.find(ad_params[:adgroup_id])
    if(@adgroup.status=="paused")
    	@ad.status = "paused"
    end
    
    respond_to do |format|
     begin
      if @ad.save
        format.html { redirect_to @ad, notice: 'Ad was successfully created.' }
        format.json { render :show, status: :created, location: @ad }
      else
        format.html { render :new }
        format.json { render json: @ad.errors, status: :unprocessable_entity }
      end
      rescue ActiveRecord::RecordNotUnique
        flash.now[:danger] = 'Ad name already exists in the Adgroup!'
		format.html { render :new }
        format.json { render json: @adgroup.errors, status: :unprocessable_entity }      
      end
    end
  end  
    
    
  # PATCH/PUT /ads/1
  # PATCH/PUT /ads/1.json
  def update
    begin
     if(@campaign.user_id == @user.id)
    	if(@ad.adgroup_id.to_s!=ad_params[:adgroup_id] || @ad.keyword.to_s != ad_params[:keyword] || @ad.criteriontype != ad_params[:criteriontype] || @ad.firstpagebid.to_s !=  ad_params[:firstpagebid] || @ad.topofpagebid.to_s != ad_params[:topofpagebid] || @ad.status != ad_params[:status])
    	  respond_to do |format|
      	  if @ad.update(ad_params)
           format.html { redirect_to @ad, notice: 'Ad was successfully updated.' }
           format.json { render :show, status: :ok, location: @ad }
          else
           format.html { render :edit }
           format.json { render json: @ad.errors, status: :unprocessable_entity }
          end
          end    	
    	else
    	  flash[:notice] = 'No edit made.'
      	  redirect_to @ad
    	end    
     else
      flash[:danger] = 'You do not have permissions to edit this element.'
      redirect_to @user    
     end
    rescue ActiveRecord::RecordNotUnique
     flash.now[:danger] = 'Ad name already exists!'
     render :edit
    end
  end

  # DELETE /ads/1
  # DELETE /ads/1.json
  def destroy
    @ad.destroy
    respond_to do |format|
      format.html { redirect_to @user, notice: 'Ad was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_ad
      @ad = Ad.find(params[:id])
    end
    
    def set_user
      @user = current_user
    end
    
    def set_campaign
      set_adgroup
   	  @campaign = Campaign.where("id=?",@adgroup.campaign_id)[0]
    end
    
    def set_adgroup
      @adgroup = Adgroup.where("id=?",@ad.adgroup_id)[0]
    end
    
    def get_all_ads
    	get_all_adgroups
    	@ads = Ad.where("adgroup_id in (?)", @adgroups.ids)
    end
    
    def get_all_adgroups
      @adgroups = Adgroup.where("campaign_id in (?)", Campaign.where("user_id=?",@user.id).ids)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def ad_params
      params.require(:ad).permit(:adgroup_id, :keyword, :criteriontype, :firstpagebid, :topofpagebid, :status)
    end
end
