require "spec_helper"

describe "Hash" do

  it "compact" do
    hash = { "a" => "", "b" => nil, "c" => "hello" }
    hash_compacted = { "c" => "hello" }
    assert_equal hash_compacted, hash.compact
  end

  it "cleanup" do
    whitelist = %w(controller action id input layout resource resource_id resource_action selected back_to )
    whitelist.each do |w|
      expected = { w => w }
      assert_equal expected, expected.dup.cleanup
    end
  end

  it "cleanup rejects unwanted stuff" do
    hash = {"attribute" => "dragonfly"}
    expected = {}
    assert_equal expected, hash.cleanup
  end

end
