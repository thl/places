module MM::Acts::FamilyTree::AncestorsAndDescendants
  
  def self.included(base)
    base.extend(ClassMethods)
  end
  
  ######
  module ClassMethods
    
    def init_acts_as_family_tree_anc_and_desc(options={})
      # Before saving, set the ancestor_ids
      
      #
      # NOTE: instead of putting this directory in AAFT, you can choose to implement it if needed
      #
      
      # before_save {|record| record.send :update_ancestor_ids }
      #
      # After saving, update the descendant nodes
      # This doesn't need to use the recursive method
      # because the before_save update_ancestor_ids callback
      # has correctly setup the ancestor_ids field
      #
      #after_save do |record|
      #  # record.send :update_descendant_ancestor_ids
      #  #puts 'ActsAsFamilyTree -> after save'
      #end
      
      class_eval do
        include MM::Acts::FamilyTree::AncestorsAndDescendants::InstanceMethods
      end
    end
    
    #
    # Helper to setup the ancestor_ids fields if needed
    #
    def reset_ancestor_ids
      #puts 'ActsAsFamilyTree -> reset_ancestor_ids'
      find(:all).each {|r| r.update_ancestor_ids and r.update_descendant_ancestor_ids}
    end
    
  end
  
  ######
  module InstanceMethods
    #
    # All descendants - uses ancestor_ids field
    # can pass in a hash with the standard find params (:conditions, :joins, :include etc.)
    # ModelTree.find(1).descendants(:include=>[:names])
    #
    def descendants
      self.class.where([self.class.table_name + '.ancestor_ids LIKE ?', "%.#{self.id}.%"])
    end
    
    #
    # All ancestors - depends on ancestor_ids field !!!
    # can pass in a hash with the standard find params (:conditions, :joins, :include etc.)
    # ModelTree.find(5).ancestors(:include=>[:names])
    #
    def ancestors
      return [] if self.ancestor_ids.blank?
      conditions=[[]]
      ids = self.ancestor_ids.split('.').delete_if(&:blank?)
      ids.each do |id|
        conditions[0] << "#{self.class.table_name}.id = ?"
        conditions << id
      end
      conditions[0]=conditions[0].join(' OR ')
      self.class.where(conditions)
    end

    #
    # Ancestor *relations* finder (not recursive anymore) - no need to use ancestor_ids
    #
    def ancestors_r
      # fetch all parents
      pending = [self]
      ans = []
      while !pending.empty?
        e = pending.pop
        e.parents.each do |p|
          if !ans.include?(p)
            ans << p
            pending.push(p)
          end
        end
      end
      ans
    end
    
    #
    # Descendant *relations* finder (recursive!) - no need to use ancestor_ids
    #
    def descendants_r
      pending = [self]
      des = []
      while !pending.empty?
        e = pending.pop
        e.children.each do |c|
          if !des.include?(c)
            des << c
            pending.push(c)
          end
        end
      end
      des
    end
    
    def generate_ancestor_ids
      ids = ancestors_r.map(&:id).join('.')
      ids.blank? ? '' : ".#{ids}."
    end
    
    #
    # updates the ancestor_ids field for this record and then
    # each of the descendants ancestor_ids fields
    #
    def update_hierarchy
      update_ancestor_ids and update_descendant_ancestor_ids
    end
    
    def update_ancestor_ids
      # puts 'ActsAsFamilyTree -> update_ancestor_ids'
      # Here, we MUST call the recursive version of ancestors,
      # beause the regular "ancestors" method depends on what this
      # method does (creates the ancestor_ids)
      value = generate_ancestor_ids
      self.update_attributes({:ancestor_ids => value, :skip_update => true}) if self.ancestor_ids != value
    end
    
    #
    # By calling save on all descendants, they each call update_ancestor_ids
    #
    def update_descendant_ancestor_ids
      #puts 'ActsAsFamilyTree -> update_descendant_ancestor_ids'
      #puts 'Executing update_descendant_ancestor_ids'
      descendants_r.each {|desc| desc.update_ancestor_ids }
    end
  end
  
end