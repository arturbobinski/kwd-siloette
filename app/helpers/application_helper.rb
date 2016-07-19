module ApplicationHelper

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
end
