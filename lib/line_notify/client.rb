require 'line_notify/version'
require 'net/https'

module LineNotify
  # line notify
  class Client
    NOTIFY_URI = URI.parse('https://notify-api.line.me/api/notify')
    REVOKE_URI = URI.parse('https://notify-api.line.me/api/revoke')

    def initialize(access_token)
      @access_token = (access_token || ENV['LINE_ACCESS_TOKEN'])
    end

    def ping(options)
      request = create_request(options, NOTIFY_URI)
      Net::HTTP.start(NOTIFY_URI.hostname, NOTIFY_URI.port, use_ssl: NOTIFY_URI.scheme == 'https') do |req|
        req.request(request)
      end
    end

    def revoke
      request = create_request(nil, REVOKE_URI)
      Net::HTTP.start(REVOKE_URI.hostname, REVOKE_URI.port, use_ssl: REVOKE_URI.scheme == 'https') do |req|
        req.request(request)
      end
    end

    private

    def create_request(options, uri)
      request = Net::HTTP::Post.new(uri)
      request['Authorization'] = "Bearer #{@access_token}"
      request.set_form_data(options) if options.present?
      request
    end
  end
end
