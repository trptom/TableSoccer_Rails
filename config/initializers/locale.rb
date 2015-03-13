# set default locale to something other than :en
I18n.enforce_available_locales = false
I18n.available_locales = ['cs', 'en']
I18n.default_locale = 'cs'

def format_amount(amount)
  currency_string = I18n.t "messages.currency.name.#{CURRENCY}"
  return I18n.t "messages.currency.format.#{CURRENCY}", :amount => amount, :currency => currency_string
end