require 'rest_client'
require 'json'
# require '../app/models/book'

describe 'Library API' do
  before(:all) do
    @api_key_params = { api_key: 'GFN98piQ7qD9x'}
  end

  it 'has two libraries' do
    response = RestClient.get("localhost:9292/libraries", params: @api_key_params)
    h = JSON.parse(response.body)
    expect(h.size).to eq(2)
  end
  
  it 'knows that Newport Beach Library has 3 books and `Universal Principles of Design` is checked out' do
    response = RestClient.get("localhost:9292/libraries/1/books", params: @api_key_params)
    h = JSON.parse(response.body)
    expect(h.size).to eq(3)

    upod = h.select { |b| b['id'] == 1 }.first
    expect(upod['state']).to eq('checked_out')
  end

  # it 'doesn`t allow a book that has been checked out to be checked out again' do
  #   payload = @api_key_params.merge(user_id: 2)

  #   response = RestClient.post("localhost:9292/books/3/checkout", payload)
  #   puts response.inspect

  #   response = RestClient.post("localhost:9292/books/3/checkout", payload) rescue nil
  #   expect(response).to eq(nil)
  # end

end