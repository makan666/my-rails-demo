# frozen_string_literal: true

namespace :svg_icons do
  desc 'generate svg icons.'
  task generate: :environment do
    dir_name = "#{Rails.root}/vendor/assets/javascripts/icons"
    Dir.mkdir(dir_name) unless File.exist?(dir_name)

    File.open "#{dir_name}/icons.coffee", 'w' do |f|
      f.puts %(SevenCars.iconsHtml = '''#{svg_html}''')
    end
  end

  private

  def svg_html
    %(<svg id="seven-car-icons" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" style="display:none">\n#{symbols}</svg>)
  end

  def svg_files
    @svg_files ||= Dir.glob(File.expand_path("#{::Rails.root}/app/assets/icons/*.svg")).uniq
  end

  def symbols
    svg_files.map { |file| "  #{symbol(file)}\n" }.join
  end

  def symbol(path)
    name = File.basename(path, '.*').underscore.dasherize
    content = File.read(path)
    content.gsub(/<?.+\?>/, '')
           .gsub(/<!.+?>/, '')
           .gsub(%r{/<title>.*<\/title>/}, '')
           .gsub(%r{/<desc>.*<\/desc>/}, '')
           .gsub(/id=/, 'class=')
           .gsub(/<svg.+?>/, %(<svg id="icon-#{name}" #{dimensions(content)}>))
           .gsub(/svg/, 'symbol')
           .gsub(/\sfill=".+?"/, '')
           .delete("\n") # Remove endlines
           .gsub(/\s{2,}/, ' ') # Remove whitespace
           .gsub(/>\s+</, '><') # Remove whitespace between tags
  end

  def dimensions(content)
    dimension = content.scan(/<svg.+(viewBox=["'](.+?)["'])/).flatten
    %(#{dimension.first} width="100%" height="100%")
  end
end
