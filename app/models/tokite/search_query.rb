require "parslet"

module Tokite
  class SearchQuery
    attr_reader :query, :tree
  
    class ParseError < StandardError
    end
  
    class Parser < Parslet::Parser
      rule(:space) { match('\s').repeat(1) }
      rule(:space?) { space.maybe }
  
      rule(:escape) { str('\\').ignore }
      rule(:quot) { str('"') }
      rule(:quoted_char) { escape >> any | match('[^"]') }
      rule(:char) { match('[^\s]') }
      rule(:slash) { str('/') }
      rule(:regexp_char) { escape >> any | match('[^/]') }
  
      rule(:regexp_word) { slash >> regexp_char.repeat(1).as(:regexp_word) >> slash }
      rule(:quot_word) { quot >> quoted_char.repeat(1).as(:word) >> quot }
      rule(:plain_word) { (match('[^\s/"]') >> match('[^\s]').repeat).as(:word) }
      rule(:field) { match('\w').repeat(1).as(:field) }
      rule(:word) { (field >> str(':') >> space?).maybe >> (regexp_word | quot_word | plain_word) }
  
      rule(:query) { word >> (space >> word).repeat }
      root :query
    end
  
    def self.parser
      @parser ||= Tokite::SearchQuery::Parser.new
    end
  
    def self.parse(query)
      Array.wrap(parser.parse(query))
    rescue Parslet::ParseFailed => e
      raise ParseError, e
    end
  
    def initialize(query)
      @query = query
      @tree = Array.wrap(self.class.parse(query))
    end
  
    def match?(doc)
      tree.all? do |word|
        field = word[:field]
        if word[:regexp_word]
          regexp = word[:regexp_word].to_s
          if field
            doc[field.to_sym]&.match(regexp)
          else
            doc.values.any?{|text| text.match(regexp) }
          end
        else
          value = word[:word].to_s
          if field
            doc[field.to_sym]&.index(value)
          else
            doc.values.any?{|text| text.index(value) }
          end
        end
      end
    end
  end
end
