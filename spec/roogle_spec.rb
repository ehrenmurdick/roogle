require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Foobar" do
  let(:roogle) { Roogle.new }

  before do
    roogle.stub!(:get_input).and_return(nil)
    roogle.stub!(:show_options).and_return(nil)
    roogle.stub!(:open).and_return(nil)

    FakeWeb.register_uri(:get, "http://google.com/", 
                         :response => File.read("spec/fixtures/google.html"))

    FakeWeb.register_uri(:get, "http://google.com/search?hl=en&source=hp&ie=ISO-8859-1&q=foobar", 
                         :response => File.read("spec/fixtures/foobar.html"))

    FakeWeb.register_uri(:get, "http://google.com/search?q=g+foobar&hl=en&prmd=iv&ei=tovdTL2ULIaksQPowpn_CQ&start=10&sa=N",
                         :response => File.read("spec/fixtures/foobar.html"))

  end

  it "gets ten results per page" do
    roogle.do_search("foobar")
    roogle.results.size.should == 10
  end

  it "fetches the next page when input is 'n'" do
    roogle.stub!(:get_input).and_return("n")
    roogle.do_search("foobar")
    roogle.interact
    roogle.results.size.should == 20
  end
end
