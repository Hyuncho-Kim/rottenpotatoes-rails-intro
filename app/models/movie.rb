class Movie < ActiveRecord::Base
  def self.all_ratings
    #Returns all possible values of a movie rating
    self.pluck(:rating).uniq.sort
  end

  def self.with_ratings(ratings_list)
    # if ratings_list is an array such as ['G', 'PG', 'R'], retrieve all
    #  movies with those ratings
    # if ratings_list is nil, retrieve ALL movies
    if ratings_list.present?
      self.where(rating: ratings_list)
    else
      self.all
    end
  end
end
