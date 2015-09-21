Pod::Spec.new do |s|
  s.name         = 'IGYouTubeExtractor'
  s.version      = '0.5.0'
  s.summary      = 'IGYouTubeExtractor provides an easy way to obtain MP4 URLs and metadata for your iOS apps by providing a YouTube video identifier.'
  s.homepage     = 'https://github.com/siuying/IGYouTubeExtractor'
  s.author       = { 
    'Francis Chong' => 'francis@ignition.hk',
    'Rune Madsen' => 'runemadsen@mac.com' 
  }
  s.license      = {  :type => 'MIT', :file => 'LICENSE' }
  s.source       = { 
    :git => 'https://github.com/siuying/IGYouTubeExtractor.git',
    :tag => s.version.to_s
  }

  s.ios.deployment_target = "7.0"
  s.osx.deployment_target = "10.9"

  s.source_files = 'IGYouTubeExtractor'
  s.frameworks   = 'AVFoundation'
  s.requires_arc = true
end
