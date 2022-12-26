# frozen_string_literal: true

module ProxyApp
  class Console
    def initialize
      @addition = ''
    end

    def print_title
      puts 'ProxyAPP'
      puts 'Type help to get usage information'
      puts 'Press Ctrl-D(Ctrl-Z on windows) or type exit to exit'
    end

    def addition(text)
      @addition = text
    end

    def run
      loop do
        print_header
        line = getline
        break unless line

        line = line.strip

        yield line
      end
      puts
    end

    private

    def print_header
      print "#{@addition}> "
    end

    def getline
      $stdin.gets
    end
  end
end
