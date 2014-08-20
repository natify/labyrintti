module Labyrintti
  class Base
    # Initializing Labyrintti SMS Gateway client
    #
    # @param user [String] Username that identifies message sender
    # @param password [String] Password for the user
    # @param service_options [Hash] Various options for SMS Sending
    #
    def initialize(user = Labyrintti.user, password = Labyrintti.password, service_options = {})
      fail 'user must be set' unless user.present?
      fail 'password must be set' unless password.present?
      @default_options  = {
        user:     user,
        password: password
      }
      @service_options = service_options
    end

    def service_url
      @service_url ||= if @service_options.delete(:secure)
                         'https://gw.labyrintti.com:28443'
                       else
                         'http://gw.labyrintti.com:28080'
                       end
    end

    def make_api_call(options = {})
      options.merge!(@default_options)
      options.merge!(@service_options)
      options.delete_if { |_, value| !value.present? }
      process_response connection.post('/sendsms', options)
    end

    def process_response(response)
      if response.success?
        { ok: true }
      else
        { errors: parse_error(response.body) }
      end
    end

    def parse_error(body)
      body.lines.map do |line|
        res = line.match(/(?<number>\+?\d+) ERROR (?<error_code>\d+) (?<message_count>\d+) (?<description>.*)/)
        if res
          {
            number:        res[:number],
            error_code:    res[:error_code],
            message_count: res[:message_count],
            description:   res[:description]
          }
        else
          { error: line }
        end
      end
    end

    def faraday_options
      {
        url:     service_url,
        headers: {
          accept:     'text/plain',
          user_agent: ::Labyrintti.user_agent
        }
      }
    end

    def connection # :nodoc
      @connection ||= ::Faraday.new(faraday_options) do |conn|
        conn.request :url_encoded
        conn.adapter Faraday.default_adapter
        conn.response :logger, ::Labyrintti.logger if ::Labyrintti.debug
      end
    end
  end
end
