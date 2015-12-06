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
    return File.directory?('~/.falconstock')
  end

  def config_file_exists?
    return File.exists?('~/.falcon-stock/.falconstock.yml')
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

  def lookup_quote_display(company)
    lookup_quote(company)
    company_name = "#{@quote_response['Name']} - #{@quote_response['Symbol']}"

    puts company_name.colorize(:blue)
    puts "Last Price: $#{@quote_response['LastPrice']} - #{@quote_response['Timestamp']}".colorize(:green)

    if @quote_response['Change'].to_s.include?('-')
      puts "Price Change: $#{@quote_response['Change']}".colorize(:red)
      puts "% Change: #{@quote_response['ChangePercent']}".colorize(:red)
    else
      puts "Price Change: $#{@quote_response['Change']}".colorize(:green)
      puts "% Change: #{@quote_response['ChangePercent']}".colorize(:green)
    end

    puts ''
  end
end
