module ApplicationHelper
  def flash_class(level)
    case level
      when 'notice' then "alert alert-info"
      when 'success' then "alert alert-success"
      when 'error' then "alert alert-danger"
      when 'alert' then "alert alert-warning"
    else
      nil
    end
  end

  def yes_no_select
    return [[ 'YES', true ], [ 'NO', false ]]
  end

  def no_yes_select
    return yes_no_select.reverse!
  end

  def and_or_select
    return [[ 'AND', '0' ], [ 'OR', '1' ]]
  end

  def or_and_select
    return and_or_select.reverse!
  end
end