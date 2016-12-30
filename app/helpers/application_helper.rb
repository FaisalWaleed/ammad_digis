module ApplicationHelper
  def prescript_as_line_item(prescript = nil)
    return unless prescript.is_a?(Prescript)
    
    capture do
      content_tag(:span) do
        concat( prescript.drug.trade_name )
        concat( ' ' )
        concat( prescript.drug.generic_name )
        concat( ' ' )
        concat( (pluralize(prescript.dose.to_i, prescript.dosage_unit.name.humanize) rescue nil) )
        concat( ' ' )
        concat( prescript.dosage_route.code )
        concat( ' ' )
        concat( prescript.dosage_frequency.code )
        concat( ' ' )
        
        if prescript.dosage_duration
          concat( "x #{ prescript.dosage_duration.to_i }/#{ prescript.dosage_duration_unit.code }" )
        end
      end
    end
  end

  def alert_class_for(flash_type)
    {
      :success => 'alert-success',
      :error => 'alert-danger',
      :alert => 'alert-danger',
      :notice => 'alert-info'
    }[flash_type.to_sym] || flash_type.to_s
  end
end
