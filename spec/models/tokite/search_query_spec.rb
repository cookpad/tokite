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

    context "with -word" do
      let(:query) { '-foo:bar' }

      it do
        expect(subject.size).to eq(1)
        expect(subject.first[:field].to_s).to eq('foo')
        expect(subject.first[:word].to_s).to eq('bar')
        expect(subject.first[:exclude]).to be_present
      end
    end

    context "with some words" do
      let(:query) { '/./  -foo:"hoge fuga"' }

      it do
        expect(subject.size).to eq(2)
        expect(subject[0][:field]).not_to be_present
        expect(subject[0][:regexp_word].to_s).to eq('.')
        expect(subject[0][:word]).not_to be_present
        expect(subject[0][:exclude]).not_to be_present
        expect(subject[1][:field].to_s).to eq("foo")
        expect(subject[1][:regexp_word]).not_to be_present
        expect(subject[1][:word].to_s).to eq("hoge fuga")
        expect(subject[1][:exclude]).to be_present
      end
    end
  end
end
