

Pod::Spec.new do |spec|

  spec.name         = "TestSDK"
  spec.version      = "0.1.0"
  spec.summary      = "SDK"

 
  spec.description  = "Aequum tech Test sdk"

  spec.homepage     = "https://github.com/Rupinder57Context/TestSDK"


  spec.license      = "MIT"
  spec.source       = { :git => "https://github.com/Rupinder57Context/TestSDK.git", 
             :tag => "0.1.0" }



  
  spec.source_files  = "TestSDK"
  spec.exclude_files = "Classes/Exclude"

 

end
