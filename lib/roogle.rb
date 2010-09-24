class Roogle
  include Term::ANSIColor

  THE_GOOGLE = "http://google.com"

  def initialize
    @results = []
    @mech = ::Mechanize.new { |agent| agent.user_agent_alias = 'Mac Safari' }
  end

  def do_search(query)
    search_result = nil
    @mech.get(THE_GOOGLE) do |page|
      search_result = page.form_with(:name => 'f') do |search|
        search.q = ARGV.join(' ')
      end.submit
    end

    search_result.parser.css("h3.r a").each do |link|
      @results << link
      print red, "%2s " % [@results.size], reset
      print yellow, link.text[0..60].ljust(62), reset
      print " ", link.attr("href").split("/")[2]

      puts
    end

    print ":"

    n = STDIN.gets.chomp.to_i

    ::Launchy.open(@results[n - 1].attr('href')) unless n < 1
  end
end
