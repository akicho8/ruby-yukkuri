Gem::Specification.new do |spec|
  spec.name = "ruby-yukkuri"
  spec.version = "0.0.1"
  spec.summary = "ruby yukkuri"
  spec.author = "akicho8"
  spec.homepage = "http://github.com/akicho8/ruby-yukkuri"
  spec.description = "Windows yukkuri voice remote controll script"
  spec.email = "akicho8@gmail.com"
  spec.files = %x[git ls-files].scan(/\S+/)
  spec.test_files = []
  spec.rdoc_options = ["--line-numbers", "--inline-source", "--charset=UTF-8", "--diagram", "--image-format=jpg"]
  spec.executables = ["y"]
  spec.platform = Gem::Platform::RUBY
end
