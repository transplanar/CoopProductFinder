class HomeController < ApplicationController
  def index
    # if params[:search]
    #   @cards = Card.find(:all, :conditions => ['name LIKE ?', "%#{params[:search]}%"])
    # else
    #   @cards = Card.all
    # end
    # @cards = Card.search(params[:seach])

    # TODO error message for invalid queries
    if is_numeric?(params[:search])
      @cards = Card.where('cost LIKE ?',"%#{params[:search]}%")
    else
      @cards = Card.where('name LIKE ?',"%#{params[:search]}%")
    end

    respond_to do |format|
      format.html
      format.js {flash[:alert] = "Javascript stuff"}
    end
  end

  def about
  end

  private

  def is_numeric?(obj)
     obj.to_s.match(/\A[+-]?\d+?(\.\d+)?\Z/) == nil ? false : true
  end

  # MOVE THIS FUNCTION TO BETTER SPOT

  # chain .where queries to get array of desired cards
end
