require 'rails_helper'

RSpec.describe Tokite::SearchQuery, type: :model do
  describe ".parse" do
    subject { Tokite::SearchQuery.parse(query) }

    context "quoted text" do
      let(:query) { '"foo bar"' }

      it do
        expect(subject.size).to eq(1)
        expect(subject.first[:word].to_s).to eq('foo bar')
      end
    end

    context "quoted text with escaped quot" do
      let(:query) { '"foo\ \"bar\""' }

      it do
        expect(subject.size).to eq(1)
        expect(subject.first[:word].to_s).to eq('foo "bar"')
      end
    end

    context "regular expression" do
      let(:query) { '/foo bar/' }

      it do
        expect(subject.size).to eq(1)
        expect(subject.first[:regexp_word].to_s).to eq('foo bar')
      end
    end

    context "regular expression with escaped character" do
      let(:query) { '/\Afoo \/bar\/\z/' }

      it do
        expect(subject.size).to eq(1)
        expect(subject.first[:regexp_word].to_s).to eq('\Afoo /bar/\z')
      end
    end

    context "with field" do
      let(:query) { 'foo: bar' }

      it do
        expect(subject.size).to eq(1)
        expect(subject.first[:field].to_s).to eq('foo')
        expect(subject.first[:word].to_s).to eq('bar')
      end
    end
  end
end
