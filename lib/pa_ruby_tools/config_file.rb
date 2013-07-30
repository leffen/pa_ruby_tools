
require 'yaml'


module PaRubyTools

  class ConfigFile

    def load(file_name)
      file_name=find_config_file(File.basename(file_name)) unless File.exists?(file_name)
      return {} unless File.exists?(file_name)

      load_settings(file_name)
    end

    private

    def load_settings(file_name)
      YAML.load(File.read(file_name))
    end

    def find_config_file(file_name)
      fname  = check_current_dir_and_up
      return fname if fname

      ['DRG_HOME', 'HOME'].each do |env_var|
        if ENV[env_var]
          config_file_name = File.join(ENV[env_var],[file_name])
          return  config_file_name if File.exist?(config_file_name)
        end
      end

      nil
    end

    # Checks in current directory for a config file and walks the directory tree up to root for potential config files
    # copied from Chef config
    def check_current_dir_and_up
      full_path = Dir.pwd.split(File::SEPARATOR)
      (full_path.length - 1).downto(0) do |i|
        candidate_file = File.join(full_path[0..i] + [file_name])
        return candidate_file if File.exist?(candidate_file)
        candidate_file = File.join(full_path[0..i] +["config"] + [file_name])
        return candidate_file if File.exist?(candidate_file)
      end
      nil
    end

  end

end
