require 'lib/site_builder'

namespace :site do
  task :clean do
    `rm -rf data/*.json && rm -rf ./build/*`
  end

  desc 'Bootstrap the site'
  task bootstrap: [:clean, 'packages:download', 'categories:create', 'packages:import']

  desc 'Build the site'
  task :build do
    builder = SiteBuilder.new(url: ENV['BUILD_URL'])
    builder.start
  end

  desc 'Deploy the site to the gh-pages branch'
  task :deploy do
    system("cp ./CNAME build/CNAME && \
            cd build && \
            git init . && \
            git config user.name \"Deployer\" && \
            git config user.email \"deployer@atom-packages.directory\" && \
            git add . && \
            git commit -m \"Update Atom Packages Directory\"; \
            git push --force --quiet \"https://${GH_TOKEN}@${GH_REF}\" master:gh-pages; \
            rm -f -r .git/*")
  end
end
