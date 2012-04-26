module MM::Acts::FamilyTree::Tree
  
  def self.included(base)
    base.extend(ClassMethods)
  end
  
  ######
  module ClassMethods
    
    def init_acts_as_family_tree_tree(options={})
      config = {:node_class=>nil}
      config.update(options) if options.is_a?(Hash)
      raise 'Please specify a node class. acts_as_family_tree :tree, :node_class=>"MyNodeClass"' if config[:node_class].nil?
      
      config[:extensions] ||= {}
      config[:extensions][:child_node] ||= nil
      config[:extensions][:parent_node] ||= nil
      
      belongs_to :child_node, :class_name=>config[:node_class], :foreign_key=>:child_node_id, :extend=>config[:extensions][:child_node]
      belongs_to :parent_node, :class_name=>config[:node_class], :foreign_key=>:parent_node_id, :extend=>config[:extensions][:parent_node]
      validates_presence_of :child_node_id, :parent_node_id
      
      class_eval do
        include MM::Acts::FamilyTree::Tree::InstanceMethods
      end
    end
    
    #
    # Returns all root relations
    # Don't rely on this to get root *nodes* though...
    # A root node may NOT have a relationship (child-less)
    #
    def roots
      #return find_by_sql("select a.* from #{table_name} as a left join #{table_name} b on a.parent_node_id = b.child_node_id where b.child_node_id IS NULL")
      joins("LEFT JOIN #{table_name} b ON #{table_name}.parent_node_id = b.child_node_id").where('b.child_node_id IS NULL')
      #.from("#{table_name} #{table_name}")
      #with_scope(:find=>{:conditions=>conditions, :joins=>joins, :select=>'#{table_name}.*', :from=>"#{table_name} #{table_name}"}) do
      #  find(:all, *args)
      #end
    end
    
  end
  
  ######
  module InstanceMethods
    
    def parent_node?(node)
      parent_node==node
    end
    
    def child_node?(node)
      child_node==node
    end
    
    def other_node(node)
      unless [parent_node,child_node].include? node
        raise 'This node is not a child or parent within this relation'
      end
      node == parent_node ? child_node : parent_node
    end
    
    #
    # Parent *relations* finder (relations that have their child_node_id set to this parent_node_id)
    # Tree.find_parents(:all, :conditions=>[])
    #
    def find_parents
      self.class.where(:child_node_id => self.parent_node_id)
    end
    
    #
    # find all parent relations
    #
    def parents
      find_parents
    end
    
    #
    # Returns first parent
    #
    def parent
      find_parents.first
    end
    
    #
    # Children *relations* finder (relations that have their parent_node_id set to this child_node_id)
    # Tree.find_children(:conditions=>[])
    #
    def children
      self.class.where(:parent_node_id => self.child_node_id)
    end
    
    #
    # Sibling *relations* finder (relations that have their parent_node_id set to this child_node_id)
    # Tree.find_children(:conditions=>[])
    #
    def siblings
      self.class.where(['id != ? AND (parent_node_id=? OR child_node_id=?)', self.id, self.parent_node_id, self.child_node_id])
    end
    
  end
  
end