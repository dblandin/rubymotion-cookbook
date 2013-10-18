class AppProperties
  VERSION = '0.1'
  COMPANY_NAME = 'devonblandin'

  def name
    'Template'
  end

  def normalized_name
    name.downcase.gsub(/\s/, '_')
  end

  def version
    VERSION
  end

  def additional_frameworks
    %w()
  end

  def additional_libraries
    %w()
  end

  def contributors
    ['Devon Blandin']
  end

  def developer_certificate
    ENV['DEVELOPER_CERTIFICATE']
  end

  def distribution_certificate
    ENV['DISTRIBUTION_CERTIFICATE']
  end

  def provisioning_profile
    './provisioning' # symlink
  end

  def deployment_target
    '6.0'
  end

  def additional_directories
    %w(lib config)
  end

  def prerendered_icon
    true
  end

  def devices
    [:iphone]
  end

  def identifier
    ['com', COMPANY_NAME, normalized_name].join('.')
  end

  def description
    %W[
      Enter a description
    ]
  end

  def orientations
    [:portrait]
  end

  def icons
    %w(Icon.png Icon-72.png Icon@2x.png)
  end

  def additional_files
    additional_directories.map {|dir| Dir.glob("./#{dir}/**/*.rb") }
  end

  def major_version
    VERSION.scan(/\d+/).first
  end
end
