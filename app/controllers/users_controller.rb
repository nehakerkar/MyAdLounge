class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy, :import]

  # GET /users
  # GET /users.json
  def index
    @users = User.all
  end

  # GET /users/1
  # GET /users/1.json
  def show
   @campaigns = Campaign.where("user_id = ?", @user.id)
   @adgroups = Adgroup.where("campaign_id in (?)", @campaigns.ids)
   @ads = Ad.where("adgroup_id in (?)", @adgroups.ids)
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        log_in @user
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
  
  def import
   begin
  parsed_file = CSV.read(params[:file].path, { :col_sep => "\t" })
   @campaigns = Campaign.where("user_id = ?", @user.id)
   @adgroups = Adgroup.where("campaign_id in (?)", @campaigns.ids)
   @ads = Ad.where("adgroup_id in (?)", @adgroups.ids)
   #@ads.destroy_all
   #@adgroups.destroy_all
   #@campaigns.destroy_all
   
   #Logic to add new tsv here. --> Incomplete Code here.
   parsed_file.each do |line|
	fields = Hash[headers.zip(line.split("\t"))][["X-Frame-Options", "SAMEORIGIN"]]
	prev_cname = ""
	@prev_campaign = Campaign.new
	for i in 0..15 do
     if(fields[i]!="Campaign" && fields[i]!="Campaign Daily Budget" && fields[i]!="Ad Group" && fields[i]!="Max CPC" && fields[i]!="Headline" && fields[i]!="Description Line 1" && fields[i]!="Description Line 2" && fields[i]!="Display URL" &&fields[i]!="Final URL"&& fields[i]!="Keyword" && fields[i]!="Criterion Type" && fields[i]!="First page bid"&&fields[i]!="Top of page bid"&&fields[i]!="Campaign Status"&&fields[i]!="Ad Group Status"&&fields[i]!="Status") 
	 	if (i==0 && fields[i]!="prev_cname")
	 	 puts prev_cname
	 	 prev_cname = fields[i]
	 	end	
	 end    
    end
   end
   
  redirect_to @user, notice: "New TSV imported."
  rescue 
   flash[:danger] = "Please choose a tsv file."
   redirect_to @user
  end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = current_user
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
end
