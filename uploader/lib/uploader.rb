require "net/https"
require "uri"

class Uploader
  def self.post(uri, content, options = {})
    options = {:boundary => 'myboundary', :ssl => false}.merge(options)
    uri = URI.parse(uri)
    http = Net::HTTP.new(uri.host, uri.port)
    if options[:ssl]
      http.use_ssl = options[:ssl]
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    end
    http.start do |http|
      request = Net::HTTP::Post.new(uri.path)
      request["user-agent"] = "Ruby/#{RUBY_VERSION} MyHttpClient"
      request.set_content_type("multipart/form-data; boundary=#{options[:boundary]}")
      request.body = create_body(options[:boundary], content)
      response = http.request(request)
      response.body
    end
  end

  def self.create_body(boundary, datas)
    body_data = []
    boundary_line = "--#{boundary}"

    datas.each do |data|
      body_data << boundary_line
      if data[:filename]
        body_data << 'content-disposition: form-data; name="%s"; filename="%s"' % [data[:name], data[:filename]]
      else
        body_data << 'content-disposition: form-data; name="%s"' % data[:name]
      end
      body_data << ''
      body_data << data[:content]
    end

    body_data << "--#{boundary}--"
    body_data.join("\r\n")
  end
end
