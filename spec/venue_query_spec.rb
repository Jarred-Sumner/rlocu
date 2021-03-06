include Rlocu
require 'config_rlocu_spec_helper'

RSpec.describe VenueQuery, '#new' do
  it 'should raise ArgumentError unless query_fields is a hash' do
    expect{ VenueQuery.new(query_fields: 'spec', return_fields: ['spec']) }.to raise_error(ArgumentError)
  end

  it 'should raise ArgumentError unless return_fields is an array' do
    expect{ VenueQuery.new(query_fields: {field: 'spec'}, return_fields: 'spec') }.to raise_error(ArgumentError)
  end

  it 'should raise ArgumentError if return_fields is empty' do
    expect{ VenueQuery.new(query_fields: {field: 'spec'}, return_fields: []) }.to raise_error(ArgumentError)
  end

  it 'should raise ArgumentError if query_fields is empty' do
    expect{ VenueQuery.new(query_fields: {}, return_fields: ['spec']) }.to raise_error(ArgumentError)
  end
end

RSpec.describe VenueQuery, '#query', type: :integration do
  it 'should return an array of venues' do
    key_value_conditions = [QueryBuilder::KeyValueCondition.new(key: 'locu_id', value: '45d336c20afe6c39abc2')]
    query_conditions = [QueryBuilder::QueryCondition.new(key_value_conditions: key_value_conditions)]
    venue_query = VenueQuery.new(query_conditions: query_conditions, return_fields: ['locu_id', 'name', 'menus'])
    expect(venue_query.query).not_to be_empty
  end
end
