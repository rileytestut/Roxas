Pod::Spec.new do |spec|
  spec.name         = "Roxas"
  spec.version      = "0.1"
  spec.summary      = "Private iOS Development Framework"
  spec.description  = "Private iOS Development Framework used by me in my projects."
  spec.homepage     = "https://github.com/rileytestut/roxas"
  spec.platform     = :ios, "12.0"
  spec.source       = { :git => "http://github.com/rileytestut/Roxas.git" }

  spec.author             = { "Riley Testut" => "riley@rileytestut.com" }
  spec.social_media_url   = "https://twitter.com/rileytestut"
  
  spec.source_files  = "Roxas/*.{h,m}"
  spec.public_header_files = "Roxas/*.h"
  spec.private_header_files = "Roxas/RSTCellContentDataSource_Subclasses.h"
  spec.prefix_header_file = 'Roxas/Roxas-Prefix.pch'
  spec.resources = "Roxas/*.xib"
end
