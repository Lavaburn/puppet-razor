require "spec_helper"

describe "razor_hook" do
  let (:title) { "example" }
  let (:params) {{
    :hook_type => "type",
    :configuration => {},
    :mutable_configuration => true,
  }}

  it { should compile }
  it { should contain_razor_hook("example").with_mutable_configuration(true) }
end
