require 'test_helper'

class FedoraRpmTest < ActiveSupport::TestCase
  test "obfuscated user returns well formatted name" do
    r = FedoraRpm.new
    r.fedora_user = "foo.bar@baz.com"
    assert r.obfuscated_fedora_user == "foo DOT bar AT baz DOT com", "obfuscated_fedora_user DID NOT returned a valid string: #{r.obfuscated_fedora_user}"
  end
  
  test "shortname returns name without rubygem-" do
    r = FedoraRpm.new
    r.name = "rubygem-foo"
    assert r.shortname == "foo", "RPM shortname did not return a valid string: #{r.shortname}"
    r.name = "foo_bar"
    assert r.shortname == "foo_bar", "RPM shortname did not return a valid string: #{r.shortname}"
  end
end
