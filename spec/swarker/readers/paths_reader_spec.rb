describe Swarker::Readers::PathsReader do
  let(:definitions_dir) { File.expand_path('spec/fixtures/service/api') }

  subject { Swarker::Readers::PathsReader.new(definitions_dir) }

  it 'read proper number of files' do
    expect(subject.paths.count).to eq(13)
  end

  it 'create only Path objects' do
    expect(subject.paths).to all(be_an(Swarker::Path))
  end

  it 'parse paths route properly' do
    expect(subject.paths.collect(&:path)).to include('/api/v1/users/{user_id}/repos/{id}.json')
    expect(subject.paths.collect(&:path)).to include('/api/v1/users/{id}.json')
    expect(subject.paths.collect(&:path)).to include('/api/v1/users.json')
  end
end
