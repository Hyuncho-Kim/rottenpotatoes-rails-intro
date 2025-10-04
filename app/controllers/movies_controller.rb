class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    #All possible ratings from movie model
    @all_ratings = Movie.all_ratings

    # #Determine whcih ratings to show based on params
    # if params[:ratings]
    #   @ratings_to_show = params[:ratings].keys
    # else
    #   #If no ratings in params, show all
    #   @ratings_to_show = @all_ratings
    # end

    # #sort parameter
    # @sort_by = params[:sort_by]
    
    #check if user has submitted form
    if params[:commit] || params[:sort_by]
      #setting preferences
      @sort_by = params[:sort_by]
      #use settings if inputted
      @ratings_to_show = params[:ratings] ? params[:ratings].keys : all_ratings

      #save new settings to remember them
      session[:sort_by] = @sort_by
      session[:ratings] = @ratings_to_show

    #returning to page to use saved settings
    elsif session[:ratings] || session[:sort_by]
      @sort_by = session[:sort_by]
      @ratings_to_show = session[:ratings]
    
    #user's frist visit
    else
      @sort_by = nil
      @ratings_to_show = @all_ratings
    end

    #Fetch movies using model's filtering method and ordered
    @movies = Movie.with_ratings(@ratings_to_show).order(@sort_by)
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

  private
  # Making "internal" methods private is not required, but is a common practice.
  # This helps make clear which methods respond to requests, and which ones do not.
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end
end
