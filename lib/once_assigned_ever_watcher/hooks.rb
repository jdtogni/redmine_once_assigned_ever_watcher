module OnceAssignedEverWatcher
  class Hooks < Redmine::Hook::ViewListener
  
    def controller_issues_edit_before_save (context={})
      if context[:issue] && context[:issue].id != nil                      
        issue = Issue.find_by_id(context[:issue].id)
        issue.custom_field_values.each do |value|
          if value.custom_field.name = 'PM Owner' || value.custom_field.name = 'Eng Owner'
            Watcher.find_or_create_by_watchable_type_and_watchable_id_and_user_id("Issue", 
                                                                                  context[:issue].id, 
                                                                                  value.value)
          end
        end       
        if issue.assigned_to_id != nil
          Watcher.find_or_create_by_watchable_type_and_watchable_id_and_user_id("Issue", 
                                                                                context[:issue].id, 
                                                                                issue.assigned_to_id)
        end
      end
    end
    
  end
end
