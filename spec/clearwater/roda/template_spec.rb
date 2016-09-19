require 'clearwater/roda/template'

module Clearwater
  module Roda
    RSpec.describe Template do
      let(:template) { Template.new(input, output, options) }
      let(:input) { StringIO.new('My name is %{name}') }
      let(:output) { StringIO.new }
      let(:options) do
        {
          name: 'Jamie',
        }
      end

      it 'fills in template variables' do
        expect(template.content).to include 'My name is Jamie'
      end

      it 'writes to the specified output' do
        template.write
        output.rewind

        expect(output.read).to include 'My name is Jamie'
      end
    end
  end
end
