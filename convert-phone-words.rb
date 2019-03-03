start = Time.now
require './available_words.rb'
finish = Time.now
p "time taken to load Dictionary hash #{finish - start}"

def match_key_to_number
  {
    2 => ['a', 'b', 'c'],
    3 => ['d', 'e', 'f'],
    4 => ['g', 'h', 'i'],
    5 => ['j', 'k', 'l'],
    6 => ['m', 'n', 'o'],
    7 => ['p', 'q', 'r', 's'],
    8 => ['t', 'u', 'v'],
    9 => ['w', 'x', 'y' 'z']
  }
end

def is_word_in_dictionary(word)
  Dictionary::WORDHASH[word.upcase].nil? ? false : true
end

def is_validate_phone(phone_number)
  if(phone_number.include?("0") || phone_number.include?("1"))
    false
  else
    true
  end
end

def convert_phone_to_word(phone_number)
  words_combinations = nil

  phone_number.to_s.split("").each do |number|
    get_key = match_key_to_number[number.to_i]
    if !words_combinations.nil?
      words_combinations = words_combinations.product(get_key)
    else
      words_combinations = get_key
    end
  end

  all_words = words_combinations.map { |word| word.flatten().join}
  all_words.select! { |w| is_word_in_dictionary(w) }
end

def phone_to_words(phone)

  if(is_validate_phone(phone))
    possible_match = convert_phone_to_word(phone)
    temp_phone = phone.clone
    first_word = ''
    last_word = ''

    possible_phone_combinations = []

    while temp_phone.size > 3 do
      first_word += temp_phone.slice!(0)
      last_word = temp_phone
      if (first_word.size >= 3)
        possible_phone_combinations << [convert_phone_to_word(first_word), convert_phone_to_word(last_word)]
      end
    end

  else
    raise "Phone number didn't accept '0' or '1' "
  end

  final_available_words = possible_phone_combinations.map { |a| a.reject(&:empty?) }
  final_available_words = final_available_words.map! do |words|
    if(words.length == 2)
      words.first.product(words.last)
    end
  end
  return ((final_available_words).compact! << possible_match).flatten(1)
end

start = Time.now
p phone_to_words("6686787825")
finish = Time.now
p "time taken to run 'phone_to_words(6686787825)' #{finish - start}"

start = Time.now
p phone_to_words("2282668687")
finish = Time.now
p "time taken to run 'phone_to_words(2282668687)' #{finish - start}"
