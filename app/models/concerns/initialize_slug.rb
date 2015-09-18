module InitializeSlug
  def generate_slug(array_translations)
    array_translations.each do |translation|
      if translation.class == CategoryTranslation
        if CategoryTranslation.where("name like '%#{translation.name}%'").exists?
          num_coincidences = CategoryTranslation.where("name like '%#{translation.name}%'").size
          slug = "#{translation.name}_#{num_coincidences}"
        else
          slug = translation.name
        end
      elsif translation.class == ProductTranslation
        if ProductTranslation.where("name like '%#{translation.name}%'").exists?
          num_coincidences = ProductTranslation.where("name like '%#{translation.name}%'").size
          slug = "#{translation.name}_#{num_coincidences}"
        else
          slug = translation.name
        end
      elsif translation.class == TagTranslation
        if TagTranslation.where("name like '%#{translation.name}%'").exists?
          num_coincidences = TagTranslation.where("name like '%#{translation.name}%'").size
          slug = "#{translation.name}_#{num_coincidences}"
        else
          slug = translation.name
        end
      end

      translation.slug = parse_url_chars(slug)
    end
  end

  def parse_url_chars(str)
    out = str.downcase
    out = out.tr(' ', '-')

    out = URI.encode(out)
    out.gsub('%23', '#') # Restore hashtags
  end

  def slug_to_href(object)
    href = object.slug

    if !href.nil? && !link?(object.slug)
      helpers = Rails.application.routes.url_helpers

      if object.class == Category
        href = helpers.show_slug_categories_path(object.slug)
      elsif object.class == Product
        href = helpers.show_slug_products_path(object.slug)
        if object.categories.any?
          href = helpers.show_product_slug_categories_path(object.categories.first.slug, object.slug)
        end
      end
    end

    href
  end

  def link?(href)
    href.start_with?('/') || href.start_with?('#') || href.start_with?('http')
  end
end
