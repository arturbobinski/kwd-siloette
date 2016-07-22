module ServicesHelper

  def sort_options
    %i(rating price_cents performers_count)
  end

  def price_with_unit(service)
    "#{humanized_money_with_symbol(service.price)}#{t('common.per_hour')}"
  end

  def performer_names(service)
    service.performers.map(&:perform_name).join(', ')
  end

  def performer_names_without_me(service)
    service.performers.to_a.delete_if { |x| x.id == current_user.try(:id) }.map(&:name).join(', ')
  end
end
