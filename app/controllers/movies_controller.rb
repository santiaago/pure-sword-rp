class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end
  
  def initialize
    @all_ratings = Movie.all_ratings
    @ratings = @all_ratings
    @sort_by = :id
    super
  end

  def index
    redirect = false
    flash[:title_color] = ''
    flash[:release_date_color] = ''
    
    if params[:sort] == 'title'
      
      flash[:title_color] = 'hilite'
      @sort_by = params[:sort]
      
    elsif params[:sort] == 'release_date'
      
      flash[:release_date_color] = 'hilite'
      @sort_by = params[:sort]
      
    else
      @sort_by = :id
      redirect = true
    end
    if params["ratings"]
      @ratings = params["ratings"]
    else
      @ratings = {}
      @all_ratings.each do |rating|
        @ratings[rating] = "yes"
      end
      redirect = true
    end
    if redirect
      redirect_to movies_path(:sort=>@sort_by,:ratings=>@ratings)
    end
    all_movies = Movie.order(@sort_by)
    @movies = []
    all_movies.each do |movie|
      if @ratings.keys.include?(movie["rating"])
        @movies << movie
      end
    end
    flash[:sort] = @sort_by
    flash[:ratings] = @ratings
  end

  def new
    # default: render 'new' template
    @all_ratings = Movie.find(:all,:select=>"rating", :group => "rating").map(&:rating)
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
