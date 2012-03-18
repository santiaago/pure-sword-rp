class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end
  
  #def initialize
  #  @all_ratings = Movie.all_ratings
  #  @ratings = @all_ratings
  #  @sort_by = :id
  #  super
  #end

  def index
    @all_ratings = Movie.all_ratings
    redirect = false
    flash[:title_color] = ''
    flash[:release_date_color] = ''
    @ratings = @all_ratings
    
    if params[:commit]=="Refresh"
      session[:ratings] = params[:ratings]
    end
    if params[:sort]!= nil
      session[:sort] = params[:sort]
    end
    
    if params[:sort] == nil and params[:sort] == nil
       redirect_opts = {}
       if session[:sort] != nil
         redirect_opts[:sort] = session[:sort]
       end
       if session[:ratings] != nil
         redirect_opts[:ratings] = session[:ratings]
       end
       if !redirect_opts.empty?
         redirect_to movies_path(redirect_opts)
       end
     end
    
    if params[:sort] == 'title'
      #@movies = Movies.order(params[:sort])
      flash[:title_color] = 'hilite'
      @sort_by = params[:sort]
    elsif params[:sort] == 'release_date'
      #@movies = Movies.order(params[:sort])
      flash[:release_date_color] = 'hilite'
      @sort_by = params[:sort]
    elsif session[:sort]
      @sort_by = session[:sort]
      redirect = true  
    #else
      #@sort_by = :id
      #redirect = true
    end
    if params["ratings"]
      @ratings = params["ratings"]
    elsif session[:ratings]
      @ratings = session[:ratings]
      redirect = true
    else
      @ratings = {}
      @all_ratings.each do |rating|
        @ratings[rating] = "yes"
      end
      #redirect = true
    end
    
    if redirect
      #if @sort_by == :id and !@ratings.empty?
      #  redirect_to movies_path(:ratings=>@ratings)
      #elsif @sort_by != :id and @ratings.empty?
      #  redirect_to movies_path(:sort=>@sort_by)
      #else
        #redirect_to movies_path
      #end
      print "hello!"
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
    #session[:sort] =@sort_by
    #session[:ratings]=@ratings
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
