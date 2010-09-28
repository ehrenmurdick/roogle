require 'mechanize'
require 'term/ansicolor'
require 'launchy'

class Roogle
  include Term::ANSIColor

  THE_GOOGLE = "http://google.com"

  def initialize
    @results = []
    @mech = ::Mechanize.new { |agent| agent.user_agent_alias = 'Mac Safari' }
  end

  def scan_page(page)
    page.parser.css("h3.r a").each do |link|
      @results << link
      print red, "%2s " % [@results.size], reset
      print yellow, link.text[0..60].ljust(62), reset
      print " ", link.attr("href").split("/")[2]

      puts
    end

    print ":"

    n = STDIN.gets.chomp

    if n == 'n'
      page = page.links.find {|l| l.text == "Next" }.click
      scan_page(page)
    elsif n == 'p'
      page = page.links.find {|l| l.text == "Previous" }.click
      scan_page(page)
    end

    ::Launchy.open(@results[n.to_i - 1].attr('href')) unless n.to_i < 1
  end

  def do_search(query)
    search_result = nil
    @mech.get(THE_GOOGLE) do |page|
      search_result = page.form_with(:name => 'f') do |search|
        search.q = query
      end.submit
    end

    scan_page(search_result)
  end
end
