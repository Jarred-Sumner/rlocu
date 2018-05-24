
module Rlocu
  RlocuError = Class.new(StandardError)
  class << self
    attr_accessor :api_key, :redis_host, :redis_db, :cache_ttl, :redis_port

    def configure
      yield self
    end

    def api_version
      'v2'
    end
  end
end

require_relative 'rlocu/version'
require_relative 'rlocu/utilities/lat_long_radius'
require_relative 'rlocu/geo_json'
require_relative 'rlocu/menu'
require_relative 'rlocu/venue'
require_relative 'rlocu/query_builder'
require_relative 'rlocu/venue_query'
require_relative 'rlocu/venue_search'
