describe Swarker::Json::Reader do
  let(:document) do
    {
      'array'   => [1, 2, 3],
      'boolean' => true,
      'null'    => nil,
      'number'  => 123,
      'object'  => { 'a' => 'b', 'c' => 'd', 'e' => 'f' },
      'string'  => 'Hello World'
    }
  end

  let(:json_document_path) { File.expand_path('../../../fixtures/document.json', __FILE__) }
  let(:yml_document_path) { File.expand_path('../../../fixtures/document.json.yml', __FILE__) }
  let(:erb_document_path) { File.expand_path('../../../fixtures/document.json.yml.erb', __FILE__) }

  it '#read json document' do
    expect(Swarker::Json::Reader.new(json_document_path).read).to eq(document)
  end

  it '#read yml document' do
    expect(Swarker::Json::Reader.new(yml_document_path).read).to eq(document)
  end

  it '#read erb document' do
    expect(Swarker::Json::Reader.new(erb_document_path).read).to eq(document)
  end
end
