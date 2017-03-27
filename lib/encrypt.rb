require './lib/cryptor'
require './lib/message_io'
require 'pry'

class Encrypt
  def initialize(input=nil, output=nil, key=nil, date=nil)
    @input = input
    @output = output
    @key = key
    @date = date
    @mode = :ENCRYPT
  end
  
  def encrypt
    messenger = MessageIO.new(@input)
    @input = messenger.read_file
    e = Cryptor.new(@input, @key, @date)
    message = e.crypt(@mode)
    messenger.write_file(@output, message)
    p "Created #{@output} with key of #{e.key} and date #{e.date}"
  end
  
end

###########################################

#e = Encrypt.new(ARGV[0], ARGV[1])
#e.encrypt