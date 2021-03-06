class DevkeysController < ApplicationController
  def index
    @devkeys = Devkey.all
    render 'index'
  end

  def show
    @devkey = Devkey.find(params[:id])
  end

  def new
    response.headers.delete "X-Frame-Options"
    @devkey = Devkey.new
  end

  def create
    @devkey = Devkey.new(devkey_params)
    if @devkey.save
      @devkey.update(:base_url => "https://#{@devkey.domain}")
      redirect_to @devkey
    else
      render 'new'
    end
  end

  def update
    @devkey = Devkey.find(params[:id])
    if @devkey.update_attributes(devkey_params)
      @devkey.update(:base_url => "https://#{@devkey.domain}")
      redirect_to @devkey
    else
      render 'edit'
    end
  end

  def destroy
    Devkey.find(params[:id]).destroy
    flash[:success] = "Developer Key deleted"
    redirect_to action: 'index'
  end

  def edit
    @devkey = Devkey.find(params[:id])
  end

  private

  def devkey_params
    params.require(:devkey).permit(:domain, :key, :client_id,
                                 :uri)
  end
end
