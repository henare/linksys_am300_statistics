require 'rubygems'
require 'mechanize'

class DSLModem
  def initialize(url='http://192.168.1.1/index.stm?title=Status-Modem', username, password)
    @url, @username, @password = url, username, password
    get_stats_page
  end

  def get_stats_page
    # Get the login page
    agent = Mechanize.new
    @page = agent.get(@url)

    # If we're already logged in (don't ask), then we already have the page we need
    return @page if @page.title != "Log In"

    # Login
    form = @page.forms.first
    form.field_with(:name => "username").value = @username
    form.field_with(:name => "password").value = @password
    form.submit

    # Get stats page
    @page = agent.get(@url)
  end

  def statistics
    status_table = @page.search("#table1")[1]

    {
      :bandwidth_downstream => @page.search("#table1")[1].search('b')[3].inner_text.strip.split[0],
      :bandwidth_upstream => @page.search("#table1")[1].search('b')[4].inner_text.strip.split[0],
      :margin_downstream => @page.search("#table1")[1].search('b')[5].inner_text.strip.split[0],
      :margin_upstream => @page.search("#table1")[1].search('b')[6].inner_text.strip.split[0]
    }
  end

  def offline?
    @page.search("#table1")[1].search('b')[3].inner_text.strip.split[0] == "0" ? true : false
  end
end
