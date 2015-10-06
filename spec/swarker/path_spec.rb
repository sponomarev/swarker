describe Swarker::Path do
  context 'on GET operation' do
    let(:swagger_path) { YAML.load_file(File.expand_path('spec/fixtures/paths/get/swagger.json.yml')) }
    let(:lurker_path) { YAML.load_file(File.expand_path('spec/fixtures/paths/get/lurker.json.yml')) }
    subject { Swarker::Path.new(:some_path, lurker_path) }

    it('recognise operation') do
      expect(subject.schema).to have_key('get')
      expect(subject.verb).to eq('get')
    end

    it('recognise description') { expect(subject.schema['get']['description']).to eq('user listing') }

    it('recognise tags') { expect(subject.schema['get']['tags']).to include('users management') }

    it('recognise parameters') do
      expect(subject.schema['get']['parameters'].count).to eq(1)
      expect(subject.schema['get']['parameters'].first).to eq(
        'name'        => 'limit',
        'description' => '',
        'type'        => 'string',
        'default'     => '1',
        'in'          => 'query'
      )
    end

    it('recognise responses') do
      expect(subject.schema['get']['responses'].count).to eq(1)
      expect(subject.schema['get']['responses']).to include('200')
    end

    it 'converts path' do
      expect(subject.schema).to eq(swagger_path)
    end
  end

  context 'on POST operation' do
    let(:verb) { 'post' }

    let(:swagger_path) { YAML.load_file(File.expand_path('spec/fixtures/paths/post/swagger.json.yml')) }
    let(:lurker_path) { YAML.load_file(File.expand_path('spec/fixtures/paths/post/lurker.json.yml')) }
    subject { Swarker::Path.new(:some_path, lurker_path) }

    it('recognise operation') { expect(subject.schema).to have_key(verb) }

    it 'converts ref in responses schema' do
      expect(subject.schema[verb][:responses]['200'][:schema]['$ref']).to eq('#/definitions/repo')
    end

    it('recognise parameters') do
      expect(subject.schema[verb][:parameters].count).to eq(swagger_path[verb]['parameters'].count)
    end

    it 'converts path' do
      expect(subject.schema).to eq(swagger_path)
    end
  end

  context 'preparsed scheme' do
    let(:swagger_path) { YAML.load_file(File.expand_path('spec/fixtures/paths/get/swagger.json.yml')) }
    subject { Swarker::Path.new(:some_path, swagger_path, true) }

    it 'store path without conversion' do
      expect(subject.schema).to eq(swagger_path)
      expect(subject.name).to eq(:some_path)
    end
  end
end
