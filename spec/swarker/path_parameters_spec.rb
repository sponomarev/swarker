describe Swarker::Path do
  context 'simple case on GET request' do
    let(:lurker_path) { YAML.load_file(File.expand_path('spec/fixtures/paths/get/lurker.json.yml')) }
    let(:limit_param) { { name: 'limit', description: '', type: 'string', default: '1', in: 'query' } }

    subject { Swarker::PathParameters.new(lurker_path) }

    it('recognise parameters') do
      expect(subject.parameters.count).to eq(1)
      expect(subject.parameters.first).to eq(limit_param)
    end
  end
end
