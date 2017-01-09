shared_examples 'an idempotent manifest' do
  it 'should make changes the first time' do
    result = apply_manifests(agents, pp, { :expect_changes => true })
    expect(result.exit_code).to eq(2)
  end

  it 'be idempotent on the second run' do
    result = apply_manifests(agents, pp, { :catch_changes => true })
    expect(result.exit_code).to eq(0)    
  end
end
