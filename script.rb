require './commands'
# require './related_words'

def item_xml(options = {})
  <<-ITEM
  <item arg="#{options[:arg]}" uid="#{options[:uid]}">
    <title>#{options[:title]}</title>
    <subtitle>#{options[:subtitle]}</subtitle>
  </item>
  ITEM
end

def match?(word, query)
  word.match(/#{query}/i)
end

query = Regexp.escape(ARGV.first).delete('>')

# matches = RELATED_WORDS.select { |k, v| match?(k, query) || v.any? { |r| match?(r, query) } }
matches = COMMANDS.select { |k, v| match?(k, query) || match?(v, query) }

# 1.8.7 returns a [['key', 'value']] instead of a Hash.
# matches = matches.respond_to?(:keys) ? matches.keys : matches.map(&:first)

items = matches.sort.map do |key, value|
  title = "#{value}: #{key}"
  arg = ARGV.size > 1 ? COMMANDS.fetch(key, command) : value
  item_xml({ :arg => arg, :uid => value, :title => title,
             :subtitle => "Copy #{arg} to clipboard" })
end.join

output = "<?xml version='1.0'?>\n<items>\n#{items}</items>"

puts output
