Pod::Spec.new do |s|
  s.name         = "OperationPromise"
  s.version      = "0.0.1"
  s.summary      = "NSOperation(NSOperationQueue) dependency manager library."
  s.homepage     = "https://github.com/azu/OperationPromise"
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.author       = { "azu" => "info@efcl.info" }
  s.source       = { :git => "https://github.com/azu/OperationPromise.git", :commit => "a9dbd71277577ea06c510fbec73e06d5e94c5020" }
  s.source_files  = 'OperationPromise/*.{h,m}'
  s.requires_arc = true
end
