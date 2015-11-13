Pod::Spec.new do |s|
	s.name					= "APLineChart"
	s.version				= "1.1.0"
	s.summary				= "IOS Line Chart"
	s.description			= <<-DESC
							IOS Line Chart. It's a fully customizable Line chart using Interface Builder. 
							DESC
	s.homepage				= "https://github.com/tylyo/APLineChart"
	s.screenshots			= "https://camo.githubusercontent.com/7d1f8ec9e8cb8f45013219bd8d40b30f7a49f6ab/68747470733a2f2f7261772e6769746875622e636f6d2f74796c796f2f41504c696e6543686172742f6d61737465722f696d616765732f706f7274726169742e706e67", "https://camo.githubusercontent.com/86c32bdecb6f24b0bb120eddfe2eab148b7beb6a/68747470733a2f2f7261772e6769746875622e636f6d2f74796c796f2f41504c696e6543686172742f6d61737465722f696d616765732f6c616e6473636170652e706e67"
	s.license				= { :type => "MIT", :file => "LICENSE" }
	s.author				= { "Attilio Patania" => "AttilioPatania@gmail.com" }
	s.platform				= :ios, "5.0"
	s.source				= { :git => "https://github.com/tylyo/APLineChart.git", :tag => s.version.to_s }
	s.header_mappings_dir	= "APLineChart/APChartView"
	s.source_files			= "APLineChart/APChartView/*.{swift}"
end
