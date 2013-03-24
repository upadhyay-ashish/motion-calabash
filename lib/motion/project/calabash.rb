# Copyright (c) 2012, LessPainful <karl@lesspainful.com>
# All rights reserved.
# 
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
# 
# 1. Redistributions of source code must retain the above copyright notice,
#    this list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the above copyright notice,
#    this list of conditions and the following disclaimer in the documentation
#    and/or other materials provided with the distribution.
# 
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
# ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
# LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
# CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
# SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
# INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
# CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
# ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
# POSSIBILITY OF SUCH DAMAGE.

Motion::Project::App.setup do |app|
 app.development do
   app.vendor_project File.join(File.dirname(__FILE__),"..",'..','framework'), :static
 end
end


namespace 'calabash' do
  desc "Run Calabash tests. Params are passed to cucumber"

  # Retrieve optional Calabash args.
  def gather_calabash_env
    sdk = ENV['target'] || ENV['sdk'] || ENV['SDK_VERSION'] || "6.1" #Calabash env vars
     major = sdk[0]
     os = ENV['os'] || ENV['OS']
     if os.nil?
       os = "ios#{major}"
     end
     device = ENV['device_family'] || ENV['device'] || ENV['DEVICE'] || 'iphone' #Calabash env vars
     {"SDK_VERSION" => sdk, "OS" => os, "DEVICE" => device}
  end


  task :run do
    # Retrieve optional args to pass to cucumber.
    args = ENV["args"] || ""

    ENV['DEVICE_ENDPOINT'] ||= 'http://localhost:37265/'

    target = ARGV[1] || 'simulator'


    project_config_vars = Motion::Project::App.config.variables

    bundle_id = project_config_vars["identifier"]

    calabash_env = gather_calabash_env

    calabash_env['DEVICE_TARGET'] = target
    calabash_env['BUNDLE_ID'] = bundle_id

    unless target == 'device'
      # Retrieve optional bundle path.
      bundle_path = ENV['APP_BUNDLE_PATH']
      unless bundle_path
        build = "build"
        unless File.exist?(build)
          App.fail "No dir found: #{build}. Please build app first."
        end
        sim_dir = Dir.glob("#{build}/*").find {|d| /Simulator-/.match(d)}
        unless sim_dir and File.directory?(sim_dir)
          App.fail "No Simulator dir found in #{build}. Please build app for simulator first."
        end
        app = Dir.glob("#{sim_dir}/*").find {|d| /\.app$/.match(d)}
        unless app and File.exist?(app)
          App.fail "No .app found in #{sim_dir}. Please build app for simulator first."
        end
        bundle_path = File.expand_path("#{app}")
      end
      App.fail "No app found in #{bundle_path} (APP_BUNDLE_PATH)" unless File.exist?(bundle_path)
      calabash_env["APP_BUNDLE_PATH"] = bundle_path
    end


    App.info 'Run', "#{calabash_env} cucumber #{args}"

    exec(calabash_env,"cucumber", *(args.split(' ')))
  end

  desc "Start Calabash console."
  task :console do
    # Retrieve configuration settings.
    calabash_env = gather_calabash_env
    cmd = "#{calabash_env[:str]} calabash-ios console"
    App.info 'Run', "#{calabash_env} calabash-ios console"

    exec(calabash_env,"calabash-ios","console")
  end

  desc "Scaffold Calabash features folder."
  task :scaffold do
     # Retrieve configuration settings.
     calabash_env = gather_calabash_env
     cmd = '(echo "" | calabash-ios gen) &> /dev/null'
     App.info 'Run', "Scaffolding features"
     App.info 'Info', "Run rake calabash:run to try"

     env_str = calabash_env.map {|envname, envval| "export #{envname}=#{envval};"}.join(" ")
     system("(#{env_str}) && #{cmd}")


     this_path = File.expand_path(__FILE__)
     launch_path = File.join(this_path,'..','..','..','..','scripts','launch.rb')
     launch_path = File.expand_path(launch_path)
     puts "Copy launch file #{launch_path} to features/support/launch.rb"
     FileUtils.cp(launch_path,File.join('features','support','launch.rb'))


  end

end

