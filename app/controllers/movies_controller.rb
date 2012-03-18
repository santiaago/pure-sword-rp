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
      #@movies = Movie.find :all, :order => 'title'
      flash[:title_color] = 'hilite'
      @sort_by = params[:sort]
    elsif params[:sort] == 'release_date'
      #@movies = Movie.find :all, :order => 'release_date'
      flash[:release_date_color] = 'hilite'
      @sort_by = params[:sort]
    else
      #@movies = Movie.all
      @sort_by = :id
      redirect = true
    end
    
    if params["ratings"]
      @ratings= params["ratings"]
      @movies = Movies.find :all, :order => 'title'#:ratings => @ratings
    else
      @ratings = {}
      @all_ratings.each do |rating|
        @ratings[rating]="yes"
      end
          redirect = true
    end
    if redirect
        @movies = Movie.all
        # redirect_to movies_path(:order=>@sort_by)#,:ratings=>@ratings)
    end
    
    #all_movies = Movie.order(@sort_by)
    #@movies = []
    #all_movies.each do |movie|
    #  if @ratings.keys.include?(movie["rating"])
    #    @movies << movie
    #  end
    #end
    
  end

  def new
    # default: render 'new' template
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
