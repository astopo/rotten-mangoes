class ReviewsController < ApplicationController
  before_filter :load_movie

  def new
    @review = @movie.reviews.build
  end

  def create
    @review = @movie.reviews.build(review_params)
    @review.user_id = current_user.id

    if @review.save
      redirect_to @movie, notice: "Review created successfully"
    else
      render :new
    end
  end

  protected

  def load_movie
    @movie = Movie.find(params[:id])
  end

  def review_params
    params.require(:reviews).permit(:text, :rating_out_of_ten)
  end
end
