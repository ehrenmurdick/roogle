require 'mechanize'
require 'term/ansicolor'
require 'launchy'

class Roogle
  include Term::ANSIColor

  THE_GOOGLE = "http://google.com"
  PER_PAGE = 10
  RESULT_SELECTOR = "li:nth-child(-n+10) h3.r a"

  attr_reader :results

  def initialize
    @results = []
    @cursor = 0
    @mech = ::Mechanize.new { |agent| agent.user_agent_alias = 'Mac Safari' }
  end

  def show_options(links)
    links.each_with_index do |link, index|
      print red, "%2s " % [index + 1 + @cursor], reset
      print yellow, link.text[0..60].ljust(62), reset
      print " ", link.attr("href").split("/")[2]

      puts
    end
  end

  def get_input
    print ":"

    STDIN.gets.chomp
  end

  def scan_page
    @page.parser.css(RESULT_SELECTOR).each do |link|
      @results << link
    end
  end

  def interact
    this_slice = @results[@cursor, PER_PAGE]
    show_options(this_slice)
    n = get_input

    if n == 'n'
      @cursor += PER_PAGE
      if @cursor + PER_PAGE > @results.size
        @page = @page.links.find {|l| l.text == "Next" }.click
        scan_page
      end
      interact
    elsif n == 'p'
      @cursor -= PER_PAGE
      interact
    elsif n.to_i > 0
      open(@results[n.to_i - 1].attr('href')) 
    end
  end

  def do_search(query)
    search_result = nil
    @mech.get(THE_GOOGLE) do |page|
      search_result = page.form_with(:name => 'f') do |search|
        search.q = query
      end.submit
    end

    @page = search_result

    scan_page
    interact
  end

  def open(url)
    ::Launchy.open(url)
  end
end
