describe Swarker::Definition do
  let(:swagger_definition) do
    YAML.load_file(File.expand_path('spec/fixtures/definitions/swagger.json.yml'))
  end
  let(:lurker_definition) do
    YAML.load_file(File.expand_path('spec/fixtures/definitions/lurker.json.yml'))
  end

  subject { Swarker::Definition.new(:user, lurker_definition) }

  it '#object has no required data' do
    expect(subject.schema['required']).to be_nil
  end

  it '#object convert required attributes' do
    expect(subject.schema['properties']['id']['required']).to be_truthy
  end

  it 'converts definition' do
    expect(subject.schema).to eq(swagger_definition)
  end
end
