class ListDecorator < Draper::Decorator
  delegate_all
  decorates :list 
  decorates_association :songs
  decorates_finders

  def name
  	model.title
  end

  # Define presentation-specific methods here. Helpers are accessed through
  # `helpers` (aka `h`). You can override attributes, for example:
  #
  #   def created_at
  #     helpers.content_tag :span, class: 'time' do
  #       source.created_at.strftime("%a %m/%d/%y")
  #     end
  #   end

end
