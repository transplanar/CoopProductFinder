class Product < ActiveRecord::Base
  scope :_name, ->(regex){Product.where("name ILIKE ?", regex)}
  scope :_code, -> (regex){Product.where("code ILIKE ?", "%#{regex}%") }
  scope :_price, ->(regex){Product.where("price = ?", regex)}
  scope :_keywords, ->(regex){Product.where("keywords ILIKE ?", regex)}
  scope :_department, ->(regex){Product.where("department ILIKE ?", regex)}

  def self.search user_input
    puts "Executing search using #{user_input}"

    unless user_input.blank?
      unless is_numeric?(user_input)
        search_queries = user_input.split
      else
        search_queries = [user_input.to_s]
      end

      formatted_queries = format_queries(search_queries)
      results = get_matches(formatted_queries)
    end
  end

  def self.format_queries search_queries
    formatted_queries = []

    search_queries.each do |query|
      unless is_numeric?(query)
        formatted_queries << query_to_regex(query)
      else
        formatted_queries << query
      end
    end

    return formatted_queries
  end

  private

  def self.get_matches queries
    results = []
    item_match_data = []
    columns = get_relevant_columns()

    queries.each do |query|
      item_match_data, exclude_columns = get_subset(query, item_match_data, columns)

      unless query == query.last
        columns = columns - exclude_columns
      end
    end

    results_by_column = item_match_data.group_by{|elem| elem[:columns]}.sort_by{|k,v| k}

    return results_by_column
  end

  def self.get_subset query, item_match_data, columns = []
    results = []
    exclude_columns = []

    if item_match_data.empty?
      item_set = Product.all
    else
      item_set = Product.where(id: item_match_data.map{|e| e[:item].id})
    end

    columns.each do |col|
      if is_numeric?(query)
        if col=='code'
          query = query.to_s
        end

        items_from_scope = item_set.send("_#{col}", query).limit(5)
      elsif col!='price' && col != 'code'
        items_from_scope = item_set.send("_#{col}", query).limit(5)
      end

      unless items_from_scope.nil?
        items_from_scope.each do |item|
          if item_match_data.empty?
            term_formatted = format_term(item["#{col}"], query)
            results << {item: item, columns: [col], term_matches: [term_formatted]}
          else
            existing_item = item_match_data.select{|e| e[:item] == item}.first
            existing_item[:columns] = existing_item[:columns] | [col]
            term_formatted = format_term(item["#{col}"], query)
            # existing_item[:term_matches] = existing_item[:term_matches] | [item["#{col}"]]
            existing_item[:term_matches] = existing_item[:term_matches] | [term_formatted]

            results << existing_item
          end

          exclude_columns << col
        end
      end
    end

    return [results, exclude_columns]
  end


  # Utils
  def self.query_to_regex query_string
    regex = ""
    letters = query_string.chars

    letters.each do |letter|
      if letter === letters.first
        regex << "#{letter}"
      else
        regex <<  "%#{letter}"
      end
    end

    regex = "%"+regex+'%'
  end

  def self.get_relevant_columns
    exclude_columns = ['id', 'image_url', 'created_at', 'updated_at', 'slot_id']
    exclude_columns << 'price'
    Product.attribute_names - exclude_columns
  end

  def self.is_numeric?(obj)
    new_str = obj.to_s.gsub('%','')
    new_str.match(/\A[+-]?\d+?(\.\d+)?\Z/) == nil ? false : true
  end

  def self.format_term string, sub_string
    string_arr = string.split(//)
    sub_string = sub_string.gsub('%','')

    sub_string.split(//).each do |char|
      index = string_arr.find_index{|e| e.upcase == char || e.downcase == char}

      formatted_term = "<span class='matched_letter_highlight'>#{string[index]}</span>"
      string_arr[index] = formatted_term
    end

    new_string = string_arr.join

    return new_string
  end
end
