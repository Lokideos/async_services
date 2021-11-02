# frozen_string_literal: true

class Application < Roda
  def self.root
    File.expand_path('..', __dir__)
  end

  plugin :environments
  plugin :json_parser
  plugin(:not_found) { not_found_response }

  route do |r|
    r.root do
      response['Content-Type'] = 'application/json'
      response.status = 200
      { status: 'ok' }.to_json
    end

    r.get 'favicon.ico' do
      'no icon'
    end
  end

  private

  def params
    request.params
  end
end
