module Labyrintti
  class SMS < ::Labyrintti::Base
    def send_text(options = {})
      text = options.delete(:text)
      fail 'text is required param' unless text
      from = options.delete(:from)
      to = options.delete(:to)
      make_api_call(
                      'source-name' => from,
                      'dests' => Array(to).join(','),
                      'text' => text
                    )
    end
  end
end
