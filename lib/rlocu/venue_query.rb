require 'faraday'
require 'json'
require 'active_support/cache'

module Rlocu
  class VenueQuery
    include Rlocu::QueryBuilder
    VenueQueryError = Class.new(StandardError)

    def faraday_client
      @faraday ||= Faraday.new do |faraday|
          faraday.response :logger
        faraday.adapter  Faraday.default_adapter
      end
    end

    attr_reader :return_fields

    def initialize(query_conditions:, return_fields:)
      raise ArgumentError, 'Query Conditions Param must be an array of QueryConditions.' if !query_conditions.is_a?(Array) || !query_conditions.first.is_a?(QueryCondition)

      raise ArgumentError, 'Return Fields Param must be an array of fields.' if !return_fields.is_a?(Array) || return_fields.empty?
      @query_conditions = query_conditions
      @return_fields = return_fields
    end

    def query_conditions
      @query_conditions.map(&:to_h)
    end

    def form_data
      {api_key: Rlocu.api_key, fields: return_fields, venue_queries: query_conditions }.to_json
    end

    def store
      @store ||= ActiveSupport::Cache.lookup_store(:redis_store, { host: Rlocu.redis_host, port: Rlocu.redis_port, db: Rlocu.redis_db })
    end

    def store_key(url, data)
      [url, data].join("_")
    end

    def query
      body = store.fetch(store_key(base_url, form_data), expires_in: Rlocu.cache_ttl) do
        faraday_client.post(base_url, form_data).body
      end
      result = JSON.parse(body)
      status = result['status']
      raise VenueQueryError.new("Query failed with status [#{status}] and http_status [#{result['http_status']}]") unless status == 'success'
      result['venues'].each.reduce([]) { |accum, venue| accum << Rlocu::Venue.new(venue) }
    end
  end
end
