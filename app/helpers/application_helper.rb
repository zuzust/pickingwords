module ApplicationHelper

  # Layout Header
  # -------------------
  def full_title(title)
    base_title = "Pickingwords"
    title.empty? ? base_title : "#{base_title} | #{title}"
  end

  def page_description(description)
    base_description = "store and manage your tiny translations"
    description.empty? ? base_description : description
  end
  
  def page_keywords(keywords)
    base_keywords = "translations, words"
    keywords.empty? ? base_keywords : keywords
  end

  def title(title)
    provide(:title, title)
  end

  def description(description)
    provide(:description, description)
  end

  def keywords(keywords)
    provide(:keywords, keywords)
  end

  # Authentication & Authorization
  # -------------------------------------
  def logged_in?
    @logged_in ||= signed_in?(:user) || signed_in?(:admin)
  end

  def curr_user
    @curr_user ||= (current_user || current_admin)
  end
  
  def curr_user_roles
    @curr_user_roles = session[:curr_user_roles] ||= curr_user.roles.map(&:name)
  end

  # Frontend Styling
  # ---------------------
  def emphasize(word, sentence)
    pattern = word.sub(/\s+/, '.*')
    raw(sentence.gsub(/#{pattern}/i) { |s| "<strong>#{s}</strong>" })
  end

end
