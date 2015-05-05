module CurrencyHelper

# Sort by full currency name
SORTED_CURRENCIES = Exchange::ISO.definitions.to_a.sort_by { |key, hash| hash[:currency] }

# Gather up all supported currencies across the main API (OpenExchangeRates)
# plus the fallback APIs (ECB and XavierMedia). These include some currencies
# not defined in the ISO definitions - those are rejected.
oer = Exchange::ExternalAPI::OpenExchangeRates::CURRENCIES

COMMON_CURRENCIES = %w(usd nzd aud gbp cad eur).map(&:to_sym)
SUPPORTED_CURRENCIES = oer.reject { |key| !Exchange::ISO.definitions.keys.include?(key) }
UNSUPPORTED_CURRENCIES = Exchange::ISO.definitions.keys - SUPPORTED_CURRENCIES

CURRENCIES       = {}
CURRENCY_OPTIONS = {}
CURRENCY_KEYS    = {
  :common      => COMMON_CURRENCIES,
  :supported   => SUPPORTED_CURRENCIES - COMMON_CURRENCIES
}

[ :common, :supported ].each do |group_sym|
  CURRENCIES[group_sym] = SORTED_CURRENCIES.select { |key, hash| CURRENCY_KEYS[group_sym].include?(key) }
  CURRENCY_OPTIONS[group_sym] = CURRENCIES[group_sym].map { |key, hash| ["#{hash[:currency]} - #{key.to_s.upcase}" << (hash[:symbol].present? ? " (#{hash[:symbol]})" : ''), key] }
end

CURRENCY_OPTIONS[:grouped] = [
  ["Common Currencies", CURRENCY_OPTIONS[:common]],
  ["Supported Currencies", CURRENCY_OPTIONS[:supported]]
]


def base_currency_code_select(curr)
  select_tag(curr, grouped_options_for_select(CurrencyHelper::CURRENCY_OPTIONS[:grouped]).html_safe, { :style => "width:160px" })
end

end