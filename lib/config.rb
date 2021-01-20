# frozen_string_literal: true

##
# Game configuration
class Config < Hashugar
  def load
    conf_dir = SDL2.preference_path('inexcomp', 'untitledgame')
    FileUtils.mkdir_p(conf_dir)

    config_path = File.join(conf_dir, 'config.yml')

    Config.write_default(config_path) # unless File.exist?(config_path)

    initialize(YAML.load_file(config_path) || {})
  end

  # rubocop: disable Metrics/MethodLength
  def self.write_default(path)
    default_conf = {
      resolution: {
        width: 800,
        height: 600
      },
      font_sizes: {
        label: 12,
        text: 16,
        header: 24,
        title: 36
      },
      fonts: {
        mono_regular: 'SourceCodePro-Regular.ttf',
        mono_bold: 'SourceCodePro-Bold.ttf',
        sans_regular: 'SourceSans3-Regular.ttf',
        sans_bold: 'SourceSans3-Bold.ttf',
        sans_italic: 'SourceSans3-It.ttf'
      }
    }

    File.write(path, YAML.dump(default_conf))
  end
  # rubocop: enable Metrics/MethodLength
end
