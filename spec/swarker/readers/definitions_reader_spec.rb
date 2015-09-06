describe Swarker::Readers::DefinitionsReader do
  let(:definitions_dir) { File.expand_path('spec/fixtures/service/definitions') }

  subject { Swarker::Readers::DefinitionsReader.new(definitions_dir) }

  it 'read proper number of files' do
    expect(subject.definitions.count).to eq(3)
  end

  it('create only Definition objects') { expect(subject.definitions).to all(be_an(Swarker::Definition)) }

  it 'parse definition name properly' do
    expect(subject.definitions.collect(&:name)).to match_array(%w(repo user user_request_parameters))
  end
end
