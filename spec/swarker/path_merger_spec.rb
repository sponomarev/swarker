describe Swarker::PathsMerger do
  let(:paths_dir) { File.expand_path('spec/fixtures/service/api') }
  let(:original_paths) { Swarker::Readers::PathsReader.new(paths_dir).paths }
  subject { Swarker::PathsMerger.new(original_paths) }

  it 'find propper number of paths groups' do
    expect(subject.original_paths.count).to eq(13)
    expect(subject.paths.count).to eq(12)
  end

  it 'create only Path objects' do
    expect(subject.paths).to all(be_an(Swarker::Path))
  end

  let(:merged_path) do
    subject.paths.find do |path|
      path.verb == 'patch' && path.path == '/api/v1/users/{user_id}/repos/{id}.json'
    end
  end

  it 'merge responses of paths with the same action and route' do
    expect(merged_path.scheme['patch']['responses'].count).to eq(2)
    expect(merged_path.scheme['patch']['responses']).to include('200')
    expect(merged_path.scheme['patch']['responses']).to include('400')
  end
end
