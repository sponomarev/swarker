describe Swarker::Definition do
  let(:swagger_definition) do
    Swarker::Json::Reader.new(File.expand_path('../../fixtures/definitions/swagger.json.yml', __FILE__)).read
  end
  let(:lurker_definition) do
    Swarker::Json::Reader.new(File.expand_path('../../fixtures/definitions/lurker.json.yml', __FILE__)).read
  end

  subject { Swarker::Definition.new(:user, lurker_definition) }

  it '#object has no required data' do
    expect(subject.object['required']).to be_nil
  end

  it '#object convert required attributes' do
    expect(subject.object['properties']['id']['required']).to be_truthy
  end

  it 'converts definition' do
    expect(subject.object).to eq(swagger_definition)
  end
end
