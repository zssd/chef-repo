require 'rubygems'
require 'optparse'
 
class MakeBook
	# Define some class variables to
	# store configuration parameters
	attr_reader :optparse, :options, :mandatory, :arguments

	def initialize(arguments)
		@options = {}
		@optparse = OptionParser.new()
		@isvalid = true
		puts ""
		set_mandatory
		set_arguments(arguments)
		set_options
		validate
	end
 
	#Set mandatory configuration parameters
	def set_mandatory
		@mandatory = [:cookbookname]
	end
 
	#Handle arguments
	def set_arguments(arguments)
		return if arguments.nil?
		if(arguments.kind_of?(String))
			@arguments = arguments.split(/s{1,}/)
		elsif (arguments.kind_of?(Array))
			@arguments = arguments
		else
			raise Exception, "Expecting either String or an Array"
		end
	end
 
	#Use OptionParser library and
	# define some parameters
	def set_options
		@optparse.banner = "Usage: ruby #{File.basename(__FILE__)}"

		@options[:cookbookname] = nil
		@optparse.on('-c','--cookbookname BOOKNAME',String,'The name of the book to add'){|opt|
			@options[:cookbookname] = opt
		}

		@optparse.on('-h', '--help', 'Display this screen'){
            puts $!.to_s
            puts @optparse
            exit
		}
     end
 
     #Validate that mandatory parameters are specified
     def validate
         begin
            @optparse.parse!(@arguments)
            missing = @mandatory.select{|p| @options[p].nil? }
            if not missing.empty?
                puts "Missing options: #{missing.join(', ')}"
                puts @optparse
                @isvalid = false
            end
         rescue OptionParser::ParseError,
                OptionParser::InvalidArgument,
                OptionParser::InvalidOption,
                OptionParser::MissingArgument
                puts $!.to_s
                puts @optparse
                exit
         end
     end
 
	#Run your code
	def execute
		return if (@isvalid == false)
		puts "Creating cookbook: #{@options[:cookbookname]}"
		system "knife cookbook create #{@options[:cookbookname]}"

		puts "Move down a diretory for Berkshelf"
		Dir.chdir "../cookbooks"
		system "berks cookbook #{@options[:cookbookname]} --chef-minitest --skip-test-kitchen --foodcritic"

		puts "Changing directory to new cookbook"
		Dir.chdir @options[:cookbookname]

		puts "Make Book was successful"
	end
end #End of Class Test

if __FILE__ == $0
    cls = MakeBook.new(ARGV)
    cls.execute
end