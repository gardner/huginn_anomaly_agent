# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = "huginn_anomaly_agent"
  spec.version       = '0.0.1'
  spec.authors       = ["Gardner Bickford"]
  spec.email         = ["gardner@bickford.nz"]

  spec.summary       = %q{Detect anomalies in a series of Huginn events.}
  spec.description   = %q{Anomaly Agent trains an isotree model to detect anomalies in a series of Huginn events. For a full description of options please see https://isotree.readthedocs.io/en/latest/#isotree.IsolationForest}

  spec.homepage      = "https://github.com/gardner/huginn_anomaly_agent"

  spec.license       = "MIT"

  spec.files         = Dir['LICENSE.txt', 'lib/**/*']
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = Dir['spec/**/*.rb'].reject { |f| f[%r{^spec/huginn}] }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 2.3.14"
  spec.add_development_dependency "rake", "~> 10.0"

  spec.add_runtime_dependency "huginn_agent"
  spec.add_runtime_dependency "isotree"
end
