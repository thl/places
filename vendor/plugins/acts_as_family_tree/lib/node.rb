module MM::Acts::FamilyTree::Node
  
  def self.included(base)
    base.extend(ClassMethods)
  end
  
  ######
  module ClassMethods
    
    def init_acts_as_family_tree_node(options={})
      config = {:tree_class=>name + 'Tree'}
      config.update(options) if options.is_a?(Hash)
      raise 'Please specify a tree class. acts_as_family_tree :node, :tree_class=>"MyTreeClass"' if config[:tree_class].nil?
      
      relation_table = Kernel.const_get(config[:tree_class]).table_name
      
      config[:extensions] ||= {}
      config[:extensions][:child_relations] ||= nil
      config[:extensions][:parent_relations] ||= nil
      config[:extensions][:parents] ||= nil
      config[:extensions][:children] ||= nil
      
      has_many :parent_relations, :class_name=>config[:tree_class], :foreign_key=>:child_node_id, :dependent=>:destroy, :extend=>config[:extensions][:parent_relations], :conditions => config[:conditions]
      has_many :child_relations, :class_name=>config[:tree_class], :foreign_key=>:parent_node_id, :dependent=>:destroy, :extend=>config[:extensions][:child_relations], :conditions => config[:conditions]
      
      has_many :parents, :class_name=>name, :through=>:parent_relations, :source=>:parent_node, :extend=>config[:extensions][:parents], :conditions => config[:conditions]
      has_many :children, :class_name=>name, :through=>:child_relations, :source=>:child_node, :extend=>config[:extensions][:children], :conditions => config[:conditions]
      
      class_eval <<-EOV
        
        include MM::Acts::FamilyTree::Node::InstanceMethods
        
        #
        # Returns all root nodes
        #
        def self.roots
          joins("LEFT JOIN #{relation_table} b ON b.child_node_id = #{table_name}.id").where('b.child_node_id IS NULL')
          #.from("#{table_name} #{table_name}")
          #  with_scope(:find=>{:conditions=>conditions, :joins=>joins, :select=>'#{table_name}.*', :from=>"#{table_name} #{table_name}"}) do
          #    find(:all, *args)
          #  end
        end
      EOV
    end
    
  end
  
  ######
  module InstanceMethods
    
    #
    # Hacky way to get all 'my' parents
    # Order is 'oldest' parent first to self.parent
    #
    def all_parents
      parents_a = []
      p = parent
      until p.nil? || parents_a.include?(p)
        parents_a << p
        p = p.parent
      end
      parents_a.reverse
    end
    
    def parent
      parents.first
    end
    
    #
    # Find parent and/or child *relations*
    #
    def relations
      parent_relations.all + child_relations.all
    end
    
    #
    # Find siblings
    #
    def siblings
      p = parents
      return (self.class.roots - [self]) if p.empty?
      p.collect do |parent|
        parent.children
      end.flatten.uniq - [self]
    end
    
  end
  
end