class CourseDatatable
  delegate :params, to: :@view

  def initialize(view)
    @view = view
  end

  def as_json(options = {})
    {
      sEcho: params[:sEcho].to_i,
      iTotalRecords: Course.count,
      iTotalDisplayRecords: courses.total_entries,
      aaData: data
    }
  end

  private
  def data
    courses.map do |course|
      [
      ]
    end
  end

  def fetch_courses
    courses = Course.order("#{sort_column} #{sort_direction}")
    courses = courses.page(page).per_page(per_page)
    if params[:sSearch].present?
      courses = courses.where("name like :search or category like :search", search: "%#{params[:sSearch]}%")
    end
    products
  end
end