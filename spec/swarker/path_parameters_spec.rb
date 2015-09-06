describe Swarker::PathParameters do
  context 'simple case on GET request' do
    let(:lurker_path) { YAML.load_file(File.expand_path('spec/fixtures/paths/get/lurker.json.yml')) }
    let(:limit_param) { { name: 'limit', description: '', type: 'string', default: '1', in: 'query' } }

    subject { Swarker::PathParameters.new(lurker_path) }

    it('recognise parameters') do
      expect(subject.parameters).to have(1).item
      expect(subject.parameters.first).to eq(limit_param)
    end
  end

  context 'complex case on POST request' do
    let(:lurker_path) { YAML.load_file(File.expand_path('spec/fixtures/paths/post/lurker.json.yml')) }
    let(:user_id_param) do
      { name: 'user_id', description: '', type: 'string', default: '1', in: 'query', required: true }
    end

    subject { Swarker::PathParameters.new(lurker_path) }

    it('recognise parameters') do
      expect(subject.parameters.count).to eq(2)
      expect(subject.parameters).to include(user_id_param)
    end
  end

  context 'complex case on request with formData and ref' do
    let(:lurker_path) { YAML.load_file(File.expand_path('spec/fixtures/paths/complex/lurker.json.yml')) }
    let(:user_param) do
      { name: 'user', description: '', in: 'formData', schema: { '$ref' => '#/definitions/user_request_parameters' } }
    end

    subject { Swarker::PathParameters.new(lurker_path) }

    it('recognise parameters') do
      expect(subject.parameters.count).to eq(2)
      expect(subject.parameters).to include(user_param)
    end
  end
end
