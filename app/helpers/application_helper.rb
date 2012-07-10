module ApplicationHelper

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

  def logged_in?
    signed_in?(:user) || signed_in?(:admin)
  end

  def user
    @sin_user ||= (current_user || current_admin)
  end

end
