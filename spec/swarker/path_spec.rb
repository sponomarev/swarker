describe Swarker::Path do
  context 'on GET operation' do
    let(:swagger_path) { YAML.load_file(File.expand_path('spec/fixtures/paths/get/swagger.json.yml')) }
    let(:lurker_path) { YAML.load_file(File.expand_path('spec/fixtures/paths/get/lurker.json.yml')) }
    subject { Swarker::Path.new(:some_path, lurker_path) }

    it('recognise operation') { expect(subject.scheme).to have_key('get') }

    it('recognise description') { expect(subject.scheme['get']['description']).to eq('user listing') }

    it('recognise tags') { expect(subject.scheme['get']['tags']).to include('user listing') }

    it('recognise parameters') do
      expect(subject.scheme['get']['parameters'].count).to eq(1)
      expect(subject.scheme['get']['parameters'].first).to eq(
        'name'        => 'limit',
        'description' => '',
        'type'        => 'string',
        'default'     => '1',
        'in'          => 'query'
      )
    end

    it('recognise responses') do
      expect(subject.scheme['get']['responses'].count).to eq(1)
      expect(subject.scheme['get']['responses']).to include('200')
    end

    it 'converts path' do
      expect(subject.scheme).to eq(swagger_path)
    end
  end
end
