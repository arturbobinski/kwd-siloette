module ApplicationHelper

  def mobile?
    request.variant.include?(:tablet) || request.variant.include?(:phone)
  end

  def bootstrap_class_for(flash_type)
    case flash_type.to_sym
      when :alert
        'warning'
      when :notice
        'success'
      when :error
        'danger'
      else
        flash_type.to_s
    end
  end

  def first_words(content, count=9)
    splitted = strip_tags(content).split(' ')
    ret = splitted[0..count].join(' ')
    if splitted.length > count
      ret << '...'
    end
    ret
  end

  def country_options
    Country.order(:name).select(:id, :name)
  end

  def parsley_pattern(key)
    "^#{AppConfig.patterns[key]}$"
  end
end
