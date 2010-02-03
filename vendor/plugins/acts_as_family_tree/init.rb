#
# Get right inside of ActiveRecord and include these setup methods
#
class << ActiveRecord::Base
  
  def acts_as_family_tree(role, options={})
    include MM::Acts::FamilyTree::AncestorsAndDescendants
    init_acts_as_family_tree_anc_and_desc(options)
    if role==:tree
      include MM::Acts::FamilyTree::Tree
      init_acts_as_family_tree_tree(options)
    elsif role==:node
      include MM::Acts::FamilyTree::Node
      init_acts_as_family_tree_node(options)
    else
      raise 'acts_as_family_tree requires that you specify a role of :tree or :node - "acts_as_family_tree :node"'
    end
  end
  
end

# Load up the module/class libary
require 'acts_as_family_tree'