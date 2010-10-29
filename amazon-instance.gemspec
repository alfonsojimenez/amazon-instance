Gem::Specification.new do |s|
  s.name = %q{amazon-instance}
  s.version = "0.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Alfonso Jimenez"]
  s.date = %q{2010-10-16}
  s.description = %q{A tool for creating new Amazon EC2 instances. It allows you to organize your instances by projects and environments.}
  s.email = %q{yo@alfonsojimenez.com}
  s.bindir = 'bin'
  s.executables = ['amazon-instance']
  s.default_executable = 'amazon-instance'
  s.extra_rdoc_files = ['LICENSE']
  s.files = [
     "LICENSE",
     "README.textile",
     "Rakefile",
     "lib/amazon-instance/amazon-ec2.rb",
     "lib/amazon-instance/project.rb",
     "lib/amazon-instance.rb",
     "bin/amazon-instance",
     "spec/amazon_instance_spec.rb",
     "spec/fixtures/general.yml",
     "spec/fixtures/projects/example.yml",
     "spec/fixtures/on-boot/script.sh",
     "config/general.yml",
     "config/projects/example.yml",
     "config/on-boot/script.sh"
  ]
  s.homepage = %q{http://github.com/alfonsojimenez/amazon-instance}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{A tool for creating new Amazon EC2 instances}
  s.test_files = [
    "spec/amazon_instance_spec.rb"
  ]

  s.add_dependency(%q<amazon-ec2>, [">= 0.9.15"])
  s.add_dependency(%q<rspec>, [">= 2.0.0.beta.20"])
  s.add_dependency(%q<trollop>, [">= 1.16.2"])
end
