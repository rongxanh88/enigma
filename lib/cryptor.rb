require './lib/key_gen'
require './lib/offset_gen'
require './lib/message_io'
require './lib/enigma_module'
require'pry'

class Cryptor
  attr_accessor :message, :key, :date
  
  def parse_and_split
    message = MessageIO.new(@message)
    message.parse
    message.split_into_sub_arrays
  end

  def key_into_rotation
    if key.nil?
      @key = KeyGen.new.generate_original
      offset_key = KeyGen.new.convert_key(key)
    else
      offset_key = KeyGen.new.convert_key(key)
    end
    offset_key
  end
  
  def date_into_offset
    if date.nil?
      @date = Date.today
      offset = OffsetGen.new.convert_into_offset 
      offset
    else
      OffsetGen.new(date).convert_into_offset
    end
  end

  def rotation_and_offset
    combo = key_into_rotation.zip(date_into_offset)
    combo.map!{|sub_array| sub_array.inject(&:+)}
  end
  
  def cipher(key, value)
    cipher_array = Cipher::CIPHER.zip(Cipher::CIPHER.rotate(key))
    cipher_hash(cipher_array, value)
  end

  def cipher_hash(array, value)
    cipher_hash = {}
    array.each do |sub_array| 
      cipher_hash[sub_array[0]] = sub_array[1]
    end
    cipher_hash[value]
  end

  def run_the_cipher(rotation)
    parse_and_split.map! do |sub|
      cipher_sub_array(sub, rotation)
    end.join
  end

  def cipher_sub_array(array, rotation)
    array.map!.with_index do |letter, index|
      cipher_sub_array = { 
        0 => cipher(rotation[0], letter),
        1 => cipher(rotation[1], letter),
        2 => cipher(rotation[2], letter),
        3 => cipher(rotation[3], letter),
      }
      cipher_sub_array[index]
    end
  end 
end

