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

  def locales
    [:en, :ca, :es]
  end

end
