# frozen_string_literal: true

class Application < Roda
  def self.root
    File.expand_path('..', __dir__)
  end

  plugin :public, root: "#{Application.root}/spa/build"
  plugin :multi_run
  plugin :type_routing
  plugin :environments
  plugin :run_append_slash
  plugin(:not_found) { not_found_response }

  run 'api', ApiRouter
  route do |r|
    r.multi_run
    r.public
    r.get do
      r.html { IO.read("#{Application.root}/spa/build/index.html") }
    end
  end

  private

  def params
    request.params
  end
end
