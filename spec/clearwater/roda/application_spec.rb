require 'clearwater/roda/application'

module Clearwater
  module Roda
    # There isn't much we can unit-test here because most of it modifies the
    # filesystem. We could add integration specs to test this behavior, though.
    # I'm just too lazy to do that for a prototype. :-)
    RSpec.describe Application do
      let(:app) { Application.new(name) }
      let(:name) { 'foo_bar' }

      it 'lowercases and underscores app directory name' do
        expect(Application.new('FooBar').dir_name).to eq 'foo_bar'
        expect(Application.new('fooBar').dir_name).to eq 'foo_bar'
        expect(Application.new('foo_bar').dir_name).to eq 'foo_bar'
      end

      it 'title-cases the class name' do
        expect(Application.new('FooBar').class_name).to eq  'FooBar'
        expect(Application.new('fooBar').class_name).to eq  'FooBar'
        expect(Application.new('foo_bar').class_name).to eq 'FooBar'
      end
    end
  end
end
