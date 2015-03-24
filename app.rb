require 'bundler'
Bundler.require

require 'dinosaurus'

Dinosaurus.configure do |config|
  config.api_key = '840954d2475f6ca8b3bd02ceedbf93a9'
end


# paragraphs run sentences *5 and push each sentence into an array, pages *25, join the sentences with paragraph tags
def randsentences
  if @sentences > @paragraphs && @sentences > @pages
  elsif @paragraphs > @sentences && @paragraphs > @pages
    @sentences = @paragraphs*15
  elsif @pages > @sentences && @pages > @paragraphs
    @sentences = @pages*25
  end

  @sentences -= 1
  synonyms = Dinosaurus.synonyms_of(@word)
  synonyms += Dinosaurus.synonyms_of(@word2)

  word_array = synonyms.uniq

  lookup = Dinosaurus.lookup(@word)
  @nouns = lookup["noun"]["syn"]
  @verbs = lookup["verb"]["syn"]

  second_lookup = Dinosaurus.lookup(@word2)
  @nouns += second_lookup["noun"]["syn"]
  @verbs += second_lookup["verb"]["syn"]

  third_lookup = Dinosaurus.lookup(@word3)
  if third_lookup.keys.include?("noun")
    third_nouns = third_lookup["noun"]["syn"]
  else
    @nouns = []
  end

  third_verbs = third_lookup["verb"]["syn"]

  @nouns += third_nouns
  @verbs += third_verbs

  @starting_words = ["The", "A", "An", "They", "There"]
  @sentence_array = []
  @firstsentence = "Lorem ipsum #{@word} #{@word2} #{@word3}. "
  @sentence_array.push @firstsentence

  @sentences.times do
    @next_sentence = "#{@starting_words.sample} #{@nouns.sample} #{@nouns.sample} #{@verbs.sample}. "
    @sentence_array.push @next_sentence
  end
@sentence_array.join("")
  end

get '/' do
  erb :main

end

post '/' do
  @word, @word2, @word3 = params[:word].to_s, params[:word2].to_s, params[:word3].to_s
  @sentences, @paragraphs, @pages = params[:sentences].to_i, params[:paragraphs].to_i, params[:pages].to_i
  erb :result
end
