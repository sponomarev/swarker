describe Swarker::Readers::FileReader do
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

  let(:json_document_path) { File.expand_path('spec/fixtures/document.json') }
  let(:yml_document_path) { File.expand_path('spec/fixtures/document.json.yml') }
  let(:erb_document_path) { File.expand_path('spec/fixtures/document.json.yml.erb') }

  it '#read json document' do
    expect(Swarker::Readers::FileReader.new(json_document_path).read).to eq(document)
  end

  it '#read yml document' do
    expect(Swarker::Readers::FileReader.new(yml_document_path).read).to eq(document)
  end

  it '#read erb document' do
    expect(Swarker::Readers::FileReader.new(erb_document_path).read).to eq(document)
  end
end
