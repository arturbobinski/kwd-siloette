class AppConfig

  def self.patterns
    {
      card_number:    '(4\d{12}(\d{3})?|(5[1-5]\d{4}|677189)\d{10}|(6011|65\d{2}|64[4-9]\d)\d{12}|(62\d{14})|3[47]\d{13})',
      cvc:            '[0-9]{3,4}',
      phonenumber:    '(1-?)?(\s+)?(\([2-9]\d{2}\)|[2-9]\d{2})(\s+)?-?[2-9]\d{2}-?\d{4}',
      social_security_number: '\d{9}',
      slug:           '[a-z0-9]+(?:-[a-z0-9]+)*',
      zipcode:        '(\d{5}(?:[-\s]\d{4})?|(GIR|[A-Z]\d[A-Z\d]??|[A-Z]{2}\d[A-Z\d]??)[ ]??(\d[A-Z]{2}))',
    }
  end
end