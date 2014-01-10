module LawsHelper
  def date_str date
    date.strftime('%Y-%m-%d') unless date.nil?
  end
end
