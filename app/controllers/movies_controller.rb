class MoviesController < ApplicationController
  def index
    @movies = Movie.all
  end

  def show
    @movie = Movie.find(params[:id])
  end

  def new
    @movie = Movie.new
  end

  def edit
    @movie = Movie.find(params[:id])
  end

  def create
    @movie = Movie.new(movie_params)

    if @movie.save
      redirect_to movies_path, notice: "#{@movie.title} was submitted successfully!"
    else
      render :new
    end
  end

  def update
    @movie = Movie.find(params[:id])

    if @movie.update_attributes(movie_params)
      redirect_to movie_path(@movie)
    else
      render :edit
    end
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    redirect_to movies_path
  end

  def search
    p = params[:movie]
    
    title = Movie.where("title LIKE ?", "%#{p[:title]}%")
    director = Movie.where("director LIKE ?", "%#{p[:director]}%")
    runtime = movie_runtime

    @results = title.merge(director).merge(runtime)

  end

  protected

  def movie_runtime
    p = params[:movie][:duration]

    if p == "<90"
      runtime = Movie.where("runtime_in_minutes < ?", 90)
    elsif p == "90to120"
      runtime = Movie.where("runtime_in_minutes >= ?", 90).where("runtime_in_minutes <= ?", 120)
    else p == ">120"
      runtime = Movie.where("runtime_in_minutes > ?", 120)
    end

    runtime
  end

  def movie_params
    params.require(:movie).permit( :title, :release_date, :director, :runtime_in_minutes, :poster, :description )
  end
end
