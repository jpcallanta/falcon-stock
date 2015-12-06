require 'rubygems'
require 'colors'
require 'columnize'
require 'net/http'
require 'json'

class Falconstock
  def initialize()
    @lookup_response = []
    @quote_response = []
    @lookup_url = 'http://dev.markitondemand.com/MODApis/Api/v2/Lookup/json?'
    @quote_url = 'http://dev.markitondemand.com/MODApis/Api/v2/Quote/json?'
  end

  def config_dir_exists?
    return File.directory?('~/.falcon-stock')
  end

  def config_file_exists?
    return File.exists?('~/.falcon-stock/.falcon-stock.yml')
  end

  def lookup_company(company)
    uri = URI("#{@lookup_url}input=#{company}")
    @lookup_response = JSON.parse(Net::HTTP.get(uri))
  end

  def lookup_quote(company)
    uri = URI("#{@quote_url}symbol=#{company}")
    @quote_response = JSON.parse(Net::HTTP.get(uri))
  end

  def lookup_company_display(company)
    lookup_company(company)

    @lookup_response.each do |resp|
      puts "#{resp['Symbol']} - #{resp['Name']} - #{resp['Exchange']}"
    end
  end
end