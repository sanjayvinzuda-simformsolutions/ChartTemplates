# Requirements:
# -------------
#
# * Git
# * Ruby  >= 2.7.0
# * Rails >= 7

# =========================================== Execute This Template =================================================
# rails app:template LOCATION=templates/highcharts_template.rb

# ================================================= Add gems into Gemfile ===========================================

say_status "RubyGems" , "Adding highcharts into Gemfile..\n", :yellow
gem 'highcharts-rails'

# ================================================= Install GEMS ====================================================

puts
say_status "Rubygems", "Installing Rubygems...", :yellow
run "bundle install"

# ==================================================================================================================

# ================================ Integrate Highcharts-rails into rails application ===============================

models =
[
  'Chart'
]

models.each do |model_name|
  class_name = model_name.underscore
  class_name_pluralize = class_name.pluralize

  # ================================ Generating a controller for our model ========================================

  generate(:controller, "#{class_name_pluralize}" ,"index")

  # ================================ Making a requiring changes in application.html.erb file ======================

  inject_into_file 'app/views/layouts/application.html.erb' do
    '<script src="https://code.highcharts.com/highcharts.js"></script>'
  end

  # ================================ Making a requiring changes in view file ======================

  inject_into_file "app/views/#{class_name_pluralize}/index.html.erb" do
    '<div id="chart-container"></div>

    <script>
      document.addEventListener("DOMContentLoaded", function() {
        Highcharts.chart("chart-container", {
          title: {
            text: "Highcharts Rails Demo"
          },
          series: [{
            name: "Data",
            data: [1, 2, 3, 4, 5]
          }]
        });
      });
    </script>
  '
  end

  # ================================ Making a requiring changes in routes file ======================

  gsub_file 'config/routes.rb', "get '#{class_name_pluralize}/index'", <<-CODE
    root "#{class_name_pluralize}#index"
  CODE
end

