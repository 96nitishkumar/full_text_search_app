class Article < ApplicationRecord
	before_save :update_tsvector

	  def self.search(query)
	   # Perform full-text search on exact match
	    exact_matches = where("tsv @@ plainto_tsquery(?)", query)

    	similar_matches = where("name || ' ' || description ILIKE ?", "%#{query}%")
	    
	    # Combine both sets of matches
	    combined_matches = exact_matches + similar_matches
	    
	    combined_matches.uniq
	  end

	  private

	  	def update_tsvector
			self.tsv = Article.connection.select_value(
      		Article.sanitize_sql_array(["SELECT to_tsvector(?)", "#{name} #{description}"])
   		 	)	  
		end

end
