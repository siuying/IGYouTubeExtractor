Pod::Spec.new do |s|
  s.name         = 'IGYouTubeExtractor'
  s.version      = '0.2.0'
  s.summary      = 'IGYouTubeExtractor provides an easy way to obtain MP4 URLs and metadata for your iOS apps by providing a YouTube video identifier.'
  s.homepage     = 'https://github.com/runmad/RMSwipeTableViewCell'
  s.author       = { 
    'Francis Chong' => 'francis@ignition.hk',
    'Rune Madsen' => 'runemadsen@mac.com' 
  }
  s.license      = {  :type => 'MIT', :file => 'LICENSE' }
  s.source       = { 
    :git => 'https://github.com/siuying/IGYouTubeExtractor.git',
    :tag => s.version.to_s
  }
  s.platform     = :ios, '7.0'
  s.source_files = 'IGYouTubeExtractor'
  s.frameworks   = 'AVFoundation'
  s.requires_arc = true
end
