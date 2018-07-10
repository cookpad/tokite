require "parslet"

module Tokite
  class SearchQuery
    attr_reader :query, :tree

    DEFAULT_FIELDS = %i(title body)

    class ParseError < StandardError
    end
  
    class Parser < Parslet::Parser
      rule(:space) { match('\s').repeat(1) }
      rule(:space?) { space.maybe }
  
      rule(:quot) { str('"') }
      rule(:quoted_char) { (str('\\').ignore >> any) | match('[^"]') }
      rule(:char) { match('[^\s]') }
      rule(:slash) { str('/') }
      rule(:regexp_char) { (str('\\').ignore >> slash) | match('[^/]') }
  
      rule(:regexp_word) { slash >> regexp_char.repeat(1).as(:regexp_word) >> slash }
      rule(:quot_word) { quot >> quoted_char.repeat(1).as(:word) >> quot }
      rule(:plain_word) { (match('[^\s/"]') >> match('[^\s]').repeat).as(:word) }
      rule(:exclude) { match('-').as(:exclude) }
      rule(:field) { match('\w').repeat(1).as(:field) }
      rule(:word) { exclude.maybe >> (field >> str(':') >> space?).maybe >> (regexp_word | quot_word | plain_word) }
  
      rule(:query) { space? >> word >> (space >> word).repeat >> space? }
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

    def self.verify_query(query)
      tree = Array.wrap(self.parse(query))
      tree.each do |word|
        regexp = Regexp.compile(word[:regexp_word].to_s, Regexp::IGNORECASE) if word[:regexp_word]
      end
      true
    rescue RegexpError
      false
    end

    def initialize(query)
      @query = query
      @tree = Array.wrap(self.class.parse(query))
    end
  
    def match?(doc)
      tree.all? do |word|
        field = word[:field]
        if field
          targets = doc[field.to_sym] ? [doc[field.to_sym].downcase] : []
        else
          targets = DEFAULT_FIELDS.map{|field| doc[field]&.downcase }.compact
        end
        if word[:regexp_word]
          begin
            regexp = Regexp.compile(word[:regexp_word].to_s, Regexp::IGNORECASE)
            matched = targets.any?{|text| regexp.match?(text) }
          rescue RegexpError
            matched = false
          end
        else
          value = word[:word].to_s.downcase
          matched = targets.any?{|text| text.index(value) }
        end
        word[:exclude].present? ? !matched : matched
      end
    end
  end
end
