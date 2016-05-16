
module Categories
  class Creator
    include Permalink

    attr_accessor :config_file,
                  :config

    def initialize
      self.config_file = File.join(File.dirname(__FILE__), '../config.yml')
      self.config = YAML.load_file(config_file)

      build
    end

    def build
      Category.all.each(&:destroy)

      build_category_tree

      Category.all.each(&:update_counts)
    end

    def build_category_tree(categories: config['base_categories'], parent_category: nil)
      categories.each do |category|
        name = category[0].dup
        sub_categories = category[1]

        if sub_categories
          keywords = category[1]['keywords']
          category[1].delete('keywords')

          exclude_keywords = category[1]['exclude_keywords']
          category[1].delete('exclude_keywords')
        else
          keywords = []
          exclude_keywords = []
        end

        new_category = Category.where(name: name, parent_category: parent_category)
                       .first_or_create!(keywords: keywords, exclude_keywords: exclude_keywords)

        if sub_categories
          build_category_tree(categories: category[1], parent_category: new_category)
        end
      end
    end
  end
end
