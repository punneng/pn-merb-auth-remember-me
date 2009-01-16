# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{pn-merb-auth-remember-me}
  s.version = "0.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Surasit Liangpornrattana"]
  s.date = %q{2009-01-12}
  s.description = %q{Merb plugin that provides remember me for merb-auth-slice-password}
  s.email = %q{punneng@gmail.com}
  s.extra_rdoc_files = ["README", "LICENSE", "TODO"]
  s.files = ["LICENSE", "README", "Rakefile", "TODO", "lib/pn-merb-auth-remember-me", "lib/pn-merb-auth-remember-me/merbtasks.rb", "lib/pn-merb-auth-remember-me/mixins", "lib/pn-merb-auth-remember-me/mixins/authenticated_user", "lib/pn-merb-auth-remember-me/mixins/authenticated_user/ar_authenticated_user.rb", "lib/pn-merb-auth-remember-me/mixins/authenticated_user/dm_authenticated_user.rb", "lib/pn-merb-auth-remember-me/mixins/authenticated_user/sq_authenticated_user.rb", "lib/pn-merb-auth-remember-me/mixins/authenticated_user.rb", "lib/pn-merb-auth-remember-me/strategies", "lib/pn-merb-auth-remember-me/strategies/remember_me.rb", "lib/pn-merb-auth-remember-me.rb", "spec/mixins", "spec/mixins/authenticated_user_spec.rb", "spec/pn-merb-auth-remember-me_spec.rb", "spec/spec_helper.rb", "spec/strategies", "spec/strategies/remember_me_spec.rb"]
  s.has_rdoc = true
  s.homepage = %q{http://www.punneng.net/pn-remember-me (should be github)}
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{merb}
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{Merb plugin that provides remember me for merb-auth-slice-password}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<merb>, [">= 1.0.3"])
    else
      s.add_dependency(%q<merb>, [">= 1.0.3"])
    end
  else
    s.add_dependency(%q<merb>, [">= 1.0.3"])
  end
end
