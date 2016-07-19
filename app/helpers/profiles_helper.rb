module ProfilesHelper
  def age(birth_date)
    Time.zone.today.year - birth_date.to_date.year
  end

  def humanized_height(height)
    if height < 5
      t('unit.below_size', size: "5' 0\"(152cm)")
    elsif height >= 6.4
      t('unit.above_size', size: "6' 3\"(192cm)")
    else
      foot = height.to_i
      "#{foot}' #{((height - foot) * 10).round}\" (#{foot_to_cm(height)}cm)"
    end
  end

  def foot_to_cm(height)
    (height.to_f * 30.48).round
  end

  def humanized_weight(weight)
    if weight < 100
      t('unit.below_size', size: "100lbs(45kg)")
    elsif weight >= 210
      t('unit.above_size', size: "200lbs(91kg)")
    else
      "#{weight}lbs (#{lbs_to_kg(weight)}kg)"
    end
  end

  def lbs_to_kg(weight)
    (weight.to_f * 0.453592).round
  end
end
