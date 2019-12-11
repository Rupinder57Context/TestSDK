

Pod::Spec.new do |spec|

  spec.name         = "TestSDk"
  spec.version      = "1.0.0"
  spec.summary      = "SDK"

 
  spec.description  = "Aequum tech Test sdk"

  spec.homepage     = "https://github.com/Rupinder57Context/TestSDK"


  spec.license      = "MIT"
  spec.source       = { :git => "https://github.com/Rupinder57Context/TestSDK.git", 
             :tag => "#1.0" }



  
  spec.source_files  = "TestSDK"
  spec.exclude_files = "Classes/Exclude"

 

end
